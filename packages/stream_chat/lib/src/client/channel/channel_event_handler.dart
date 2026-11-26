import '../../../stream_chat.dart';
import 'channel_state_mutations.dart';

/// Routes channel events to the matching [ChannelStateMutations] methods.
///
/// Drops events with a missing payload, as well as events that do not apply
/// to the channel or the current user. A few handlers instead require their
/// payload; see [handleEvent] for how such a failure is contained.
///
/// Also performs the side effects an event triggers outside the channel
/// state: member refresh, persisted-message cleanup, and delivery
/// reconciliation.
class ChannelEventHandler {
  /// Creates a handler routing events of the given [_channel] to the given
  /// [_mutations].
  const ChannelEventHandler({
    required this._channel,
    required this._mutations,
  });

  final Channel _channel;
  final ChannelStateMutations _mutations;

  StreamChatClient get _client => _channel.client;

  /// Handles the given channel [event].
  ///
  /// Routes the event by its class, applying its effects in a fixed order.
  ///
  /// Only synchronous failures are contained: a stage that throws is logged
  /// and the remaining stages still run for the same event. A failure after
  /// an `await` is not — the `async` handlers have their futures discarded
  /// here, and some state writes are themselves `async void`, so both surface
  /// as unhandled async errors rather than logged warnings.
  void handleEvent(ChatEvent event) {
    _guard(event, 'message and channel dispatch', () => _dispatchMessageAndChannelEvents(event));
    _guard(event, 'channel counts', () => _onChannelCounts(event));
    _guard(event, 'member list dispatch', () => _dispatchMemberListEvents(event));
    _guard(event, 'member user merge', () => _onMemberUserUpdated(event));
    _guard(event, 'remaining dispatch', () => _dispatchRemainingEvents(event));
  }

