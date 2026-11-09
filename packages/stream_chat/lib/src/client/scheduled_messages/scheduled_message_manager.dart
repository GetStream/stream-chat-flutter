import 'dart:async';

import 'package:clock/clock.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';

import '../../core/api/requests.dart';
import '../../core/api/responses.dart';
import '../../core/api/scheduled_messages_api.dart';
import '../../core/error/stream_chat_error.dart';
import '../../core/models/channel_state.dart';
import '../../core/models/event.dart';
import '../../core/models/message.dart';
import '../../core/models/scheduled_message.dart';
import '../../core/util/in_flight_cache.dart';
import '../../event_type.dart';
import '../client.dart';
import 'scheduled_message_event_handler.dart';
import 'scheduled_message_list_state.dart';

/// A store of the current user's scheduled messages.
///
/// Every scheduled message request goes through it. The events of its client,
/// including the ones its own requests emit, update its [state].
class ScheduledMessageManager {
  /// Creates a manager for the scheduled messages of `client`.
  ///
  /// The optional `logger` logs its warnings.
  ScheduledMessageManager(this._client, {this._logger}) {
    _eventsSubscription = _client.eventStream.listen(_onEvent);
  }

  static const _pageSize = 100;

  final StreamChatClient _client;
  final Logger? _logger;
  ScheduledMessagesApi get _api => _client.chatApi.scheduledMessages;

  final _stateNotifier = ScheduledMessageListStateNotifier();
  late final _eventHandler = ScheduledMessageEventHandler(
    state: _stateNotifier,
  );
  late final StreamSubscription<Event> _eventsSubscription;

  // The load of the complete list, shared while it runs.
  var _loadCache = InFlightCache<String, List<ScheduledMessage>>();

  // Whether the complete list was loaded when the connection was lost.
  var _wasLoadedBeforeConnectionLost = false;

  // Bumped by clear, so a query that started before it is not applied.
  var _generation = 0;

  /// The scheduled messages, and whether the complete list is loaded.
  ScheduledMessageListState get state => _stateNotifier.state;

  /// The [state], emitted on listen and again each time it changes.
  Stream<ScheduledMessageListState> get stream => _stateNotifier.stream;

  /// Queries a page of the scheduled messages, in the channel [cid] and with
  /// one of [statuses] when given.
  ///
  /// The page is added to [ScheduledMessageListState.scheduledMessages];
  /// nothing is removed.
  Future<QueryScheduledMessagesResponse> queryMessages({
    String? cid,
    List<ScheduledMessageStatus>? statuses,
    PaginationParams? pagination,
  }) async {
    final generation = _generation;
    final response = await _api.queryScheduledMessages(
      cid: cid,
      statuses: statuses,
      pagination: pagination,
    );

    if (generation == _generation) {
      _stateNotifier.onQueryScheduledMessages(response.scheduledMessages);
    }

    return response;
  }

