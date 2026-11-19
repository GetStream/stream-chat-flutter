import 'dart:async';

import 'package:clock/clock.dart';
import 'package:logging/logging.dart';

import '../../core/api/responses.dart';
import '../../core/api/scheduled_messages_api.dart';
import '../../core/error/stream_chat_error.dart';
import '../../core/models/attachment_file.dart';
import '../../core/models/channel_state.dart';
import '../../core/models/event.dart';
import '../../core/models/message.dart';
import '../../core/models/scheduled_message.dart';
import '../../core/util/in_flight_cache.dart';
import '../../core/util/scheduled_message_rules.dart';
import '../../event_type.dart';
import '../attachment/attachment_uploader.dart';
import '../attachment/message_attachment_uploader.dart';
import '../attachment/scheduled_message_attachment_uploader.dart';
import '../client.dart';
import 'scheduled_message_event_handler.dart';
import 'scheduled_message_list_state.dart';
import 'scheduled_messages_query.dart';

/// The runner of the current user's scheduled message requests, which applies
/// their events.
///
/// The events of its client, including the ones its own requests emit, update
/// its [state].
class ScheduledMessageManager {
  /// Creates a manager for the scheduled messages of `client`.
  ///
  /// The `logger` logs its warnings.
  ScheduledMessageManager(this._client, {this._logger}) {
    _eventsSubscription = _client.eventStream.listen(_onEvent);
  }

  static const _pageSize = 100;

  final StreamChatClient _client;
  final Logger? _logger;
  ScheduledMessagesApi get _api => _client.chatApi.scheduledMessages;

  final _stateNotifier = ScheduledMessageListStateNotifier();
  late final _eventHandler = ScheduledMessageEventHandler(state: _stateNotifier);
  late final StreamSubscription<Event> _eventsSubscription;

  // The load of the complete list, shared while it runs.
  var _loadCache = InFlightCache<String, ScheduledMessageListState>();

  // Whether the complete list was loaded when the connection was lost.
  var _wasLoadedBeforeConnectionLost = false;

  // Bumped by clear, so a request that started before it is not applied.
  var _generation = 0;

  // The attachment uploaders, one per channel cid.
  final _uploaders = <String, ChannelAttachmentUploader>{};

  // The attachment upload of each scheduled message waiting for it.
  final _uploads = <String, MessageAttachmentsUpload>{};

  static const _attachmentUploadFailed = StreamChatError(
    'Failed to upload one or more attachments',
  );

  static const _uploadCanceled = StreamChatError(
    'The attachment uploads were canceled',
  );

  /// The scheduled messages, and whether the complete list is loaded.
  ScheduledMessageListState get state => _stateNotifier.state;

  /// The [state], emitted on listen and again each time it changes.
  Stream<ScheduledMessageListState> get stream => _stateNotifier.stream;

  /// Queries the page of the scheduled messages that [query] describes.
  ///
  /// The page is added to [ScheduledMessageListState.scheduledMessages];
  /// nothing is removed.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails.
  Future<QueryScheduledMessagesResponse> queryMessages(
    ScheduledMessagesQuery query,
  ) async {
    final generation = _generation;
    final response = await _api.queryScheduledMessages(query);

    if (generation == _generation) {
      _stateNotifier.onQueryScheduledMessages(response.scheduledMessages);
    }

    return response;
  }

  /// Loads the complete list of scheduled messages.
  ///
  /// It replaces [ScheduledMessageListState.scheduledMessages], keeping the
  /// ones still being scheduled or whose request failed. If a page fails, the
  /// ones before it are added, nothing is removed, and the error is rethrown.
  /// Calling this again while it runs shares the load.
  ///
  /// Returns the [state] once the list is loaded.
  Future<ScheduledMessageListState> loadMessages() {
    return _loadCache.run('all', () async {
      final generation = _generation;
      final loaded = <ScheduledMessage>[];

      String? next;
      do {
        final response = await queryMessages(ScheduledMessagesQuery(limit: _pageSize, next: next));

        loaded.addAll(response.scheduledMessages);
        next = response.next;
      } while (next != null && next.isNotEmpty && generation == _generation);

      if (generation == _generation) {
        _stateNotifier.onLoadScheduledMessages(loaded);
      }

      return state;
    });
  }