  // Runs the given [stage] of [event] handling, containing a synchronous
  // failure so the remaining stages still run for the same event.
  void _guard(ChatEvent event, String stage, void Function() region) {
    try {
      region();
    } catch (error, stackTrace) {
      _client.logger.w(
        () => 'Error handling ${event.type} event in $stage',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  // Routes typing, message, draft, reaction, poll, read, and channel events.
  void _dispatchMessageAndChannelEvents(ChatEvent event) {
    switch (event) {
      // typing events
      case TypingStartEvent():
        _onTypingStart(event);
      case TypingStopEvent():
        _onTypingStop(event);
      // message events
      case MessageNewEvent():
        _mutations.onMessageNew(event.message, watcherCount: event.watcherCount);
      // Only a new message in a watched channel carries a reliable watcher
      // count; one for a non-watched channel reports 0.
      case NotificationMessageNewEvent():
        _mutations.onMessageNew(event.message);
      case MessageDeletedEvent():
        _onMessageDeleted(event);
      case MessageUpdatedEvent():
        _mutations.onMessageUpdated(event.message, editor: event.user);
      // draft events
      case DraftUpdatedEvent(:final draft?):
        _mutations.onDraftUpdated(draft);
      case DraftDeletedEvent(:final draft?):
        _mutations.onDraftDeleted(draft);
      // reaction events
      case ReactionNewEvent(:final message?, :final reaction?):
        _mutations.onReactionNew(message, reaction);
      case ReactionUpdatedEvent(:final message, :final reaction?):
        _mutations.onReactionUpdated(message, reaction);
      case ReactionDeletedEvent(:final message?, :final reaction?):
        _mutations.onReactionDeleted(message, reaction);
      // poll events
      case PollUpdatedEvent():
        _mutations.onPollUpdated(event.poll);
      case PollClosedEvent():
        _mutations.onPollClosed(event.poll);
      case PollAnswerCastedEvent():
        _mutations.onPollAnswerCasted(event.poll, event.pollVote);
      case PollVoteCastedEvent():
        _mutations.onPollVoteCasted(event.poll, event.pollVote);
      case PollVoteChangedEvent():
        _mutations.onPollVoteChanged(event.poll, event.pollVote);
      case PollAnswerRemovedEvent():
        _mutations.onPollAnswerRemoved(event.poll, event.pollVote);
      case PollVoteRemovedEvent():
        _mutations.onPollVoteRemoved(event.poll, event.pollVote);
      // read events
      case MessageReadEvent():
        _onMessageRead(event, event.user, event.thread, event.lastReadMessageId);
      case NotificationMarkReadEvent():
        _onMessageRead(event, event.user, event.thread, event.lastReadMessageId);
      case NotificationMarkUnreadEvent():
        _onNotificationMarkUnread(event);
      case MessageDeliveredEvent():
        _onMessageDelivered(event);
      // channel events
      case ChannelTruncatedEvent():
        _onChannelTruncated(event, event.channel, event.message);
      case NotificationChannelTruncatedEvent():
        _onChannelTruncated(event, event.channel, event.message);
      case ChannelUpdatedEvent():
        _mutations.onChannelUpdated(event.channel);
    }
  }

  // Routes the member added and removed events.
  void _dispatchMemberListEvents(ChatEvent event) {
    switch (event) {
      case MemberAddedEvent():
        _mutations.onMemberAdded(event.member);
      case MemberRemovedEvent():
        _onMemberRemoved(event);
    }
  }

  // Routes the remaining member, watching, reminder, location, and channel
  // push preference events.
  void _dispatchRemainingEvents(ChatEvent event) {
    switch (event) {
      // member events
      case MemberUpdatedEvent():
        _mutations.onMemberUpdated(event.member);
      case UserBannedEvent():
        _onMemberBanned(event.cid, event.user);
      case UserUnbannedEvent():
        _onMemberUnbanned(event.cid, event.user);
      case UserMessagesDeletedEvent():
        _mutations.onUserMessagesDeleted(
          userId: event.user.id,
          hardDelete: event.hardDelete ?? false,
          deletedAt: event.createdAt,
        );
      // user watching events
      case UserWatchingStartEvent():
        _mutations.onUserStartWatching(event.user, watcherCount: event.watcherCount);
      case UserWatchingStopEvent():
        _mutations.onUserStopWatching(event.user, watcherCount: event.watcherCount);
      // reminder events
      case ReminderCreatedEvent():
        _mutations.onReminderCreated(event.reminder);
      case ReminderUpdatedEvent():
        _mutations.onReminderUpdated(event.reminder);
      case ReminderDeletedEvent():
        _mutations.onReminderDeleted(event.reminder);
      // location events
      case LocationSharedEvent(:final message) when message.sharedLocation != null:
        _mutations.onLocationShared(message);
      case LocationUpdatedEvent(message: Message(:final sharedLocation?)):
        _mutations.onLocationUpdated(sharedLocation);
      case LocationExpiredEvent(message: Message(:final sharedLocation?)):
        _mutations.onLocationExpired(sharedLocation);
      // channel push preference events
      case ChannelPushPreferenceUpdatedEvent():
        _mutations.onChannelPushPreferenceUpdated(event.channelPushPreference);
    }
  }

  void _onTypingStart(TypingStartEvent event) {
    final user = event.user;
    if (user == null) return;

    final currentUser = _client.state.currentUser;
    if (user.id == currentUser?.id) return;

    _mutations.onTypingStart(user, event);
  }

  void _onTypingStop(TypingStopEvent event) {
    final user = event.user;
    if (user == null) return;

    final currentUser = _client.state.currentUser;
    if (user.id == currentUser?.id) return;

    _mutations.onTypingStop(user);
  }

  void _onMessageDeleted(MessageDeletedEvent event) {
    final message = event.message.copyWith(
      // TODO: Remove once deletedForMe is properly enriched on the backend.
      deletedForMe: event.deletedForMe,
    );

    return _mutations.onMessageDeleted(message, hardDelete: event.hardDelete);
  }

  void _onMessageRead(ChatEvent event, User? user, Thread? thread, String? lastReadMessageId) {
    // Skip handling the event if delivered for a thread
    if (thread != null) return;
    if (user == null) return;

    _mutations.onMessageRead(
      user,
      lastRead: event.createdAt,
      lastReadMessageId: lastReadMessageId,
    );

    // If the read event is from the current user, reconcile the channel
    // delivery status with the updated read state, and clear any pending
    // manual mark-unread — the user has read past it.
    final currentUser = _client.state.currentUser;
    if (user.id == currentUser?.id) {
      _client.channelDeliveryReporter.reconcileDelivery([_channel]);
      _channel.state?.isMarkedAsUnread = false;
    }
  }

  void _onNotificationMarkUnread(NotificationMarkUnreadEvent event) {
    final user = event.user;
    if (user == null) return;

    _mutations.onNotificationMarkUnread(
      user,
      lastRead: event.lastReadAt!,
      unreadMessages: event.unreadMessages,
      lastReadMessageId: event.lastReadMessageId,
    );

    // Only a mark-unread for the current user's own read state should gate
    // this device's auto mark-read.
    final currentUser = _client.state.currentUser;
    if (user.id == currentUser?.id) {
      _channel.state?.isMarkedAsUnread = true;
    }
  }

  void _onMessageDelivered(MessageDeliveredEvent event) {
    final user = event.user;
    if (user == null) return;

    _mutations.onMessageDelivered(
      user,
      lastDeliveredAt: event.lastDeliveredAt,
      lastDeliveredMessageId: event.lastDeliveredMessageId,
    );

    // If the delivered event is from the current user, reconcile
    // the channel delivery with the updated read state.
    final currentUser = _client.state.currentUser;
    if (user.id == currentUser?.id) {
      _client.channelDeliveryReporter.reconcileDelivery([_channel]);
    }
  }

  Future<void> _onChannelTruncated(ChatEvent event, ChannelModel channel, Message? message) async {
    // A truncation of only some members leaves the channel's truncation time
    // unchanged; a channel without one is cut at the event's own time.
    final cutoff = channel.truncatedAt ?? event.createdAt;
    await _client.chatPersistenceClient?.truncateChannel(
      channel.cid,
      truncatedAt: cutoff,
    );

    _mutations.onChannelTruncated(
      channel,
      cutoff: cutoff,
      message: message,
    );
  }

  void _onChannelCounts(ChatEvent event) {
    if (event is! HasChannelCounts) return;

    final memberCount = event.channelMemberCount;
    final messageCount = event.channelMessageCount;
    if (memberCount == null && messageCount == null) return;

    return _mutations.onChannelCounts(
      memberCount: memberCount,
      messageCount: messageCount,
    );
  }

  void _onMemberRemoved(MemberRemovedEvent event) {
    final user = event.user;
    if (user == null) return;

    return _mutations.onMemberRemoved(user);
  }

  void _onMemberUserUpdated(ChatEvent event) {
    if (event case HasUser(:final user?)) return _mutations.onMemberUserUpdated(user);
  }

  Future<void> _onMemberBanned(String? cid, User user) async {
    // Filters channel ban from app ban.
    if (cid == null) return;

    final member = await _queryMember(user.id);
    if (member == null) return;

    _mutations.onMemberBanned(member);
  }

  Future<void> _onMemberUnbanned(String? cid, User user) async {
    // Filters channel ban from app ban.
    if (cid == null) return;

    final member = await _queryMember(user.id);
    if (member == null) return;

    _mutations.onMemberUnbanned(member);
  }

  // The member with the user id [userId], or null when the query fails or
  // finds none.
  Future<Member?> _queryMember(String userId) async {
    final result = await _channel.queryMembers(filter: .equal(MemberFilterField.userId, userId));
    return result.getOrNull()?.members.firstOrNull;
  }
}
