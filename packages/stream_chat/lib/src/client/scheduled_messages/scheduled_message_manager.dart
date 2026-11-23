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

/// The runner of the current user's scheduled message requests.
///
/// Its [state] changes only through scheduled message events on its client's
/// event stream: the ones the server sends, and the ones its own requests
/// emit for the changes they make.
class ScheduledMessageManager {
  /// Creates a manager for the scheduled messages of `client`.
  ///
  /// The `logger` logs its warnings.
  ScheduledMessageManager(this._client, {this._logger}) {
    _eventsSubscription = _client.eventStream.listen(_onEvent);
  }

  static const _pageSize = 100;

  // How far past a channel's maximum lead time a time is still accepted.
  static const _maxLeadTimeSlack = Duration(minutes: 1);

  // How long a shared location must still be shared once its message is sent.
  static const _minLocationTime = Duration(seconds: 59);

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

  /// Queries the page of the scheduled messages that [query] describes.
  ///
  /// See [StreamChatClient.queryScheduledMessages].
  Future<QueryScheduledMessagesResponse> queryMessages(
    ScheduledMessagesQuery query,
  ) async {
    final generation = _generation;
    final response = await _api.queryScheduledMessages(query);

    if (_isCurrent(generation)) {
      _stateNotifier.onQueried(response.scheduledMessages);
    }

    return response;
  }

  /// Loads the complete list of scheduled messages.
  ///
  /// See [StreamChatClient.loadScheduledMessages].
  Future<ScheduledMessageListState> loadMessages() {
    return _loadCache.run('all', () async {
      final generation = _generation;
      final loaded = <ScheduledMessage>[];

      String? next;
      do {
        final response = await queryMessages(ScheduledMessagesQuery(limit: _pageSize, next: next));

        loaded.addAll(response.scheduledMessages);
        next = response.next;
      } while (next != null && next.isNotEmpty && _isCurrent(generation));

      if (_isCurrent(generation)) {
        _stateNotifier.onLoaded(loaded);
      }

      return state;
    });
  }

  /// Schedules [message] to be sent at [scheduledAt].
  ///
  /// See [StreamChatClient.scheduleMessage].
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

  /// Edits the scheduled message [id].
  ///
  /// See [StreamChatClient.updateScheduledMessage].
  Future<UpdateScheduledMessageResponse> updateMessage(
    String id,
    Message message, {
    DateTime? scheduledAt,
  }) async {
    if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
      throw ArgumentError.value(message, 'message', 'Attachments must be uploaded before updating');
    }