  /// Schedules [message] to be sent at [scheduledAt].
  ///
  /// The message goes to the channel [channelId] of [channelType]. It is
  /// listed right away as [ScheduledMessageStatus.preparingToSchedule], then
  /// replaced by the scheduled one. If the request fails in a way that can be
  /// retried, it stays listed as failed with
  /// [ScheduledMessageFailureReason.requestFailed]; any other failure removes
  /// it.
  ///
  /// The attachments of [message] that are not uploaded yet are uploaded
  /// first, their progress shown on the listed message. If one fails to
  /// upload, the message stays listed as failed with
  /// [ScheduledMessageFailureReason.attachmentUploadFailed], with that
  /// attachment's [Attachment.uploadState] failed.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails.
  ///
  /// Throws a [ScheduledMessageRefusedError] without making the request when
  /// [message] is a command in a channel that has commands, or quotes a
  /// deleted message.
  ///
  /// Throws an [ArgumentError] if [scheduledAt] is not in the future. A
  /// message to send right away goes through [StreamChatClient.sendMessage].
  ///
  /// Throws a [StreamChatError] if an attachment fails to upload, if
  /// [deleteMessage] deletes it while its attachments upload, or if sending it
  /// right away is refused.
  ///
  /// Throws a [StateError] if no user is connected.
  Future<ScheduleMessageResponse> scheduleMessage(
    Message message,
    String channelId,
    String channelType, {
    required DateTime scheduledAt,
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) async {
    if (!scheduledAt.isAfter(clock.now())) {
      throw ArgumentError.value(
        scheduledAt,
        'scheduledAt',
        'Must be in the future. To send the message now, use sendMessage.',
      );
    }

    return _schedule(
      message,
      channelId,
      channelType,
      scheduledAt: scheduledAt,
      skipPush: skipPush,
      skipEnrichUrl: skipEnrichUrl,
    );
  }

  // Schedules [message] at [scheduledAt], which can have passed: it is then
  // sent right away.
  Future<ScheduleMessageResponse> _schedule(
    Message message,
    String channelId,
    String channelType, {
    required DateTime scheduledAt,
    bool skipPush = false,
    bool skipEnrichUrl = false,
  }) async {
    final user = _client.state.currentUser;
    if (user == null) throw StateError('Connect a user before scheduling messages.');

    final cid = '$channelType:$channelId';
    _refuseUnschedulable(cid, message);

    final generation = _generation;

    // ignore: parameter_assignments
    message = message.copyWith(
      attachments: message.attachments.map(
        (it) {
          if (it.uploadState.isSuccess) return it;
          return it.copyWith(uploadState: const UploadState.preparing());
        },
      ).toList(),
    );

    final now = clock.now();
    var local = ScheduledMessage(
      cid: cid,
      user: user,
      message: message,
      scheduledAt: scheduledAt,
      status: .preparingToSchedule,
      localCreatedAt: now,
      localUpdatedAt: now,
    );

    // Cancelling previous scheduling in case it's called again in the process.
    _cancelUploads(local.id);

    _emitEvent(EventType.scheduledMessageCreated, local, generation);

    try {
      if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
        // ignore: parameter_assignments
        message = await _uploadAttachments(local, generation);
        local = local.copyWith(message: message);

        // Fail the whole message if any attachment failed to upload
        if (message.attachments.any((it) => it.uploadState.isFailed)) {
          throw _attachmentUploadFailed;
        }
      }

      final response = await _api.scheduleMessage(
        channelId,
        channelType,
        message,
        scheduledAt,
        skipPush: skipPush,
        skipEnrichUrl: skipEnrichUrl,
      );

      if (response.scheduledMessage case final created?) {
        _emitEvent(EventType.scheduledMessageCreated, created, generation);
      } else if (response.message.type == MessageType.error) {
        // Its time had passed, but sending it right away was refused, for
        // example in a frozen channel.
        throw StreamChatError(response.message.text ?? 'The message was refused');
      } else {
        // Its time had passed, so it was sent right away.
        final messageId = response.message.id;
        _emitEvent(EventType.scheduledMessageSent, _sent(local), generation, messageId: messageId);
      }

      return response;
    } catch (error) {
      // Cancelled by a deletion or by a newer call for the same message, which
      // now owns its state.
      if (error == _uploadCanceled) rethrow;

      if (error is! StreamChatNetworkError && error != _attachmentUploadFailed) {
        _emitEvent(EventType.scheduledMessageDeleted, _canceled(local), generation);
        rethrow;
      }

      if (error is StreamChatNetworkError) {
        // Already sent: on a retry, the first attempt went through, scheduled
        // or sent right away.
        final isSent = error.scheduledMessageErrorReason == .scheduledMessageAlreadySent;
        if (isSent || error.isMessageAlreadyExistsError) {
          _emitEvent(EventType.scheduledMessageSent, _sent(local), generation);
          rethrow;
        }

        if (!error.isRetriable) {
          _emitEvent(EventType.scheduledMessageDeleted, _canceled(local), generation);
          rethrow;
        }
      }

      final reason = switch (error) {
        _attachmentUploadFailed => ScheduledMessageFailureReason.attachmentUploadFailed,
        _ => ScheduledMessageFailureReason.requestFailed,
      };

      final failed = local.copyWith(
        status: .failed,
        failureReason: reason,
        localUpdatedAt: clock.now(),
      );

      _emitEvent(EventType.scheduledMessageUpdated, failed, generation);
      rethrow;
    }
  }

