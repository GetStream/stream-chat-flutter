import 'dart:async';

import 'package:clock/clock.dart';
import 'package:logging/logging.dart';

import '../../core/api/responses.dart';
import '../../core/api/scheduled_messages_api.dart';
import '../../core/error/stream_chat_error.dart';
import '../../core/models/channel_state.dart';
import '../../core/models/event.dart';
import '../../core/models/message.dart';
import '../../core/models/scheduled_message.dart';
import '../../core/util/in_flight_cache.dart';
import '../../core/util/scheduled_message_rules.dart';
import '../../event_type.dart';
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
  /// Throws a [StreamChatNetworkError] if the request fails.
  ///
  /// Throws a [ScheduledMessageRefusedError] without making the request when
  /// [message] is a command in a channel that has commands, or quotes a
  /// deleted message.
  ///
  /// Throws an [ArgumentError] if [scheduledAt] is not in the future, or if an
  /// attachment of [message] is not uploaded yet. A message to send right
  /// away goes through [StreamChatClient.sendMessage].
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

    if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
      throw ArgumentError.value(message, 'message', 'Attachments must be uploaded before scheduling');
    }

    _refuseUnschedulable('$channelType:$channelId', message);

    final generation = _generation;

    final now = clock.now();
    final local = ScheduledMessage(
      cid: '$channelType:$channelId',
      user: user,
      message: message,
      scheduledAt: scheduledAt,
      status: .preparingToSchedule,
      localCreatedAt: now,
      localUpdatedAt: now,
    );

    _emitEvent(EventType.scheduledMessageCreated, local, generation);

    try {
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
      } else {
        // Its time had passed, so it was sent right away.
        final messageId = response.message.id;
        _emitEvent(EventType.scheduledMessageSent, _sent(local), generation, messageId: messageId);
      }

      return response;
    } on StreamChatNetworkError catch (error) {
      // Already sent: on a retry, the first attempt went through.
      if (error.scheduledMessageErrorReason == .scheduledMessageAlreadySent) {
        _emitEvent(EventType.scheduledMessageSent, _sent(local), generation);
        rethrow;
      }

      if (!error.isRetriable) {
        _emitEvent(EventType.scheduledMessageDeleted, _canceled(local), generation);
        rethrow;
      }

      final failed = local.copyWith(
        status: .failed,
        failureReason: ScheduledMessageFailureReason.requestFailed,
        localUpdatedAt: clock.now(),
      );

      _emitEvent(EventType.scheduledMessageUpdated, failed, generation);
      rethrow;
    } catch (_) {
      _emitEvent(EventType.scheduledMessageDeleted, _canceled(local), generation);
      rethrow;
    }
  }

  /// Makes the request of [scheduledMessage] again after it failed.
  ///
  /// One whose scheduling failed is scheduled again, keeping its ID so it is
  /// never scheduled twice. One whose edit failed is saved again with its
  /// message and time, as [updateMessage] does. Resolves to the scheduled
  /// message, or null when its time had passed and it was sent right away.
  ///
  /// Its [ScheduledMessage.failureReason] must be retriable.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, or an
  /// [ArgumentError] if an attachment of its message is not uploaded.
  ///
  /// Throws a [StateError] if no user is connected when it is scheduled
  /// again.
  Future<ScheduledMessage?> retryMessage(ScheduledMessage scheduledMessage) async {
    assert(
      scheduledMessage.failureReason?.isRetriable ?? false,
      'Only a scheduled message whose request failed can be retried.',
    );

    if (scheduledMessage.failureReason == .updateFailed) {
      final response = await updateMessage(
        scheduledMessage,
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

  /// Edits [scheduledMessage].
  ///
  /// Its message is replaced with [message], and it is moved to [scheduledAt]
  /// if given. The edit is listed right away as
  /// [ScheduledMessageStatus.updating]. If the request fails, it stays listed
  /// as failed with [ScheduledMessageFailureReason.updateFailed].
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, even when the
  /// scheduled message is already gone. If it is, an
  /// [EventType.scheduledMessageDeleted] event reports it, so [state] stops
  /// listing it.
  ///
  /// Throws a [ScheduledMessageRefusedError] without making the request when
  /// [message] is a command in a channel that has commands, or quotes a
  /// deleted message.
  ///
  /// Throws an [ArgumentError] if an attachment of [message] is not uploaded
  /// yet.
  Future<UpdateScheduledMessageResponse> updateMessage(
    ScheduledMessage scheduledMessage,
    Message message, {
    DateTime? scheduledAt,
  }) async {
    if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
      throw ArgumentError.value(
        message,
        'message',
        'Attachments must be uploaded before updating',
      );
    }

    _refuseUnschedulable(scheduledMessage.cid, message);

    return _edit(
      scheduledMessage,
      scheduledMessage.copyWith(message: message, scheduledAt: scheduledAt),
      () => _api.updateScheduledMessage(
        scheduledMessage.id,
        message: message,
        scheduledAt: scheduledAt,
      ),
    );
  }

  /// Moves [scheduledMessage] to [scheduledAt].
  ///
  /// Its message stays as it is. It is listed at its new time right away, as
  /// with [updateMessage].
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, even when the
  /// scheduled message is already gone. If it is, an
  /// [EventType.scheduledMessageDeleted] event reports it, so [state] stops
  /// listing it.
  ///
  /// Throws a [ScheduledMessageRefusedError] without making the request when
  /// it is moved to another time but quotes a deleted message.
  Future<UpdateScheduledMessageResponse> rescheduleMessage(
    ScheduledMessage scheduledMessage, {
    required DateTime scheduledAt,
  }) async {
    // A message kept at its time isn't checked again.
    if (!scheduledAt.isAtSameMomentAs(scheduledMessage.scheduledAt)) {
      _refuseUnschedulable(scheduledMessage.cid, scheduledMessage.message, includeCommand: false);
    }

    return _edit(
      scheduledMessage,
      scheduledMessage.copyWith(scheduledAt: scheduledAt),
      () => _api.updateScheduledMessage(scheduledMessage.id, scheduledAt: scheduledAt),
    );
  }

  /// Sends [scheduledMessage] right away.
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
  /// it quotes a deleted message, which would fail it once sent.
  Future<SendScheduledMessageNowResponse> sendMessageNow(
    ScheduledMessage scheduledMessage,
  ) async {
    _refuseUnschedulable(scheduledMessage.cid, scheduledMessage.message, includeCommand: false);

    final generation = _generation;
    try {
      final response = await _request(
        scheduledMessage,
        generation,
        () => _api.sendScheduledMessageNow(scheduledMessage.id),
      );

      // Its sent event can arrive first, which stops listing it.
      final isListed = state.scheduledMessages.any((it) => it.id == scheduledMessage.id);
      if (isListed) {
        final sending = response.scheduledMessage.copyWith(
          status: .sending,
          localUpdatedAt: clock.now(),
        );
        _emitEvent(EventType.scheduledMessageUpdated, sending, generation);
      }

      return response;
    } catch (error) {
      if (_isRefusedAsSending(error)) {
        _emitEvent(EventType.scheduledMessageUpdated, _sending(scheduledMessage), generation);
      }

      rethrow;
    }
  }

  /// Deletes [scheduledMessage].
  ///
  /// It stops being listed right away, and is listed again if the request
  /// fails, unless it is already gone. One whose scheduling failed is deleted
  /// even if scheduling it never went through.
  ///
  /// The returned scheduled message has the status it had when it was
  /// deleted.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails. Deleting one
  /// already gone throws too, unless its own scheduling had failed.
  Future<DeleteScheduledMessageResponse> deleteMessage(
    ScheduledMessage scheduledMessage,
  ) async {
    final generation = _generation;
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

    try {
      return await _request(
        scheduledMessage,
        generation,
        () => _api.deleteScheduledMessage(scheduledMessage.id),
      );
    } catch (error) {
      if (error case StreamChatNetworkError(isScheduledMessageNotFound: true)) rethrow;

      final isSending = _isRefusedAsSending(error);
      final relisted = isSending ? _sending(scheduledMessage) : scheduledMessage;

      _emitEvent(EventType.scheduledMessageUpdated, relisted, generation);
      rethrow;
    }
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

  // Lists [edited] as being saved while [request] saves it over
  // [scheduledMessage], then the saved copy. If the request fails, [edited]
  // stays listed as failed, unless the message is being sent or is gone.
  Future<UpdateScheduledMessageResponse> _edit(
    ScheduledMessage scheduledMessage,
    ScheduledMessage edited,
    Future<UpdateScheduledMessageResponse> Function() request,
  ) async {
    final generation = _generation;
    final updating = edited.copyWith(
      status: .updating,
      failureReason: null,
      localUpdatedAt: clock.now(),
    );

    _emitEvent(EventType.scheduledMessageUpdated, updating, generation);

    try {
      final response = await _request(scheduledMessage, generation, request);

      // The API answers a move to the same time with the version it already had.
      // Mark it as changed here, so it still replaces the copy being saved.
      final saved = response.scheduledMessage;
      final isSameVersion = saved.remoteUpdatedAt == scheduledMessage.remoteUpdatedAt;
      final listed = isSameVersion ? saved.copyWith(localUpdatedAt: clock.now()) : saved;
      _emitEvent(EventType.scheduledMessageUpdated, listed, generation);
      return response;
    } catch (error) {
      // Already reported deleted.
      if (error case StreamChatNetworkError(isScheduledMessageNotFound: true)) rethrow;

      final failed = updating.copyWith(
        status: .failed,
        failureReason: ScheduledMessageFailureReason.updateFailed,
        localUpdatedAt: clock.now(),
      );

      final isSending = _isRefusedAsSending(error);
      final listed = isSending ? _sending(scheduledMessage) : failed;

      _emitEvent(EventType.scheduledMessageUpdated, listed, generation);
      rethrow;
    }
  }

  // Runs [request] on [scheduledMessage]. One the request finds gone is
  // reported deleted: its own event may have been missed.
  Future<T> _request<T>(
    ScheduledMessage scheduledMessage,
    int generation,
    Future<T> Function() request,
  ) async {
    try {
      return await request();
    } on StreamChatNetworkError catch (error) {
      if (error.isScheduledMessageNotFound) {
        _emitEvent(EventType.scheduledMessageDeleted, _canceled(scheduledMessage), generation);
      }

      rethrow;
    }
  }

  // Refuses [message] in the channel [cid] when it can't be scheduled: when
  // it quotes a deleted message, or, unless [includeCommand] is false, when
  // it is a command.
  void _refuseUnschedulable(String cid, Message message, {bool includeCommand = true}) {
    final channel = _client.state.channels[cid];
    if (ScheduledMessageRules.quotesDeletedMessage(message, channel)) {
      throw const ScheduledMessageRefusedError(.quotedMessageDeleted, "Can't quote a deleted message");
    }
    if (includeCommand && ScheduledMessageRules.isCommand(message, channel)) {
      throw const ScheduledMessageRefusedError(.slashCommand, "Commands can't be scheduled");
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