    Future<UpdateScheduledMessageResponse> request() {
      return _api.updateScheduledMessage(id, message: message, scheduledAt: scheduledAt);
    }

    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) return _updateUnlisted(request);
    _refuseChange(scheduledMessage);

    if (scheduledMessage.isSchedulingFailed) {
      _refuseTimePassed(scheduledAt ?? scheduledMessage.scheduledAt);
      final scheduled = await _scheduleAgain(scheduledMessage, message: message, scheduledAt: scheduledAt);
      if (scheduled.status == .sent || _listedScheduledMessage(id) == null) {
        return UpdateScheduledMessageResponse()..scheduledMessage = scheduled;
      }

      // The answer can be the copy an earlier attempt stored, so the change is
      // saved over it.
      final edited = scheduled.copyWith(message: message, scheduledAt: scheduledAt);
      return _edit(scheduled, edited, request);
    }

    final isMoved = scheduledAt != null && !scheduledAt.isAtSameMomentAs(scheduledMessage.scheduledAt);
    _refuseUnschedulable(
      scheduledMessage.cid,
      message,
      scheduledAt ?? scheduledMessage.scheduledAt,
      checkLeadTime: isMoved,
    );

    final edited = scheduledMessage.copyWith(message: message, scheduledAt: scheduledAt);
    return _edit(scheduledMessage, edited, request);
  }

  /// Moves the scheduled message [id] to [scheduledAt].
  ///
  /// See [StreamChatClient.rescheduleMessage].
  Future<UpdateScheduledMessageResponse> rescheduleMessage(
    String id, {
    required DateTime scheduledAt,
  }) async {
    Future<UpdateScheduledMessageResponse> request() {
      return _api.updateScheduledMessage(id, scheduledAt: scheduledAt);
    }

    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) return _updateUnlisted(request);
    _refuseChange(scheduledMessage);

    if (scheduledMessage.isSchedulingFailed) {
      _refuseTimePassed(scheduledAt);
      final scheduled = await _scheduleAgain(scheduledMessage, scheduledAt: scheduledAt);
      if (scheduled.status == .sent || _listedScheduledMessage(id) == null) {
        return UpdateScheduledMessageResponse()..scheduledMessage = scheduled;
      }

      // The answer can be the copy an earlier attempt stored, so the move is
      // saved over it.
      return _edit(scheduled, scheduled.copyWith(scheduledAt: scheduledAt), request);
    }

    // A failed edit isn't saved yet, so moving it saves the edit too.
    if (scheduledMessage.isEditFailed) {
      return updateMessage(id, scheduledMessage.message, scheduledAt: scheduledAt);
    }

    final isMoved = !scheduledAt.isAtSameMomentAs(scheduledMessage.scheduledAt);
    if (isMoved) {
      _refuseUnschedulable(scheduledMessage.cid, scheduledMessage.message, scheduledAt);
    }

    return _edit(scheduledMessage, scheduledMessage.copyWith(scheduledAt: scheduledAt), request);
  }

  /// Sends the scheduled message [id] right away.
  ///
  /// See [StreamChatClient.sendScheduledMessageNow].
  Future<SendScheduledMessageNowResponse> sendMessageNow(String id) async {
    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) return _api.sendScheduledMessageNow(id);
    _refuseChange(scheduledMessage);

    if (!scheduledMessage.isSchedulingFailed) return _sendNow(scheduledMessage);

    // Scheduled again as it was, then sent like any scheduled one, as the
    // answer can be the copy an earlier attempt stored.
    final scheduled = await _scheduleAgain(scheduledMessage);
    if (scheduled.status == .sent || _listedScheduledMessage(id) == null) {
      return SendScheduledMessageNowResponse()..scheduledMessage = scheduled;
    }

    return _sendNow(scheduled);
  }

  /// Deletes the scheduled message [id].
  ///
  /// See [StreamChatClient.deleteScheduledMessage].
  Future<DeleteScheduledMessageResponse> deleteMessage(String id) async {
    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) return _api.deleteScheduledMessage(id);

    final generation = _generation;
    final canceled = _canceled(scheduledMessage);
    _emitEvent(EventType.scheduledMessageDeleted, canceled, generation);

    // Scheduling it deletes it once it ends.
    if (scheduledMessage.isBeingScheduled) {
      return DeleteScheduledMessageResponse()..scheduledMessage = canceled;
    }

    if (scheduledMessage.isSchedulingFailed) {
      return _deleteUnconfirmed(scheduledMessage, canceled, generation);
    }

    return _request(
      scheduledMessage,
      generation,
      () => _api.deleteScheduledMessage(id),
      relistOnFailure: (_) => scheduledMessage,
      relistIfUnlisted: true,
    );
  }

  /// Makes the request of the scheduled message [id] again after it failed.
  ///
  /// See [StreamChatClient.resendScheduledMessage].
  Future<ScheduledMessage?> resendMessage(String id) async {
    final scheduledMessage = _listedScheduledMessage(id);
    if (scheduledMessage == null) throw StateError('No scheduled message $id to resend.');

    if (scheduledMessage.isEditFailed) {
      final response = await updateMessage(
        id,
        scheduledMessage.message,
        scheduledAt: scheduledMessage.scheduledAt,
      );

      return response.scheduledMessage;
    }

    if (!scheduledMessage.isSchedulingFailed) {
      throw StateError('Only a scheduled message whose request failed can be resent.');
    }

    final scheduled = await _scheduleAgain(scheduledMessage);
    return scheduled.status == .sent ? null : scheduled;
  }

  // Schedules [message] at [scheduledAt], which can have passed: it is then
  // sent right away. If it is refused, [restoreOnRefusal] is listed in its
  // place, if given.
  Future<ScheduleMessageResponse> _schedule(
    Message message,
    String channelId,
    String channelType, {
    required DateTime scheduledAt,
    bool skipPush = false,
    bool skipEnrichUrl = false,
    ScheduledMessage? restoreOnRefusal,
  }) async {
    final user = _client.state.currentUser;
    if (user == null) throw StateError('Connect a user before scheduling messages.');

    if (message.attachments.any((it) => !it.uploadState.isSuccess)) {
      throw ArgumentError.value(message, 'message', 'Attachments must be uploaded before scheduling');
    }

    final cid = '$channelType:$channelId';
    _refuseUnschedulable(cid, message, scheduledAt);

    final generation = _generation;

    final now = clock.now();
    final local = ScheduledMessage(
      cid: cid,
      user: user,
      message: message,
      scheduledAt: scheduledAt,
      status: .preparingToSchedule,
      localCreatedAt: now,
      localUpdatedAt: now,
    );

    _emitEvent(EventType.scheduledMessageCreated, local, generation);

    // A list cleared by a disconnect doesn't mean it was deleted.
    bool isDeleted() {
      if (!_isCurrent(generation)) return false;
      return _listedScheduledMessage(local.id) == null;
    }

    try {
      final response = await _api.scheduleMessage(
        channelId,
        channelType,
        message,
        scheduledAt,
        skipPush: skipPush,
        skipEnrichUrl: skipEnrichUrl,
      );

      final created = response.scheduledMessage;
      if (created == null) {
        // Its time had passed, so it was sent right away.
        final messageId = response.message.id;
        _emitEvent(EventType.scheduledMessageSent, _sent(local), generation, messageId: messageId);
        return response;
      }

      await _listUnlessDeleted(EventType.scheduledMessageCreated, created, generation, isDeleted: isDeleted());
      return response;
    } on StreamChatNetworkError catch (error) {
      // On a retry, the first attempt went through.
      if (error.isAlreadySent) {
        _emitEvent(EventType.scheduledMessageSent, _sent(local), generation);
        rethrow;
      }

      if (error.isGone) {
        _emitEvent(EventType.scheduledMessageDeleted, _canceled(local), generation);
        rethrow;
      }

      if (!error.isRetriable) {
        _reportRefused(local, restoreOnRefusal, generation, isDeleted: isDeleted());
        rethrow;
      }

      final failed = local.copyWith(
        status: .failed,
        failure: const ScheduledMessageFailure.schedulingFailed(),
        localUpdatedAt: clock.now(),
      );

      // It may have been stored all the same.
      await _listUnlessDeleted(EventType.scheduledMessageUpdated, failed, generation, isDeleted: isDeleted());
      rethrow;
    } catch (_) {
      _reportRefused(local, restoreOnRefusal, generation, isDeleted: isDeleted());
      rethrow;
    }
  }

  // Reports [local], refused, as deleted, or [restored] in its place, unless
  // [local] was deleted meanwhile.
  void _reportRefused(
    ScheduledMessage local,
    ScheduledMessage? restored,
    int generation, {
    required bool isDeleted,
  }) {
    if (restored != null && !isDeleted) {
      _emitEvent(EventType.scheduledMessageUpdated, restored, generation);
    } else {
      _emitEvent(EventType.scheduledMessageDeleted, _canceled(local), generation);
    }
  }

  // Lists [scheduledMessage] with an event of [type], unless the user deleted
  // it meanwhile and deleting it again succeeds, so one still there can be
  // deleted again.
  Future<void> _listUnlessDeleted(
    String type,
    ScheduledMessage scheduledMessage,
    int generation, {
    required bool isDeleted,
  }) async {
    if (isDeleted && await _deleteScheduledOnServer(scheduledMessage.id)) return;
    _emitEvent(type, scheduledMessage, generation);
  }

  // Deletes the scheduled message [id], deleted while it was being scheduled,
  // and returns whether it is gone, including when it was already sent or
  // deleted.
  Future<bool> _deleteScheduledOnServer(String id) async {
    try {
      await _api.deleteScheduledMessage(id);
      return true;
    } on StreamChatNetworkError catch (error, stackTrace) {
      if (!error.isGone) _logger?.warning('Failed to delete the scheduled message $id', error, stackTrace);
      return error.isGone;
    } catch (error, stackTrace) {
      _logger?.warning('Failed to delete the scheduled message $id', error, stackTrace);
      return false;
    }
  }

  // Schedules [scheduledMessage], whose scheduling failed, again with its ID,
  // with [message] and at [scheduledAt], if given. Returns the scheduled
  // message, or it marked sent when its time had passed and it was sent right
  // away.
  Future<ScheduledMessage> _scheduleAgain(
    ScheduledMessage scheduledMessage, {
    Message? message,
    DateTime? scheduledAt,
  }) async {
    final [channelType, channelId] = scheduledMessage.cid.split(':');
    final response = await _schedule(
      (message ?? scheduledMessage.message).copyWith(id: scheduledMessage.id),
      channelId,
      channelType,
      scheduledAt: scheduledAt ?? scheduledMessage.scheduledAt,
      // A refused change leaves the failed copy as it was.
      restoreOnRefusal: scheduledMessage,
    );

    return response.scheduledMessage ?? _sent(scheduledMessage);
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
    final saving = _preparing(edited);
    _emitEvent(EventType.scheduledMessageUpdated, saving, generation);

    final response = await _request(
      scheduledMessage,
      generation,
      request,
      relistOnFailure: (error) => saving.copyWith(
        status: .failed,
        failure: _failureOf(error),
      ),
    );

    _listAnswered(scheduledMessage, response.scheduledMessage, generation);
    return response;
  }

  // Sends [scheduledMessage], which is scheduled, right away.
  Future<SendScheduledMessageNowResponse> _sendNow(ScheduledMessage scheduledMessage) async {
    _refuseDeletedQuote(scheduledMessage.cid, scheduledMessage.message);

    final generation = _generation;
    _emitEvent(EventType.scheduledMessageUpdated, _preparing(scheduledMessage), generation);

    final response = await _request(
      scheduledMessage,
      generation,
      () => _api.sendScheduledMessageNow(scheduledMessage.id),
      relistOnFailure: (_) => _restored(scheduledMessage),
    );

    _listAnswered(scheduledMessage, response.scheduledMessage, generation);
    return response;
  }

  // Deletes [scheduledMessage], whose scheduling failed, so it may never have
  // been scheduled. It is listed again if deleting it fails.
  Future<DeleteScheduledMessageResponse> _deleteUnconfirmed(
    ScheduledMessage scheduledMessage,
    ScheduledMessage canceled,
    int generation,
  ) async {
    try {
      return await _api.deleteScheduledMessage(scheduledMessage.id);
    } catch (error) {
      if (error is StreamChatNetworkError && error.isAlreadySent) {
        _emitEvent(EventType.scheduledMessageSent, _sent(scheduledMessage), generation);
        rethrow;
      }

      if (error is StreamChatNetworkError && error.isGone) {
        return DeleteScheduledMessageResponse()..scheduledMessage = canceled;
      }

      _emitEvent(EventType.scheduledMessageUpdated, scheduledMessage, generation);
      rethrow;
    }
  }

  // Runs [request] on [scheduledMessage]. If it fails, one found sent or gone
  // is reported so. Otherwise, if it is still listed or [relistIfUnlisted] is
  // true, it is listed as [relistOnFailure] returns, or as it was when it can
  // no longer be changed.
  Future<T> _request<T>(
    ScheduledMessage scheduledMessage,
    int generation,
    Future<T> Function() request, {
    required ScheduledMessage Function(Object error) relistOnFailure,
    bool relistIfUnlisted = false,
  }) async {
    try {
      return await request();
    } catch (error) {
      final networkError = error is StreamChatNetworkError ? error : null;
      if (networkError != null && networkError.isAlreadySent) {
        _emitEvent(EventType.scheduledMessageSent, _sent(scheduledMessage), generation);
        rethrow;
      }

      if (networkError != null && networkError.isGone) {
        _emitEvent(EventType.scheduledMessageDeleted, _canceled(scheduledMessage), generation);
        rethrow;
      }

      final isListed = _listedScheduledMessage(scheduledMessage.id) != null;
      if (!isListed && !relistIfUnlisted) rethrow;

      if (networkError == null || !networkError.isNotEditable) {
        _emitEvent(EventType.scheduledMessageUpdated, relistOnFailure(error), generation);
        rethrow;
      }

      // One taken out of the list may be sent by now.
      if (isListed) {
        _emitEvent(EventType.scheduledMessageUpdated, _restored(scheduledMessage), generation);
      }
      rethrow;
    }
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

  // Refuses a change to [scheduledMessage] while it is first scheduled, which
  // ends by listing the answer, or once sending it failed, as it can then
  // only be deleted.
  static void _refuseChange(ScheduledMessage scheduledMessage) {
    if (scheduledMessage.isBeingScheduled) {
      throw StateError('The scheduled message ${scheduledMessage.id} is still being scheduled.');
    }

    if (scheduledMessage.failure is ScheduledMessageSendingFailed) {
      throw const ScheduledMessageRefusedError(
        .scheduledMessageNotEditable,
        "A message that couldn't be sent can't be changed",
      );
    }
  }

  // Refuses to schedule a failed message again at [scheduledAt] once it has
  // passed, which would send it right away.
  static void _refuseTimePassed(DateTime scheduledAt) {
    if (scheduledAt.isAfter(clock.now())) return;

    throw const ScheduledMessageRefusedError(.scheduledAtTooSoon, 'The time has passed');
  }

  // Refuses [message] in the channel [cid] when it can't be sent at
  // [scheduledAt]: it is a command, quotes a deleted message, is past the
  // channel's maximum lead time when [checkLeadTime] is true, its pin expires
  // first, or its location stops being shared within a minute of it.
  void _refuseUnschedulable(
    String cid,
    Message message,
    DateTime scheduledAt, {
    bool checkLeadTime = true,
  }) {
    _refuseDeletedQuote(cid, message);

    final channel = _client.state.channels[cid];
    if (ScheduledMessageRules.isCommand(message, channel)) {
      throw const ScheduledMessageRefusedError(
        .slashCommand,
        "Commands can't be scheduled",
      );
    }

    final sendAt = _roundedUpToMinute(scheduledAt);

    final maxLeadTime = channel?.config?.scheduledMessagesMaxLeadTime;
    if (checkLeadTime && maxLeadTime != null) {
      final latest = clock.now().add(maxLeadTime + _maxLeadTimeSlack);
      if (sendAt.isAfter(latest)) {
        throw const ScheduledMessageRefusedError(
          .scheduledAtTooFar,
          'The time is too far ahead',
        );
      }
    }

    if (message.pinExpires case final pinExpires? when !pinExpires.isAfter(sendAt)) {
      throw const ScheduledMessageRefusedError(
        .pinExpiresTooSoon,
        'The pin expires before the message is sent',
      );
    }

    if (message.sharedLocation?.endAt case final endAt? when endAt.isBefore(sendAt.add(_minLocationTime))) {
      throw const ScheduledMessageRefusedError(
        .locationEndsTooSoon,
        'The location stops being shared too soon',
      );
    }
  }

  // Refuses [message] in the channel [cid] when it quotes a deleted message.
  // Sending now checks only this, as a deleted quote would fail it once sent.
  void _refuseDeletedQuote(String cid, Message message) {
    final channel = _client.state.channels[cid];
    if (ScheduledMessageRules.quotesDeletedMessage(message, channel)) {
      throw const ScheduledMessageRefusedError(
        .quotedMessageDeleted,
        "Can't quote a deleted message",
      );
    }
  }

  // [time], rounded up to the whole minute a message due at it is sent at.
  static DateTime _roundedUpToMinute(DateTime time) {
    final remainder = time.microsecondsSinceEpoch % Duration.microsecondsPerMinute;
    if (remainder == 0) return time;

    return time.add(Duration(microseconds: Duration.microsecondsPerMinute - remainder));
  }

  // The failure a change that failed with [error] is listed with. One stopped
  // by a temporary error, or by a change made at the same time, can be
  // retried.
  static ScheduledMessageFailure _failureOf(Object error) {
    final reason = error is StreamChatNetworkError ? error.scheduledMessageErrorReason : null;
    final isRetriable = switch (error) {
      StreamChatNetworkError(isRetriable: true) => true,
      StreamChatNetworkError() => reason == .scheduledMessageConflict,
      _ => true,
    };

    return .updatingFailed(reason: reason, isRetriable: isRetriable);
  }

  // The scheduled message with [id] in the client's list, if it is listed.
  ScheduledMessage? _listedScheduledMessage(String id) {
    return state.scheduledMessages.where((it) => it.id == id).firstOrNull;
  }

  // Lists [answered] in place of the copy being prepared, unless
  // [scheduledMessage] was sent or deleted meanwhile. An answer of the same
  // version is marked changed, so it still replaces that copy.
  void _listAnswered(
    ScheduledMessage scheduledMessage,
    ScheduledMessage answered,
    int generation,
  ) {
    if (_listedScheduledMessage(scheduledMessage.id) == null) return;

    final isSameVersion = answered.remoteUpdatedAt == scheduledMessage.remoteUpdatedAt;
    final listed = isSameVersion ? _restored(answered) : answered;
    _emitEvent(EventType.scheduledMessageUpdated, listed, generation);
  }

  // [scheduledMessage], marked as being prepared.
  static ScheduledMessage _preparing(ScheduledMessage scheduledMessage) {
    return scheduledMessage.copyWith(
      status: .preparingToSchedule,
      failure: null,
      localUpdatedAt: clock.now(),
    );
  }

  // [scheduledMessage], marked sent.
  static ScheduledMessage _sent(ScheduledMessage scheduledMessage) {
    return scheduledMessage.copyWith(
      status: .sent,
      localUpdatedAt: clock.now(),
    );
  }

  // [scheduledMessage] as it was, replacing any copy of it being prepared.
  static ScheduledMessage _restored(ScheduledMessage scheduledMessage) {
    return scheduledMessage.copyWith(localUpdatedAt: clock.now());
  }

  // [scheduledMessage], marked canceled.
  static ScheduledMessage _canceled(ScheduledMessage scheduledMessage) {
    return scheduledMessage.copyWith(
      status: .canceled,
      failure: null,
      localUpdatedAt: clock.now(),
    );
  }

  // Whether the user is the one who was connected at [generation].
  bool _isCurrent(int generation) => generation == _generation;

  // Every change to the list goes through the client's event stream, so the
  // changes made here and the ones other devices make take the same path to
  // the list, through [_onEvent].
  //
  // Reports [scheduledMessage] as an event of [type], unless the user changed
  // since [generation]. [messageId] is the ID of the message it was sent as,
  // when known.
  void _emitEvent(
    String type,
    ScheduledMessage scheduledMessage,
    int generation, {
    String? messageId,
  }) {
    if (!_isCurrent(generation)) return;

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
}

// Why a request on a scheduled message was refused.
extension on StreamChatNetworkError {
  bool get isAlreadySent => scheduledMessageErrorReason == .scheduledMessageAlreadySent;

  // Not found, already sent, or deleted.
  bool get isGone {
    if (isAlreadySent || isScheduledMessageNotFound) return true;
    return scheduledMessageErrorReason == .scheduledMessageCanceled;
  }

  // Being sent, or no longer changeable.
  bool get isNotEditable {
    return switch (scheduledMessageErrorReason) {
      .scheduledMessageSending || .scheduledMessageNotEditable => true,
      _ => false,
    };
  }
}
