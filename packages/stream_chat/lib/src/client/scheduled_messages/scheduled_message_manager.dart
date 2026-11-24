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
/// Its requests update its [state] as they go, and the scheduled message
/// events the server sends update it too.
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

  // Bumped by clear(), so a request that completes afterwards writes nothing.
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

  /// {@template scheduledMessages.query}
  /// Queries one page of the current user's scheduled messages.
  ///
  /// Adds the page [query] picks to the list, without removing any.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails.
  /// {@endtemplate}
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

  /// {@template scheduledMessages.load}
  /// Loads all of the current user's scheduled messages.
  ///
  /// The list then holds all of them, and
  /// [ScheduledMessageListState.hasLoadedAll] is true. Resolves to the list's
  /// state. Calling this again while it runs returns the same result.
  ///
  /// Throws a [StreamChatNetworkError] if a request fails; the ones loaded
  /// before it stay listed.
  /// {@endtemplate}
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

  /// {@template scheduledMessages.schedule}
  /// Schedules [message] to be sent at [scheduledAt].
  ///
  /// It goes to the channel [channelId] of [channelType], and is listed right
  /// away. If the request fails in a way that can be retried, it stays listed
  /// as failed. If [scheduledAt] has passed by then, it is sent right away and
  /// [ScheduleMessageResponse.scheduledMessage] is null.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, a
  /// [ScheduledMessageRefusedError] if it can't be scheduled in that channel,
  /// an [ArgumentError] if [scheduledAt] isn't in the future or an attachment
  /// isn't uploaded, and a [StateError] if no user is connected.
  /// {@endtemplate}
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

  /// {@template scheduledMessages.update}
  /// Edits the scheduled message [id].
  ///
  /// Replaces its message with [message] and, if given, moves it to
  /// [scheduledAt]. The edit is listed right away, and stays listed with a
  /// [ScheduledMessageUpdatingFailed] if saving it fails. One whose scheduling
  /// failed is scheduled again with the edit.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, such as with
  /// [ScheduledMessageErrorReason.scheduledAtTooSoon] for a time that isn't in
  /// the future.
  ///
  /// Throws a [ScheduledMessageRefusedError] if the edit can't be scheduled, or
  /// once sending the message failed.
  ///
  /// Throws an [ArgumentError] if an attachment isn't uploaded, and a
  /// [StateError] while the message is still being scheduled.
  /// {@endtemplate}
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

    final scheduledMessage = _listed(id);
    if (scheduledMessage == null) return _updateUnlisted(request);
    _refuseChange(scheduledMessage);

    if (scheduledMessage.isSchedulingFailed) {
      _refuseTimePassed(scheduledAt ?? scheduledMessage.scheduledAt);
      final scheduled = await _scheduleAgain(scheduledMessage, message: message, scheduledAt: scheduledAt);
      if (scheduled.status == .sent || _listed(id) == null) {
        return UpdateScheduledMessageResponse()..scheduledMessage = scheduled;
      }

      final edited = scheduled.copyWith(message: message, scheduledAt: scheduledAt);
      return _saveChange(scheduled, edited, request);
    }

    _refuseUnschedulable(scheduledMessage.cid, message);

    final edited = scheduledMessage.copyWith(message: message, scheduledAt: scheduledAt);
    return _saveChange(scheduledMessage, edited, request);
  }

  /// {@template scheduledMessages.reschedule}
  /// Moves the scheduled message [id] to [scheduledAt].
  ///
  /// It is listed at its new time right away, and stays listed with a
  /// [ScheduledMessageUpdatingFailed] if saving the move fails. An edit that
  /// failed to save is saved with it.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, such as with
  /// [ScheduledMessageErrorReason.scheduledAtTooSoon] for a time that isn't in
  /// the future.
  ///
  /// Throws a [ScheduledMessageRefusedError] if it can't be scheduled, or once
  /// sending it failed, and a [StateError] while it is still being scheduled.
  /// {@endtemplate}
  Future<UpdateScheduledMessageResponse> rescheduleMessage(
    String id, {
    required DateTime scheduledAt,
  }) async {
    Future<UpdateScheduledMessageResponse> request() {
      return _api.updateScheduledMessage(id, scheduledAt: scheduledAt);
    }

    final scheduledMessage = _listed(id);
    if (scheduledMessage == null) return _updateUnlisted(request);
    _refuseChange(scheduledMessage);

    if (scheduledMessage.isSchedulingFailed) {
      _refuseTimePassed(scheduledAt);
      final scheduled = await _scheduleAgain(scheduledMessage, scheduledAt: scheduledAt);
      if (scheduled.status == .sent || _listed(id) == null) {
        return UpdateScheduledMessageResponse()..scheduledMessage = scheduled;
      }

      return _saveChange(scheduled, scheduled.copyWith(scheduledAt: scheduledAt), request);
    }

    if (scheduledMessage.isUpdatingFailed) {
      return updateMessage(id, scheduledMessage.message, scheduledAt: scheduledAt);
    }

    final isMoved = !scheduledAt.isAtSameMomentAs(scheduledMessage.scheduledAt);
    if (isMoved) {
      _refuseUnschedulable(scheduledMessage.cid, scheduledMessage.message);
    }

    return _saveChange(scheduledMessage, scheduledMessage.copyWith(scheduledAt: scheduledAt), request);
  }

  /// {@template scheduledMessages.sendNow}
  /// Sends the scheduled message [id] right away.
  ///
  /// It is listed as [ScheduledMessageStatus.preparingToSchedule] until the
  /// request completes, and as it was if the request fails. One whose edit
  /// failed is sent as last saved, and one whose scheduling failed is
  /// scheduled first. An [EventType.scheduledMessageSent] event follows once
  /// it has been sent.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, a
  /// [ScheduledMessageRefusedError] if it quotes a deleted message or sending
  /// it already failed, and a [StateError] while it is still being scheduled.
  /// {@endtemplate}
  Future<SendScheduledMessageNowResponse> sendMessageNow(String id) async {
    final scheduledMessage = _listed(id);
    if (scheduledMessage == null) return _api.sendScheduledMessageNow(id);
    _refuseChange(scheduledMessage);

    if (!scheduledMessage.isSchedulingFailed) return _sendNow(scheduledMessage);

    final scheduled = await _scheduleAgain(scheduledMessage);
    if (scheduled.status == .sent || _listed(id) == null) {
      return SendScheduledMessageNowResponse()..scheduledMessage = scheduled;
    }

    return _sendNow(scheduled);
  }

  /// {@template scheduledMessages.delete}
  /// Deletes the scheduled message [id] before it is sent.
  ///
  /// It stops being listed right away, and is listed again if the request
  /// fails, unless it no longer exists. Returns it with the status it had when
  /// it was deleted.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, including when it
  /// no longer exists or was already sent. One whose scheduling failed and
  /// that no longer exists is deleted without an error.
  /// {@endtemplate}
  Future<DeleteScheduledMessageResponse> deleteMessage(String id) async {
    final scheduledMessage = _listed(id);
    if (scheduledMessage == null) return _api.deleteScheduledMessage(id);

    final generation = _generation;
    final canceled = scheduledMessage.asCanceled();
    _remove(scheduledMessage.id);

    // Scheduling it deletes it once it ends.
    if (scheduledMessage.isBeingScheduled) {
      return DeleteScheduledMessageResponse()..scheduledMessage = canceled;
    }

    if (scheduledMessage.isSchedulingFailed) {
      return _deleteFailedToSchedule(scheduledMessage, canceled, generation);
    }

    return _request(
      scheduledMessage,
      generation,
      () => _api.deleteScheduledMessage(id),
      relistOnFailure: (_) => scheduledMessage,
      relistIfUnlisted: true,
    );
  }

  /// {@template scheduledMessages.resend}
  /// Makes the failed request of the scheduled message [id] again.
  ///
  /// Schedules one whose scheduling failed, or saves the edit of one whose edit
  /// failed. Resolves to the scheduled message, or null when its time had
  /// passed and it was sent right away. One that is refused stays listed as
  /// failed.
  ///
  /// Throws a [StreamChatNetworkError] if the request fails, a
  /// [ScheduledMessageRefusedError] if it is refused, an [ArgumentError] if an
  /// attachment isn't uploaded, and a [StateError] if [id] isn't listed with a
  /// failure that can be resent, or no user is connected.
  /// {@endtemplate}
  Future<ScheduledMessage?> resendMessage(String id) async {
    final scheduledMessage = _listed(id);
    if (scheduledMessage == null) throw StateError('No scheduled message $id to resend.');

    if (scheduledMessage.isUpdatingFailed) {
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
    _refuseUnschedulable(cid, message);

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

    _upsert(local, generation);

    // A list cleared by a disconnect doesn't mean it was deleted.
    bool wasDeletedMeanwhile() {
      if (!_isCurrent(generation)) return false;
      return _listed(local.id) == null;
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
        _remove(local.id);
        return response;
      }

      await _upsertUnlessDeleted(created, generation, wasDeletedMeanwhile: wasDeletedMeanwhile());
      return response;
    } on StreamChatNetworkError catch (error) {
      // Sent or deleted: on a retry, the first attempt went through.
      if (error.isGone) {
        _remove(local.id);
        rethrow;
      }

      if (!error.isRetriable) {
        _undoRefused(local, restoreOnRefusal, generation, wasDeletedMeanwhile: wasDeletedMeanwhile());
        rethrow;
      }

      final failed = local.copyWith(
        status: .failed,
        failure: const ScheduledMessageFailure.schedulingFailed(),
        localUpdatedAt: clock.now(),
      );

      // It may have been stored all the same.
      await _upsertUnlessDeleted(failed, generation, wasDeletedMeanwhile: wasDeletedMeanwhile());
      rethrow;
    } catch (_) {
      _undoRefused(local, restoreOnRefusal, generation, wasDeletedMeanwhile: wasDeletedMeanwhile());
      rethrow;
    }
  }

  // Takes [local], refused, out of the list, or lists [restored] in its place,
  // unless [local] was deleted meanwhile.
  void _undoRefused(
    ScheduledMessage local,
    ScheduledMessage? restored,
    int generation, {
    required bool wasDeletedMeanwhile,
  }) {
    if (restored != null && !wasDeletedMeanwhile) {
      _upsert(restored, generation);
    } else {
      _remove(local.id);
    }
  }

  // Lists [scheduledMessage], unless the user deleted it meanwhile and
  // deleting it again succeeds, so one still there can be deleted again.
  Future<void> _upsertUnlessDeleted(
    ScheduledMessage scheduledMessage,
    int generation, {
    required bool wasDeletedMeanwhile,
  }) async {
    if (wasDeletedMeanwhile && await _deleteOnServer(scheduledMessage.id)) return;
    _upsert(scheduledMessage, generation);
  }

  // Deletes the scheduled message [id], deleted while it was being scheduled,
  // and returns whether it is gone, including when it was already sent or
  // deleted.
  Future<bool> _deleteOnServer(String id) async {
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
  // with [message] and at [scheduledAt], if given. Returns the scheduled copy,
  // which can be the one an earlier attempt stored, without the change; or it
  // marked sent when its time had passed and it was sent right away.
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
      restoreOnRefusal: scheduledMessage,
    );

    return response.scheduledMessage ?? scheduledMessage.asSent();
  }

  // Lists [edited] as being saved while [request] saves it over
  // [scheduledMessage], then the saved copy. If the request fails, [edited]
  // stays listed as failed, unless the message is being sent or is gone.
  Future<UpdateScheduledMessageResponse> _saveChange(
    ScheduledMessage scheduledMessage,
    ScheduledMessage edited,
    Future<UpdateScheduledMessageResponse> Function() request,
  ) async {
    final generation = _generation;
    final saving = edited.asPreparing();
    _upsert(saving, generation);

    final response = await _request(
      scheduledMessage,
      generation,
      request,
      relistOnFailure: (error) => saving.copyWith(
        status: .failed,
        failure: _updatingFailureOf(error),
      ),
    );

    _upsertAnswer(scheduledMessage, response.scheduledMessage, generation);
    return response;
  }

  // Sends [scheduledMessage], which is scheduled, right away.
  Future<SendScheduledMessageNowResponse> _sendNow(ScheduledMessage scheduledMessage) async {
    _refuseDeletedQuote(scheduledMessage.cid, scheduledMessage.message);

    final generation = _generation;
    _upsert(scheduledMessage.asPreparing(), generation);

    final response = await _request(
      scheduledMessage,
      generation,
      () => _api.sendScheduledMessageNow(scheduledMessage.id),
      relistOnFailure: (_) => scheduledMessage.asLocallyNewer(),
    );

    _upsertAnswer(scheduledMessage, response.scheduledMessage, generation);
    return response;
  }

  // Deletes [scheduledMessage], whose scheduling failed, so it may never have
  // been scheduled. It is listed again if deleting it fails.
  Future<DeleteScheduledMessageResponse> _deleteFailedToSchedule(
    ScheduledMessage scheduledMessage,
    ScheduledMessage canceled,
    int generation,
  ) async {
    try {
      return await _api.deleteScheduledMessage(scheduledMessage.id);
    } catch (error) {
      // One already sent stays out of the list, and the error says so.
      if (error is StreamChatNetworkError && error.isAlreadySent) rethrow;

      if (error is StreamChatNetworkError && error.isGone) {
        return DeleteScheduledMessageResponse()..scheduledMessage = canceled;
      }

      _upsert(scheduledMessage, generation);
      rethrow;
    }
  }

  // Runs [request] on [scheduledMessage]. If it fails, one found sent or gone
  // stops being listed. Otherwise, if it is still listed or [relistIfUnlisted]
  // is true, it is listed as [relistOnFailure] returns, or as it was when it
  // can no longer be changed.
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
      if (networkError != null && networkError.isGone) {
        _remove(scheduledMessage.id);
        rethrow;
      }

      final isListed = _listed(scheduledMessage.id) != null;
      if (!isListed && !relistIfUnlisted) rethrow;

      if (networkError == null || !networkError.isNotEditable) {
        _upsert(relistOnFailure(error), generation);
        rethrow;
      }

      // One taken out of the list may be sent by now.
      if (isListed) {
        _upsert(scheduledMessage.asLocallyNewer(), generation);
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
    _upsert(response.scheduledMessage, generation);
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

  // Refuses [message] in the channel [cid] when it quotes a deleted message or
  // is a command.
  void _refuseUnschedulable(String cid, Message message) {
    _refuseDeletedQuote(cid, message);

    final channel = _client.state.channels[cid];
    if (ScheduledMessageRules.isCommand(message, channel)) {
      throw const ScheduledMessageRefusedError(.scheduledMessageIsCommand, "Commands can't be scheduled");
    }
  }

  // Refuses [message] in the channel [cid] when it quotes a deleted message.
  // Sending now checks only this, as a deleted quote would fail it once sent.
  void _refuseDeletedQuote(String cid, Message message) {
    final channel = _client.state.channels[cid];
    if (ScheduledMessageRules.quotesDeletedMessage(message, channel)) {
      throw const ScheduledMessageRefusedError(.scheduledMessageQuoteDeleted, "Can't quote a deleted message");
    }
  }

  // The failure a change that failed with [error] is listed with. One stopped
  // by a temporary error, or by a change made at the same time, can be
  // retried.
  static ScheduledMessageFailure _updatingFailureOf(Object error) {
    final reason = error is StreamChatNetworkError ? error.scheduledMessageErrorReason : null;
    final isRetriable = switch (error) {
      StreamChatNetworkError(isRetriable: true) => true,
      StreamChatNetworkError() => reason == .scheduledMessageConflict,
      _ => true,
    };

    return .updatingFailed(reason: reason, isRetriable: isRetriable);
  }

  // The scheduled message with [id] in the client's list, if it is listed.
  ScheduledMessage? _listed(String id) {
    return state.scheduledMessages.where((it) => it.id == id).firstOrNull;
  }

  // Lists [answered] in place of the copy being prepared, unless
  // [scheduledMessage] was sent or deleted meanwhile. An answer of the same
  // version is marked changed, so it still replaces that copy.
  void _upsertAnswer(
    ScheduledMessage scheduledMessage,
    ScheduledMessage answered,
    int generation,
  ) {
    if (_listed(scheduledMessage.id) == null) return;

    final isSameVersion = answered.remoteUpdatedAt == scheduledMessage.remoteUpdatedAt;
    final listed = isSameVersion ? answered.asLocallyNewer() : answered;
    _upsert(listed, generation);
  }

  // Whether the user is the one who was connected at [generation].
  bool _isCurrent(int generation) => generation == _generation;

  // Lists [scheduledMessage], unless the user changed since [generation].
  void _upsert(ScheduledMessage scheduledMessage, int generation) {
    if (!_isCurrent(generation)) return;
    _stateNotifier.onScheduledMessageUpserted(scheduledMessage);
  }

  // Stops listing the scheduled message [id].
  void _remove(String id) {
    _stateNotifier.onScheduledMessageRemoved(id);
  }
}

