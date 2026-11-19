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

  // The IDs of the new scheduled messages deleted while being scheduled, to
  // delete on the server once scheduling them ends.
  final _deletedWhileScheduling = <String>{};

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
  /// The attachments of [message] not uploaded yet are uploaded first, with
  /// their progress shown on the listed message. If one fails, its
  /// [Attachment.uploadState] is failed and the message stays listed as failed
  /// with [ScheduledMessageFailureReason.attachmentUploadFailed].
  ///
  /// Throws a [StreamChatNetworkError] if the request fails.
  ///
  /// Throws a [ScheduledMessageRefusedError] without making the request when
  /// [message] is a command in a channel that has commands, quotes a deleted
  /// message, or can't be sent at its time: one past the channel's
  /// [ChannelConfig.scheduledMessagesMaxLeadTime], at or after its pin
  /// expires, or less than a minute before its shared location ends.
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
    _refuseUnschedulableAt(cid, message, scheduledAt);

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

    // Stops the attachment upload of an earlier call for the message.
    _cancelUploads(local.id);

    _emitEvent(EventType.scheduledMessageCreated, local, generation);

    // Whether it was deleted while it was being scheduled.
    bool isDeleted() => _deletedWhileScheduling.contains(local.id);

    try {
      if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
        final result = await _uploadAttachments(local, generation);
        // ignore: parameter_assignments
        message = result.message;
        local = local.copyWith(message: message);

        if (result is MessageAttachmentsUploadFailed) {
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

      // One taken out of the list meanwhile isn't listed again.
      final isListed = _listedScheduledMessage(local.id) != null;
      if (response.scheduledMessage case final created?) {
        if (isDeleted()) {
          // Listed again if deleting it fails, so it can be deleted again.
          final isGone = await _deleteScheduledOnServer(created.id);
          if (!isGone) _emitEvent(EventType.scheduledMessageCreated, created, generation);
        } else if (isListed) {
          _emitEvent(EventType.scheduledMessageCreated, created, generation);
        }
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
    } on StreamChatNetworkError catch (error) {
      // Already sent: on a retry, the first attempt went through, scheduled
      // or sent right away.
      final isSent = error.scheduledMessageErrorReason == .scheduledMessageAlreadySent;
      if (isSent || error.isMessageAlreadyExistsError) {
        _emitEvent(EventType.scheduledMessageSent, _sent(local), generation);
        rethrow;
      }

      final failed = local.copyWith(
        status: .failed,
        failureReason: ScheduledMessageFailureReason.requestFailed,
        localUpdatedAt: clock.now(),
      );

      // A deleted one is already taken out of the list. Unless the server
      // refused it, it may have stored it, so it is deleted there too, and
      // listed as failed again if that fails, so it can be deleted again.
      if (isDeleted()) {
        if (error.isRetriable && !await _deleteScheduledOnServer(local.id)) {
          _emitEvent(EventType.scheduledMessageUpdated, failed, generation);
        }
        rethrow;
      }

      if (!error.isRetriable) {
        _emitEvent(EventType.scheduledMessageDeleted, _canceled(local), generation);
        rethrow;
      }

      // One taken out of the list meanwhile isn't listed again.
      final isListed = _listedScheduledMessage(local.id) != null;
      if (isListed) _emitEvent(EventType.scheduledMessageUpdated, failed, generation);
      rethrow;
    } catch (error) {
      // Canceled by a deletion or a newer call for the message, which now owns
      // its state.
      if (error == _uploadCanceled || isDeleted()) rethrow;

      if (error == _attachmentUploadFailed) {
        final failed = local.copyWith(
          status: .failed,
          failureReason: ScheduledMessageFailureReason.attachmentUploadFailed,
          localUpdatedAt: clock.now(),
        );

        _emitEvent(EventType.scheduledMessageUpdated, failed, generation);
        rethrow;
      }

      _emitEvent(EventType.scheduledMessageDeleted, _canceled(local), generation);
      rethrow;
    } finally {
      _deletedWhileScheduling.remove(local.id);
    }
  }

  // Deletes the scheduled message [id] on the server after it was deleted
  // while being scheduled, and returns whether it is gone. One the server no
  // longer has, or already sent, is gone too.
  Future<bool> _deleteScheduledOnServer(String id) async {
    try {
      await _api.deleteScheduledMessage(id);
      return true;
    } on StreamChatNetworkError catch (error, stackTrace) {
      final isGone = switch (error) {
        StreamChatNetworkError(isScheduledMessageNotFound: true) => true,
        StreamChatNetworkError(scheduledMessageErrorReason: .scheduledMessageAlreadySent) => true,
        StreamChatNetworkError(scheduledMessageErrorReason: .scheduledMessageCanceled) => true,
        _ => false,
      };

      if (!isGone) _logger?.warning('Failed to delete the scheduled message $id', error, stackTrace);
      return isGone;
    } catch (error, stackTrace) {
      _logger?.warning('Failed to delete the scheduled message $id', error, stackTrace);
      return false;
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
  /// Throws a [StreamChatNetworkError] if the request fails, or a
  /// [StreamChatError] if an attachment fails to upload again.
  ///
  /// Throws a [StateError] if [id] isn't listed, or failed in a way that
  /// can't be retried, as there is no failed request to make again, or if no
  /// user is connected when it is scheduled again.
  Future<ScheduledMessage?> resendMessage(String id) async {
    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) throw StateError('No scheduled message $id to resend.');

    final failureReason = scheduledMessage.failureReason;
    if (failureReason?.isEditFailure ?? false) {
      final response = await updateMessage(
        id,
        scheduledMessage.message,
        scheduledAt: scheduledMessage.scheduledAt,
      );

      return response.scheduledMessage;
    }

    if (!(failureReason?.isRetriable ?? false)) {
      throw StateError('Only a scheduled message whose request failed can be resent.');
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
  /// [message] not uploaded yet are uploaded first, with their progress shown
  /// on it. If an upload or the request fails, it stays listed as failed: with
  /// [ScheduledMessageFailureReason.updateFailed] when the error is temporary,
  /// or with [ScheduledMessageFailureReason.updateRejected] otherwise.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, even when the
  /// scheduled message is already gone. If it is, an
  /// [EventType.scheduledMessageDeleted] event reports it, so [state] stops
  /// listing it.
  ///
  /// Throws a [ScheduledMessageRefusedError] without making the request when
  /// [message] is a command in a channel that has commands, quotes a deleted
  /// message, or can't be sent at its time: one past the channel's
  /// [ChannelConfig.scheduledMessagesMaxLeadTime], at or after its pin
  /// expires, or less than a minute before its shared location ends.
  /// If it isn't listed, the request is made without these checks or changing
  /// the list first, then lists the copy it answers with.
  ///
  /// Throws a [StreamChatError] if an attachment of [message] fails to upload.
  ///
  /// Throws an [ArgumentError] if it isn't listed and an attachment of
  /// [message] is not uploaded yet, as its channel to upload to is unknown.
  ///
  /// Throws a [StateError] while it is still uploading attachments to be
  /// scheduled.
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
    _refuseUnschedulableAt(
      scheduledMessage.cid,
      message,
      scheduledAt ?? scheduledMessage.scheduledAt,
      // A message kept at its time isn't checked against the lead time again.
      checkLeadTime: scheduledAt != null && !scheduledAt.isAtSameMomentAs(scheduledMessage.scheduledAt),
    );

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
  /// commands, quotes a deleted message, or can't be sent at the new time: one
  /// past the channel's [ChannelConfig.scheduledMessagesMaxLeadTime], at or
  /// after its pin expires, or less than a minute before its shared location
  /// ends.
  /// If it isn't listed, the request is made without these checks or changing
  /// the list first, then lists the copy it answers with.
  ///
  /// Throws a [StateError] while it is still uploading attachments to be
  /// scheduled.
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
    if (scheduledMessage.failureReason?.isEditFailure ?? false) {
      return updateMessage(id, scheduledMessage.message, scheduledAt: scheduledAt);
    }

    // A message kept at its time isn't checked again.
    if (!scheduledAt.isAtSameMomentAs(scheduledMessage.scheduledAt)) {
      _refuseUnschedulable(scheduledMessage.cid, scheduledMessage.message);
      _refuseUnschedulableAt(scheduledMessage.cid, scheduledMessage.message, scheduledAt);
    }

    return _edit(
      scheduledMessage,
      scheduledMessage.copyWith(scheduledAt: scheduledAt),
      (_) => request(),
    );
  }

  /// Sends the scheduled message [id] right away.
  ///
  /// It is listed as [ScheduledMessageStatus.preparingToSchedule] while the
  /// request runs, then as the server answers until it is sent, and as it
  /// was if the request fails.
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
  /// Throws a [StateError] while it is still uploading attachments to be
  /// scheduled.
  Future<SendScheduledMessageNowResponse> sendMessageNow(String id) async {
    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) return _api.sendScheduledMessageNow(id);

    _refuseWhileScheduling(scheduledMessage);
    _refuseDeletedQuote(scheduledMessage.cid, scheduledMessage.message);
    _cancelUploads(scheduledMessage.id);

    final generation = _generation;
    final preparing = scheduledMessage.copyWith(
      status: .preparingToSchedule,
      failureReason: null,
      localUpdatedAt: clock.now(),
    );
    _emitEvent(EventType.scheduledMessageUpdated, preparing, generation);

    final response = await _request(
      scheduledMessage,
      generation,
      () => _api.sendScheduledMessageNow(scheduledMessage.id),
      relistOnFailure: (_) => _restored(scheduledMessage),
    );

    // Its sent event can arrive first, which stops listing it.
    final isListed = _listedScheduledMessage(id) != null;
    if (isListed) {
      // A copy of the version it had replaces the one being prepared too.
      final answered = response.scheduledMessage;
      final isSameVersion = answered.remoteUpdatedAt == scheduledMessage.remoteUpdatedAt;
      final listed = isSameVersion ? answered.copyWith(localUpdatedAt: clock.now()) : answered;
      _emitEvent(EventType.scheduledMessageUpdated, listed, generation);
    }

    return response;
  }

  /// Deletes the scheduled message [id].
  ///
  /// One still uploading attachments to be scheduled has its uploads canceled.
  /// One whose attachments failed to upload is removed without a request. An
  /// edit still uploading attachments is stopped, and listed again as failed if
  /// the request fails.
  ///
  /// A listed one stops being listed right away, and is listed again if the
  /// request fails, unless it is already gone. One still being scheduled is
  /// deleted on the server once scheduling it ends, without a request now,
  /// and listed again if deleting it there fails.
  /// One whose scheduling failed is deleted even if scheduling it never went
  /// through. One not listed is deleted without changing the list.
  ///
  /// The returned scheduled message has the status it had when it was
  /// deleted.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, including when it
  /// is already gone, unless its scheduling had failed.
  Future<DeleteScheduledMessageResponse> deleteMessage(String id) async {
    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) return _api.deleteScheduledMessage(id);

    final generation = _generation;
    final wasWaiting = _cancelUploads(scheduledMessage.id);

    // Never scheduled, so there is nothing to delete on the server.
    if (scheduledMessage.failureReason == .attachmentUploadFailed) {
      final canceled = _canceled(scheduledMessage);
      _emitEvent(EventType.scheduledMessageDeleted, canceled, generation);
      return DeleteScheduledMessageResponse()..scheduledMessage = canceled;
    }

    // Still being scheduled, so it is deleted on the server once scheduling it
    // ends.
    final isBeingScheduled =
        scheduledMessage.status == .preparingToSchedule && scheduledMessage.remoteCreatedAt == null;
    if (isBeingScheduled) {
      final canceled = _canceled(scheduledMessage);
      _deletedWhileScheduling.add(id);
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
      relistOnFailure: (_) => relisted,
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
    // The server can report one deleted while being scheduled before its
    // scheduling ends; it isn't listed again meanwhile.
    final isDeletedWhileScheduling = switch (event) {
      Event(isLocal: false, :final scheduledMessage?) when _isCreatedOrUpdated(event.type) =>
        _deletedWhileScheduling.contains(scheduledMessage.id),
      _ => false,
    };
    if (!isDeletedWhileScheduling) _eventHandler.handleEvent(event);

    if (event.type == EventType.connectionChanged && event.online == false) {
      _onConnectionLost();
    }

    if (event.type == EventType.connectionRecovered) {
      _onConnectionRecovered().ignore();
    }
  }

  // Whether an event of [type] lists a scheduled message.
  static bool _isCreatedOrUpdated(String type) {
    return type == EventType.scheduledMessageCreated || type == EventType.scheduledMessageUpdated;
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
    // Stops the attachment upload of an earlier call for the message.
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
      final result = await _uploadAttachments(saving, generation);
      saving = saving.copyWith(message: result.message);

      if (result is MessageAttachmentsUploadFailed) {
        final failed = saving.copyWith(
          status: .failed,
          failureReason: ScheduledMessageFailureReason.updateFailed,
          localUpdatedAt: clock.now(),
        );

        _emitEvent(EventType.scheduledMessageUpdated, failed, generation);
        throw _attachmentUploadFailed;
      }
    }

    final edit = saving;
    final response = await _request(
      scheduledMessage,
      generation,
      () => request(edit.message),
      relistOnFailure: (error) => edit.copyWith(
        status: .failed,
        failureReason: _editFailureReason(error),
      ),
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
  // showing their progress on it, and resolves to how the upload ended.
  //
  // Throws [_uploadCanceled] if [_cancelUploads] stops them, even once they
  // have finished.
  Future<MessageAttachmentsUploadResult> _uploadAttachments(
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

    return result;
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
  // being sent is listed again as it was, if it still is listed, until its
  // own events tell how sending goes; any other lists what [relistOnFailure]
  // returns for the error, if given.
  Future<T> _request<T>(
    ScheduledMessage scheduledMessage,
    int generation,
    Future<T> Function() request, {
    ScheduledMessage Function(Object error)? relistOnFailure,
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
        // Not listed again if taken out of the list, as it may be sent by now.
        if (isListed) _emitEvent(EventType.scheduledMessageUpdated, _restored(scheduledMessage), generation);
      } else if (relistOnFailure != null) {
        _emitEvent(EventType.scheduledMessageUpdated, relistOnFailure(error), generation);
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

  // Refuses to send [message] in the channel [cid] at [scheduledAt] when the
  // server would: past the channel's maximum lead time, unless not
  // [checkLeadTime], at or after its pin expires, or less than a minute before
  // the location it shares stops being shared.
  void _refuseUnschedulableAt(
    String cid,
    Message message,
    DateTime scheduledAt, {
    bool checkLeadTime = true,
  }) {
    // As the server does, the time is checked rounded up to the minute, the
    // time it is sent at.
    final sendAt = _roundedUpToMinute(scheduledAt);

    final maxLeadTime = _client.state.channels[cid]?.config?.scheduledMessagesMaxLeadTime;
    if (checkLeadTime && maxLeadTime != null) {
      // With a minute of slack, as the server has.
      final latest = clock.now().add(maxLeadTime + const Duration(minutes: 1));
      if (sendAt.isAfter(latest)) {
        throw const ScheduledMessageRefusedError(.scheduledAtTooFar, 'The time is too far ahead');
      }
    }

    if (message.pinExpires case final pinExpires? when !pinExpires.isAfter(sendAt)) {
      throw const ScheduledMessageRefusedError(.pinExpiresTooSoon, 'The pin expires before the message is sent');
    }

    if (message.sharedLocation?.endAt case final endAt? when endAt.isBefore(sendAt.add(_minLocationTime))) {
      throw const ScheduledMessageRefusedError(.locationEndsTooSoon, 'The location stops being shared too soon');
    }
  }

  // How long a shared location must still be shared once its message is sent.
  static const _minLocationTime = Duration(seconds: 59);

  // [time], rounded up to a whole minute.
  static DateTime _roundedUpToMinute(DateTime time) {
    final remainder = time.microsecondsSinceEpoch % Duration.microsecondsPerMinute;
    if (remainder == 0) return time;

    return time.add(Duration(microseconds: Duration.microsecondsPerMinute - remainder));
  }

  // The reason a failed edit is listed with. One stopped by a temporary
  // error, or by a change made at the same time, can be saved again.
  ScheduledMessageFailureReason _editFailureReason(Object error) {
    if (error is! StreamChatNetworkError) return .updateRejected;
    if (error.isRetriable) return .updateFailed;
    if (error.scheduledMessageErrorReason == .scheduledMessageConflict) return .updateFailed;

    return .updateRejected;
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

  // [scheduledMessage] as it was, replacing any copy of it being prepared.
  ScheduledMessage _restored(ScheduledMessage scheduledMessage) {
    return scheduledMessage.copyWith(localUpdatedAt: clock.now());
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
    _deletedWhileScheduling.clear();
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