  /// Makes the request of the scheduled message [id] again after it failed.
  ///
  /// One whose scheduling failed is scheduled again, keeping its ID so it is
  /// never scheduled twice. One whose edit failed is saved again with its
  /// message and time, as [updateMessage] does. Resolves to the scheduled
  /// message, or null when its time had passed and it was sent right away.
  ///
  /// Its attachments that failed to upload are uploaded again.
  ///
  /// Its [ScheduledMessage.failureReason] must be retriable.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, or a
  /// [StreamChatError] if an attachment fails to upload again.
  ///
  /// Throws a [StateError] if [id] isn't listed, as there is no failed request
  /// to make again, or if no user is connected when it is scheduled again.
  Future<ScheduledMessage?> resendMessage(String id) async {
    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) throw StateError('No scheduled message $id to resend.');

    assert(
      scheduledMessage.failureReason?.isRetriable ?? false,
      'Only a scheduled message whose request failed can be resent.',
    );

    if (scheduledMessage.failureReason == .updateFailed) {
      final response = await updateMessage(
        id,
        scheduledMessage.message,
        scheduledAt: scheduledMessage.scheduledAt,
      );

      return response.scheduledMessage;
    }

    final [channelType, channelId] = scheduledMessage.cid.split(':');
    final response = await _schedule(
      scheduledMessage.message,
      channelId,
      channelType,
      scheduledAt: scheduledMessage.scheduledAt,
    );