// Why a request on a scheduled message was refused.
extension on StreamChatNetworkError {
  /// Whether the scheduled message was already sent.
  bool get isAlreadySent => scheduledMessageErrorReason == .scheduledMessageAlreadySent;

  /// Whether the scheduled message is not found, already sent, or deleted.
  bool get isGone {
    if (isAlreadySent || isScheduledMessageNotFound) return true;
    return scheduledMessageErrorReason == .scheduledMessageCanceled;
  }

  /// Whether the scheduled message is being sent, or can no longer change.
  bool get isNotEditable => switch (scheduledMessageErrorReason) {
    .scheduledMessageSending || .scheduledMessageNotEditable => true,
    _ => false,
  };
}

extension on ScheduledMessage {
  /// This copy, marked as being prepared.
  ScheduledMessage asPreparing() => copyWith(
    status: .preparingToSchedule,
    failure: null,
    localUpdatedAt: clock.now(),
  );

  /// This copy, marked sent.
  ScheduledMessage asSent() => copyWith(
    status: .sent,
    localUpdatedAt: clock.now(),
  );

  /// A copy with a newer local time, so it replaces one being prepared that
  /// has the same remote version.
  ScheduledMessage asLocallyNewer() => copyWith(
    localUpdatedAt: clock.now(),
  );

  /// This copy, marked canceled.
  ScheduledMessage asCanceled() => copyWith(
    status: .canceled,
    failure: null,
    localUpdatedAt: clock.now(),
  );
}