  /// Loads the complete list, which then replaces
  /// [ScheduledMessageListState.scheduledMessages].
  ///
  /// The ones not on the server yet are kept. If a page fails, the ones
  /// before it are added, nothing is removed, and the error is rethrown.
  /// Asking again while it runs shares the load.
  ///
  /// Returns the scheduled messages listed once it is loaded.
  Future<List<ScheduledMessage>> loadMessages() {
    return _loadCache.run('all', () async {
      final generation = _generation;
      final loaded = <ScheduledMessage>[];

      String? next;
      do {
        final response = await queryMessages(
          pagination: PaginationParams(limit: _pageSize, next: next),
        );

        loaded.addAll(response.scheduledMessages);
        next = response.next;
      } while (next != null && next.isNotEmpty && generation == _generation);

      if (generation == _generation) {
        _stateNotifier.onLoadScheduledMessages(loaded);
      }

      return state.scheduledMessages;
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
  /// Throws an [ArgumentError] if [scheduledAt] is not in the future, or if an
  /// attachment of [message] is not uploaded yet.
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
        'Must be in the future',
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
    if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
      throw ArgumentError.value(
        message,
        'message',
        'Attachments must be uploaded before scheduling',
      );
    }

    // Listed right away, unless there is no user to list it for.
    final user = _client.state.currentUser;
    final now = clock.now();
    final local = switch (user) {
      null => null,
      final user => ScheduledMessage(
        cid: '$channelType:$channelId',
        user: user,
        message: message,
        scheduledAt: scheduledAt,
        status: .preparingToSchedule,
        localCreatedAt: now,
        localUpdatedAt: now,
      ),
    };

    if (local != null) _emitEvent(EventType.scheduledMessageCreated, local);

    try {
      final response = await _api.scheduleMessage(
        channelId,
        channelType,
        message,
        scheduledAt,
        skipPush: skipPush,
        skipEnrichUrl: skipEnrichUrl,
      );

      if (response.scheduledMessage case final scheduledMessage?) {
        _emitEvent(EventType.scheduledMessageCreated, scheduledMessage);
      } else if (local != null) {
        // Its time had passed, so it was sent right away.
        _emitEvent(
          EventType.scheduledMessageSent,
          local,
          messageId: response.message.id,
        );
      }

      return response;
    } on StreamChatNetworkError catch (error) {
      if (local == null) rethrow;

      if (!error.isRetriable) {
        _emitEvent(EventType.scheduledMessageDeleted, local);
        rethrow;
      }

      final failed = local.copyWith(
        status: .failed,
        failureReason: .requestFailed,
        localUpdatedAt: clock.now(),
      );

      _emitEvent(EventType.scheduledMessageUpdated, failed);
      rethrow;
    } catch (_) {
      if (local != null) _emitEvent(EventType.scheduledMessageDeleted, local);
      rethrow;
    }
  }

  /// Schedules [scheduledMessage] again, after its request failed in a way
  /// that can be retried.
  ///
  /// It keeps its ID, so it is never scheduled twice. If its time has passed,
  /// it is sent right away and no longer listed.
  ///
  /// Its [ScheduledMessage.failureReason] must be retriable.
  ///
  /// Throws an [ArgumentError] if an attachment of its message is not uploaded.
  Future<ScheduleMessageResponse> retryMessage(
    ScheduledMessage scheduledMessage,
  ) {
    assert(
      scheduledMessage.failureReason?.isRetriable ?? false,
      'Only a scheduled message whose request failed can be retried.',
    );

    final [channelType, channelId] = scheduledMessage.cid.split(':');
    return _schedule(
      scheduledMessage.message,
      channelId,
      channelType,
      scheduledAt: scheduledMessage.scheduledAt,
    );
  }

  /// Edits [scheduledMessage].
  ///
  /// Its message is replaced with [message], and it is moved to [scheduledAt]
  /// if given.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails.
  Future<UpdateScheduledMessageResponse> updateMessage(
    ScheduledMessage scheduledMessage,
    Message message, {
    DateTime? scheduledAt,
  }) async {
    final response = await _request(
      scheduledMessage,
      () => _api.updateScheduledMessage(
        scheduledMessage.id,
        message: message,
        scheduledAt: scheduledAt,
      ),
    );

    _emitEvent(EventType.scheduledMessageUpdated, response.scheduledMessage);
    return response;
  }

  /// Moves [scheduledMessage] to [scheduledAt].
  ///
  /// Its message stays as it is.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails.
  Future<UpdateScheduledMessageResponse> rescheduleMessage(
    ScheduledMessage scheduledMessage, {
    required DateTime scheduledAt,
  }) async {
    final response = await _request(
      scheduledMessage,
      () => _api.updateScheduledMessage(
        scheduledMessage.id,
        scheduledAt: scheduledAt,
      ),
    );

    _emitEvent(EventType.scheduledMessageUpdated, response.scheduledMessage);
    return response;
  }

  /// Sends [scheduledMessage] right away.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails.
  Future<SendScheduledMessageNowResponse> sendMessageNow(
    ScheduledMessage scheduledMessage,
  ) async {
    final response = await _request(
      scheduledMessage,
      () => _api.sendScheduledMessageNow(scheduledMessage.id),
    );

    _emitEvent(EventType.scheduledMessageUpdated, response.scheduledMessage);
    return response;
  }

  /// Deletes [scheduledMessage].
  ///
  /// One whose request failed in a way that can be retried is removed without
  /// a request.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails.
  Future<DeleteScheduledMessageResponse> deleteMessage(
    ScheduledMessage scheduledMessage,
  ) async {
    if (scheduledMessage.failureReason?.isRetriable ?? false) {
      _emitEvent(EventType.scheduledMessageDeleted, scheduledMessage);
      final response = DeleteScheduledMessageResponse();
      return response..scheduledMessage = scheduledMessage;
    }

    final response = await _request(
      scheduledMessage,
      () => _api.deleteScheduledMessage(scheduledMessage.id),
    );

    _emitEvent(EventType.scheduledMessageDeleted, response.scheduledMessage);
    return response;
  }

  /// Replaces the scheduled messages in each of the queried channels with
  /// the [ChannelState.scheduledMessages] listed for it in [channelStates].
  ///
  /// A channel whose state has no [ChannelState.scheduledMessages] is left as
  /// it is. The ones not on the server yet are kept.
  @internal
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
      _logger?.warning(
        'Failed to reload the scheduled messages',
        error,
        stackTrace,
      );
    }
  }

  // Runs [request] on [scheduledMessage]. One the request finds gone is
  // reported deleted: its own event may have been missed.
  Future<T> _request<T>(
    ScheduledMessage scheduledMessage,
    Future<T> Function() request,
  ) async {
    try {
      return await request();
    } on StreamChatNetworkError catch (error) {
      if (error.isScheduledMessageGoneError) {
        _emitEvent(EventType.scheduledMessageDeleted, scheduledMessage);
      }

      rethrow;
    }
  }

  void _emitEvent(
    String type,
    ScheduledMessage scheduledMessage, {
    String? messageId,
  }) {
    final event = Event(
      type: type,
      cid: scheduledMessage.cid,
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
    _loadCache = InFlightCache<String, List<ScheduledMessage>>();
    _wasLoadedBeforeConnectionLost = false;
    _stateNotifier.clear();
  }

  /// Stops following the events and updating the [state].
  Future<void> dispose() async {
    await _eventsSubscription.cancel();
    await _stateNotifier.dispose();
  }
}