    return response.scheduledMessage;
  }

  /// Edits the scheduled message [id].
  ///
  /// Its message is replaced with [message], and it is moved to [scheduledAt]
  /// if given. The edit is listed right away as
  /// [ScheduledMessageStatus.preparingToSchedule], and the attachments of
  /// [message] that are not uploaded yet are uploaded first, their progress
  /// shown on it. If the request or an upload fails, it stays listed as failed
  /// with [ScheduledMessageFailureReason.updateFailed].
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, even when the
  /// scheduled message is already gone. If it is, an
  /// [EventType.scheduledMessageDeleted] event reports it, so [state] stops
  /// listing it.
  ///
  /// Throws a [StreamChatError] if an attachment fails to upload.
  ///
  /// Throws a [ScheduledMessageRefusedError] without making the request when
  /// [message] is a command in a channel that has commands, or quotes a
  /// deleted message.
  /// If it isn't listed, the request is made without these checks or changing
  /// the list first, then lists the copy it answers with.
  ///
  /// Throws an [ArgumentError] if it isn't listed and an attachment of
  /// [message] is not uploaded yet, as its channel to upload to is unknown.
  ///
  /// Throws a [StateError] if its attachments are still uploading to schedule
  /// it, as it isn't scheduled yet.
  Future<UpdateScheduledMessageResponse> updateMessage(
    String id,
    Message message, {
    DateTime? scheduledAt,
  }) async {
    Future<UpdateScheduledMessageResponse> request(Message message) {
      return _api.updateScheduledMessage(id, message: message, scheduledAt: scheduledAt);
    }

    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) {
      if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
        throw ArgumentError.value(message, 'message', 'Attachments must be uploaded before updating');
      }

      return _updateUnlisted(() => request(message));
    }

    _refuseWhileScheduling(scheduledMessage);
    _refuseUnschedulable(scheduledMessage.cid, message);

    return _edit(
      scheduledMessage,
      scheduledMessage.copyWith(message: message, scheduledAt: scheduledAt),
      request,
    );
  }

  /// Moves the scheduled message [id] to [scheduledAt].
  ///
  /// Its message stays as it is; one whose edit failed has that edit saved
  /// with the move. It is listed at its new time right away, as with
  /// [updateMessage].
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, even when the
  /// scheduled message is already gone. If it is, an
  /// [EventType.scheduledMessageDeleted] event reports it, so [state] stops
  /// listing it.
  ///
  /// Throws a [ScheduledMessageRefusedError] without making the request when
  /// it is moved to another time but is a command in a channel that has
  /// commands, or quotes a deleted message.
  /// If it isn't listed, the request is made without these checks or changing
  /// the list first, then lists the copy it answers with.
  ///
  /// Throws a [StateError] if its attachments are still uploading to schedule
  /// it, as it isn't scheduled yet.
  Future<UpdateScheduledMessageResponse> rescheduleMessage(
    String id, {
    required DateTime scheduledAt,
  }) async {
    Future<UpdateScheduledMessageResponse> request() {
      return _api.updateScheduledMessage(id, scheduledAt: scheduledAt);
    }

    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) return _updateUnlisted(request);

    _refuseWhileScheduling(scheduledMessage);

    // A failed edit isn't saved yet, so moving it saves the edit too.
    if (scheduledMessage.failureReason == .updateFailed) {
      return updateMessage(id, scheduledMessage.message, scheduledAt: scheduledAt);
    }

    // A message kept at its time isn't checked again.
    if (!scheduledAt.isAtSameMomentAs(scheduledMessage.scheduledAt)) {
      _refuseUnschedulable(scheduledMessage.cid, scheduledMessage.message);
    }

    return _edit(
      scheduledMessage,
      scheduledMessage.copyWith(scheduledAt: scheduledAt),
      (_) => request(),
    );
  }

  /// Sends the scheduled message [id] right away.
  ///
  /// It is listed as [ScheduledMessageStatus.sending] once the request
  /// succeeds, until it is sent.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, even when the
  /// scheduled message is already gone. If it is, an
  /// [EventType.scheduledMessageDeleted] event reports it, so [state] stops
  /// listing it.
  ///
  /// Throws a [ScheduledMessageRefusedError] without making the request when
  /// it quotes a deleted message, which would fail it once sent. If it isn't
  /// listed, the request is made without these checks or changing the list.
  ///
  /// Throws a [StateError] if its attachments are still uploading to schedule
  /// it, as it isn't scheduled yet.
  Future<SendScheduledMessageNowResponse> sendMessageNow(String id) async {
    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) return _api.sendScheduledMessageNow(id);

    _refuseWhileScheduling(scheduledMessage);
    _refuseDeletedQuote(scheduledMessage.cid, scheduledMessage.message);
    _cancelUploads(scheduledMessage.id);

    final generation = _generation;
    final response = await _request(
      scheduledMessage,
      generation,
      () => _api.sendScheduledMessageNow(scheduledMessage.id),
    );

    // Its sent event can arrive first, which stops listing it.
    final isListed = _listedScheduledMessage(id) != null;
    if (isListed) {
      final sending = response.scheduledMessage.copyWith(status: .sending, localUpdatedAt: clock.now());
      _emitEvent(EventType.scheduledMessageUpdated, sending, generation);
    }

    return response;
  }

  /// Deletes the scheduled message [id].
  ///
  /// One still uploading its attachments to be scheduled is removed without a
  /// request, and its uploads are canceled. One whose attachments failed to
  /// upload is removed without a request too. An edit still uploading its
  /// attachments is stopped, and listed again as failed if the request fails.
  ///
  /// A listed one stops being listed right away, and is listed again if the
  /// request fails, unless it is already gone. One whose scheduling failed is
  /// deleted even if scheduling it never went through. One not listed is
  /// deleted without changing the list.
  ///
  /// The returned scheduled message has the status it had when it was
  /// deleted.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails. Deleting one
  /// already gone throws too, unless its own scheduling had failed.
  Future<DeleteScheduledMessageResponse> deleteMessage(String id) async {
    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) return _api.deleteScheduledMessage(id);

    final generation = _generation;

    // One still being scheduled, or whose attachments failed to upload, never
    // reached the server.
    final wasWaiting = _cancelUploads(scheduledMessage.id);
    final isScheduling = wasWaiting && scheduledMessage.remoteCreatedAt == null;
    final isUploadFailed = scheduledMessage.failureReason == .attachmentUploadFailed;
    if (isScheduling || isUploadFailed) {
      final canceled = _canceled(scheduledMessage);
      _emitEvent(EventType.scheduledMessageDeleted, canceled, generation);
      return DeleteScheduledMessageResponse()..scheduledMessage = canceled;
    }

    if (scheduledMessage.failureReason == .requestFailed) {
      try {
        final response = await _api.deleteScheduledMessage(scheduledMessage.id);
        _emitEvent(EventType.scheduledMessageDeleted, response.scheduledMessage, generation);
        return response;
      } on StreamChatNetworkError catch (error) {
        if (!error.isScheduledMessageNotFound) rethrow;

        final canceled = _canceled(scheduledMessage);
        _emitEvent(EventType.scheduledMessageDeleted, canceled, generation);
        return DeleteScheduledMessageResponse()..scheduledMessage = canceled;
      }
    }

    _emitEvent(EventType.scheduledMessageDeleted, _canceled(scheduledMessage), generation);

    // An edit stopped while it uploaded is listed again as failed, to save it
    // again or delete it.
    final relisted = wasWaiting
        ? scheduledMessage.copyWith(
            status: ScheduledMessageStatus.failed,
            failureReason: ScheduledMessageFailureReason.updateFailed,
            localUpdatedAt: clock.now(),
          )
        : scheduledMessage;

    return _request(
      scheduledMessage,
      generation,
      () => _api.deleteScheduledMessage(scheduledMessage.id),
      relistOnFailure: relisted,
      relistIfUnlisted: true,
    );
  }

  /// Replaces the scheduled messages of each channel in [channelStates] with
  /// its [ChannelState.scheduledMessages].
  ///
  /// A channel whose state has none is left as it is. The ones still being
  /// scheduled, or whose request failed, are kept.
  void onChannelsQueried(List<ChannelState> channelStates) {
    final channels = <ChannelScheduledMessages>[];
    for (final channelState in channelStates) {
      final cid = channelState.channel?.cid;
      final scheduledMessages = channelState.scheduledMessages;
      if (cid == null || scheduledMessages == null) continue;

      channels.add((cid: cid, scheduledMessages: scheduledMessages));
    }

    if (channels.isEmpty) return;
    _stateNotifier.onChannelsQueried(channels);
  }

  void _onEvent(Event event) {
    _eventHandler.handleEvent(event);

    if (event.type == EventType.connectionChanged && event.online == false) {
      _onConnectionLost();
    }

    if (event.type == EventType.connectionRecovered) {
      _onConnectionRecovered().ignore();
    }
  }

  // Changes may be missed while the connection is down.
  void _onConnectionLost() {
    _wasLoadedBeforeConnectionLost |= state.hasLoadedAll;
    _stateNotifier.onConnectionLost();
  }

  Future<void> _onConnectionRecovered() async {
    if (!_wasLoadedBeforeConnectionLost) return;

    try {
      await loadMessages();
      _wasLoadedBeforeConnectionLost = false;
    } catch (error, stackTrace) {
      _logger?.warning('Failed to reload the scheduled messages', error, stackTrace);
    }
  }

  // Lists [edited] as being saved while its attachments upload and [request]
  // saves it over [scheduledMessage], then the saved copy. If an upload or the
  // request fails, [edited] stays listed as failed, unless the message is
  // being sent or is gone.
  Future<UpdateScheduledMessageResponse> _edit(
    ScheduledMessage scheduledMessage,
    ScheduledMessage edited,
    Future<UpdateScheduledMessageResponse> Function(Message message) request,
  ) async {
    // Cancelling previous scheduling in case it's called again in the process.
    _cancelUploads(scheduledMessage.id);

    final generation = _generation;
    var saving = edited.copyWith(
      status: .preparingToSchedule,
      failureReason: null,
      localUpdatedAt: clock.now(),
      message: edited.message.copyWith(
        attachments: edited.message.attachments.map(
          (it) {
            if (it.uploadState.isSuccess) return it;
            return it.copyWith(uploadState: const UploadState.preparing());
          },
        ).toList(),
      ),
    );

    _emitEvent(EventType.scheduledMessageUpdated, saving, generation);

    if (saving.message.attachments.any((it) => !it.uploadState.isSuccess)) {
      final uploaded = await _uploadAttachments(saving, generation);
      saving = saving.copyWith(message: uploaded);

      // Fail the whole edit if any attachment failed to upload
      if (uploaded.attachments.any((it) => it.uploadState.isFailed)) {
        final failed = saving.copyWith(
          status: .failed,
          failureReason: ScheduledMessageFailureReason.updateFailed,
          localUpdatedAt: clock.now(),
        );

        _emitEvent(EventType.scheduledMessageUpdated, failed, generation);
        throw _attachmentUploadFailed;
      }
    }

    final failed = saving.copyWith(
      status: .failed,
      failureReason: ScheduledMessageFailureReason.updateFailed,
    );

    final response = await _request(
      scheduledMessage,
      generation,
      () => request(saving.message),
      relistOnFailure: failed,
    );

    // The API answers a move to the same time with the version it already had.
    // Mark it as changed here, so it still replaces the copy being saved.
    final saved = response.scheduledMessage;
    final isSameVersion = saved.remoteUpdatedAt == scheduledMessage.remoteUpdatedAt;
    final listed = isSameVersion ? saved.copyWith(localUpdatedAt: clock.now()) : saved;

    // It can be sent or deleted while the edit is saved.
    if (_listedScheduledMessage(scheduledMessage.id) != null) {
      _emitEvent(EventType.scheduledMessageUpdated, listed, generation);
    }

    return response;
  }

  // Uploads the attachments of [scheduledMessage] that are not uploaded yet,
  // showing their progress on it, and resolves to its message.
  //
  // Throws [_uploadCanceled] if [_cancelUploads] stops them, even once they
  // have finished.
  Future<Message> _uploadAttachments(
    ScheduledMessage scheduledMessage,
    int generation,
  ) async {
    void onUpdated(ScheduledMessage scheduledMessage) {
      final updated = scheduledMessage.copyWith(localUpdatedAt: clock.now());
      _emitEvent(EventType.scheduledMessageUpdated, updated, generation);
    }

    final uploader = _uploaderFor(scheduledMessage.cid);
    final upload = uploader.uploadScheduledMessageAttachments(
      scheduledMessage,
      onUpdated: onUpdated,
    );

    final id = scheduledMessage.id;
    _uploads[id] = upload;
    final result = await upload.result;

    // Deleted, replaced or cleared while it waited.
    if (!identical(_uploads[id], upload)) throw _uploadCanceled;
    _uploads.remove(id);

    return result.message;
  }

  // Cancels the attachment uploads of the scheduled message [id], so what
  // waits for them throws.
  //
  // Returns whether it was waiting for them.
  bool _cancelUploads(String id) {
    final upload = _uploads.remove(id);
    upload?.cancel();
    return upload != null;
  }

  // Refuses to change [scheduledMessage] while it is first being scheduled,
  // as there is nothing to change yet.
  void _refuseWhileScheduling(ScheduledMessage scheduledMessage) {
    final isUploading = _uploads.containsKey(scheduledMessage.id);
    if (isUploading && scheduledMessage.remoteCreatedAt == null) {
      throw StateError('Scheduled message ${scheduledMessage.id} is not scheduled yet.');
    }
  }

  // The uploader of attachments to the channel [cid].
  ChannelAttachmentUploader _uploaderFor(String cid) {
    return _uploaders.putIfAbsent(cid, () {
      final [channelType, channelId] = cid.split(':');
      return ChannelAttachmentUploader(
        client: _client,
        channelId: channelId,
        channelType: channelType,
      );
    });
  }

  // Runs [request] on [scheduledMessage]. If it fails, one the request finds
  // gone is reported deleted, as its own event may have been missed; one
  // being sent is listed as sending; any other lists [relistOnFailure], if
  // given.
  Future<T> _request<T>(
    ScheduledMessage scheduledMessage,
    int generation,
    Future<T> Function() request, {
    ScheduledMessage? relistOnFailure,
    bool relistIfUnlisted = false,
  }) async {
    try {
      return await request();
    } catch (error) {
      // Gone already, so it isn't listed again.
      if (error case StreamChatNetworkError(scheduledMessageErrorReason: .scheduledMessageAlreadySent)) {
        _emitEvent(EventType.scheduledMessageSent, _sent(scheduledMessage), generation);
        rethrow;
      }
      if (error
          case StreamChatNetworkError(isScheduledMessageNotFound: true) ||
              StreamChatNetworkError(scheduledMessageErrorReason: .scheduledMessageCanceled)) {
        _emitEvent(EventType.scheduledMessageDeleted, _canceled(scheduledMessage), generation);
        rethrow;
      }

      // One sent or deleted while the request ran isn't listed again, unless
      // [relistIfUnlisted], as for one taken out of the list before it.
      final isListed = _listedScheduledMessage(scheduledMessage.id) != null;
      if (!isListed && !relistIfUnlisted) rethrow;

      if (_isRefusedAsSending(error)) {
        _emitEvent(EventType.scheduledMessageUpdated, _sending(scheduledMessage), generation);
      } else if (relistOnFailure != null) {
        _emitEvent(EventType.scheduledMessageUpdated, relistOnFailure, generation);
      }

      rethrow;
    }
  }

  // The scheduled message with [id] in the client's list, if it is listed.
  ScheduledMessage? _listedScheduledMessage(String id) {
    return state.scheduledMessages.where((it) => it.id == id).firstOrNull;
  }

  // Makes [request] to change a scheduled message that isn't listed, so
  // nothing is listed before it, then lists the copy it answers with.
  Future<UpdateScheduledMessageResponse> _updateUnlisted(
    Future<UpdateScheduledMessageResponse> Function() request,
  ) async {
    final generation = _generation;
    final response = await request();
    _emitEvent(EventType.scheduledMessageUpdated, response.scheduledMessage, generation);
    return response;
  }

  // Refuses [message] in the channel [cid] when it can't be scheduled: when
  // it quotes a deleted message, or when it is a command.
  void _refuseUnschedulable(String cid, Message message) {
    _refuseDeletedQuote(cid, message);

    final channel = _client.state.channels[cid];
    if (ScheduledMessageRules.isCommand(message, channel)) {
      throw const ScheduledMessageRefusedError(.slashCommand, "Commands can't be scheduled");
    }
  }

  // Refuses [message] in the channel [cid] when it quotes a deleted message.
  // Sending now checks only this, as a deleted quote would fail it once sent.
  void _refuseDeletedQuote(String cid, Message message) {
    final channel = _client.state.channels[cid];
    if (ScheduledMessageRules.quotesDeletedMessage(message, channel)) {
      throw const ScheduledMessageRefusedError(.quotedMessageDeleted, "Can't quote a deleted message");
    }
  }

  // Whether [error] refused a request as the message is being sent.
  bool _isRefusedAsSending(Object error) {
    if (error is! StreamChatNetworkError) return false;
    return error.scheduledMessageErrorReason == .scheduledMessageSending;
  }

  // [scheduledMessage], marked sent.
  ScheduledMessage _sent(ScheduledMessage scheduledMessage) {
    return scheduledMessage.copyWith(
      status: .sent,
      localUpdatedAt: clock.now(),
    );
  }

  // [scheduledMessage], marked being sent.
  ScheduledMessage _sending(ScheduledMessage scheduledMessage) {
    return scheduledMessage.copyWith(
      status: .sending,
      failureReason: null,
      localUpdatedAt: clock.now(),
    );
  }

  // [scheduledMessage], marked canceled.
  ScheduledMessage _canceled(ScheduledMessage scheduledMessage) {
    return scheduledMessage.copyWith(
      status: .canceled,
      failureReason: null,
      localUpdatedAt: clock.now(),
    );
  }

  // Reports [scheduledMessage] as an event of [type], unless the user changed
  // since the request that produced it started.
  //
  // [messageId] is the ID of the message it was sent as, when known.
  void _emitEvent(
    String type,
    ScheduledMessage scheduledMessage,
    int generation, {
    String? messageId,
  }) {
    if (generation != _generation) return;

    final event = Event(
      type: type,
      cid: scheduledMessage.cid,
      // The owner is the current user, whose latest data a replayed copy
      // could otherwise overwrite.
      user: _client.state.currentUser,
      messageId: messageId,
      scheduledMessage: scheduledMessage,
    );

    _client.handleEvent(event);
  }

  /// Forgets the scheduled messages.
  ///
  /// Used when the user disconnects.
  void clear() {
    _generation++;
    for (final upload in _uploads.values) {
      upload.cancel();
    }
    _uploads.clear();
    _loadCache = InFlightCache<String, ScheduledMessageListState>();
    _wasLoadedBeforeConnectionLost = false;
    _stateNotifier.clear();
  }

  /// Stops following the events and updating the [state].
  Future<void> dispose() async {
    await _eventsSubscription.cancel();
    await _stateNotifier.dispose();
  }
}