/// Views of a [ScheduledMessageManager]'s scheduled messages in one channel
/// or thread.
extension ScheduledMessageManagerScope on ScheduledMessageManager {
  /// The scheduled messages in the channel [cid], without its thread replies.
  List<ScheduledMessage> channelMessages(String cid) {
    return _scoped(_inChannel(cid));
  }

  /// The scheduled replies in the thread of the message [parentId].
  List<ScheduledMessage> threadReplies(String parentId) {
    return _scoped(_inThread(parentId));
  }

  /// The [threadReplies], emitted on listen and again each time they change.
  Stream<List<ScheduledMessage>> threadRepliesStream(String parentId) {
    return _scopedStream(_inThread(parentId));
  }

  static bool Function(ScheduledMessage) _inChannel(String cid) {
    return (it) => it.cid == cid && it.message.parentId == null;
  }

  static bool Function(ScheduledMessage) _inThread(String parentId) {
    return (it) => it.message.parentId == parentId;
  }

  List<ScheduledMessage> _scoped(bool Function(ScheduledMessage) test) {
    return state.scheduledMessages.where(test).toList();
  }

  Stream<List<ScheduledMessage>> _scopedStream(
    bool Function(ScheduledMessage) test,
  ) {
    final scoped = stream.map(
      (it) => it.scheduledMessages.where(test).toList(),
    );

    return scoped.distinct(const ListEquality().equals);
  }
}

// Rejections of a scheduled message request that leave nothing to retry.
extension on StreamChatNetworkError {
  // Whether the scheduled message is gone: it no longer exists, or it was
  // already sent or deleted.
  bool get isScheduledMessageGoneError {
    if (statusCode == 404) return true;

    return switch (scheduledMessageErrorReason) {
      .scheduledMessageAlreadySent => true,
      .scheduledMessageCanceled => true,
      _ => false,
    };
  }
}
