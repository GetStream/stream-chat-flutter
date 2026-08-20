import 'package:stream_chat/src/client/channel_state_mutations.dart';
import 'package:stream_chat/stream_chat.dart';

/// Translates channel events into [ChannelClientState] mutations.
///
/// Validates and routes each event; the resulting state writes are performed
/// by [ChannelStateMutations].
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
  /// Handlers run in the same relative order as the subscriptions they
  /// replace, which were wired in the [ChannelClientState] constructor and
  /// fired in subscription order. Two of those subscriptions were unfiltered
  /// and observed every event ([_onChannelMessageCount] and
  /// [_onMemberUserUpdated]), so dispatch happens in three blocks around them
  /// to preserve the original execution order.
  void handleEvent(Event event) {
    // Block 1: handlers wired before the channel-message-count listener.
    switch (event.type) {
      // typing events
      case EventType.typingStart:
        _onTypingStart(event);
      case EventType.typingStop:
        _onTypingStop(event);
      // message events
      case EventType.messageNew:
      case EventType.notificationMessageNew:
        _onMessageNew(event);
      case EventType.messageDeleted:
        _onMessageDeleted(event);
      case EventType.messageUpdated:
        _onMessageUpdated(event);
      // draft events
      case EventType.draftUpdated:
        _onDraftUpdated(event);
      case EventType.draftDeleted:
        _onDraftDeleted(event);
      // reaction events
      case EventType.reactionNew:
        _onReactionNew(event);
      case EventType.reactionUpdated:
        _onReactionUpdated(event);
      case EventType.reactionDeleted:
        _onReactionDeleted(event);
      // poll events
      case EventType.pollCreated:
        _onPollCreated(event);
      case EventType.pollUpdated:
        _onPollUpdated(event);
      case EventType.pollClosed:
        _onPollClosed(event);
      case EventType.pollAnswerCasted:
        _onPollAnswerCasted(event);
      case EventType.pollVoteCasted:
        _onPollVoteCasted(event);
      case EventType.pollVoteChanged:
        _onPollVoteChanged(event);
      case EventType.pollAnswerRemoved:
        _onPollAnswerRemoved(event);
      case EventType.pollVoteRemoved:
        _onPollVoteRemoved(event);
      // read events
      case EventType.messageRead:
      case EventType.notificationMarkRead:
        _onMessageRead(event);
      case EventType.notificationMarkUnread:
        _onNotificationMarkUnread(event);
      case EventType.messageDelivered:
        _onMessageDelivered(event);
      // channel events
      case EventType.channelTruncated:
      case EventType.notificationChannelTruncated:
        _onChannelTruncated(event);
      case EventType.channelUpdated:
        _onChannelUpdated(event);
    }

    // Unfiltered: updates the channel message count on any event carrying one.
    _onChannelMessageCount(event);

    // Block 2: handlers wired between the two unfiltered listeners.
    switch (event.type) {
      // member events
      case EventType.memberAdded:
        _onMemberAdded(event);
      case EventType.memberRemoved:
        _onMemberRemoved(event);
    }

    // Unfiltered: merges an updated event user into the member list.
    _onMemberUserUpdated(event);

    // Block 3: handlers wired after the member-user merge listener.
    switch (event.type) {
      // member events
      case EventType.memberUpdated:
        _onMemberUpdated(event);
      case EventType.userBanned:
        _onMemberBanned(event);
      case EventType.userUnbanned:
        _onMemberUnbanned(event);
      case EventType.userMessagesDeleted:
        _onUserMessagesDeleted(event);
      // user watching events
      case EventType.userWatchingStart:
        _onUserStartWatching(event);
      case EventType.userWatchingStop:
        _onUserStopWatching(event);
      // reminder events
      case EventType.reminderCreated:
        _onReminderCreated(event);
      case EventType.reminderUpdated:
        _onReminderUpdated(event);
      case EventType.reminderDeleted:
        _onReminderDeleted(event);
      // location events
      case EventType.locationShared:
        _onLocationShared(event);
      case EventType.locationUpdated:
        _onLocationUpdated(event);
      case EventType.locationExpired:
        _onLocationExpired(event);
      // channel push preference events
      case EventType.channelPushPreferenceUpdated:
        _onChannelPushPreferenceUpdated(event);
    }
  }

  void _onTypingStart(Event event) {
    final user = event.user;
    if (user == null) return;

    final currentUser = _client.state.currentUser;
    if (event.isFromUser(userId: currentUser?.id)) return;

    _mutations.onTypingStart(user, event);
  }

  void _onTypingStop(Event event) {
    final user = event.user;
    if (user == null) return;

    final currentUser = _client.state.currentUser;
    if (event.isFromUser(userId: currentUser?.id)) return;

    _mutations.onTypingStop(user);
  }

  void _onMessageNew(Event event) {
    final message = event.message;
    if (message == null) return;

    // Only message.new carries a reliable watcher count;
    // notification.message_new targets non-watchers and reports 0.
    final watcherCount = switch (event.type) {
      EventType.messageNew => event.watcherCount,
      _ => null,
    };

    _mutations.onMessageNew(message, watcherCount: watcherCount);
  }

  void _onMessageDeleted(Event event) {
    final hardDelete = event.hardDelete ?? false;

    final message = event.message!.copyWith(
      // TODO: Remove once deletedForMe is properly enriched on the backend.
      deletedForMe: event.deletedForMe,
    );

    return _mutations.onMessageDeleted(message, hardDelete: hardDelete);
  }

  void _onMessageUpdated(Event event) {
    final message = event.message;
    if (message == null) return;

    return _mutations.onMessageUpdated(message);
  }

  void _onDraftUpdated(Event event) {
    final draft = event.draft;
    if (draft == null) return;

    return _mutations.onDraftUpdated(draft);
  }

  void _onDraftDeleted(Event event) {
    final draft = event.draft;
    if (draft == null) return;

    return _mutations.onDraftDeleted(draft);
  }

  void _onReactionNew(Event event) {
    final (eventReaction, eventMessage) = (event.reaction, event.message);
    if (eventReaction == null || eventMessage == null) return;

    return _mutations.onReactionNew(eventMessage, eventReaction);
  }

  void _onReactionUpdated(Event event) {
    final (eventReaction, eventMessage) = (event.reaction, event.message);
    if (eventReaction == null || eventMessage == null) return;

    return _mutations.onReactionUpdated(eventMessage, eventReaction);
  }

  void _onReactionDeleted(Event event) {
    final (eventReaction, eventMessage) = (event.reaction, event.message);
    if (eventReaction == null || eventMessage == null) return;

    return _mutations.onReactionDeleted(eventMessage, eventReaction);
  }

  void _onPollCreated(Event event) {
    final message = event.message;
    if (message == null || message.poll == null) return;

    return _mutations.onPollCreated(message);
  }

  void _onPollUpdated(Event event) {
    final eventPoll = event.poll;
    if (eventPoll == null) return;

    return _mutations.onPollUpdated(eventPoll);
  }

  void _onPollClosed(Event event) {
    final eventPoll = event.poll;
    if (eventPoll == null) return;

    return _mutations.onPollClosed(eventPoll);
  }

  void _onPollAnswerCasted(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    return _mutations.onPollAnswerCasted(eventPoll, eventPollVote);
  }

  void _onPollVoteCasted(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    return _mutations.onPollVoteCasted(eventPoll, eventPollVote);
  }

  void _onPollVoteChanged(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    return _mutations.onPollVoteChanged(eventPoll, eventPollVote);
  }

  void _onPollAnswerRemoved(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    return _mutations.onPollAnswerRemoved(eventPoll, eventPollVote);
  }

  void _onPollVoteRemoved(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    return _mutations.onPollVoteRemoved(eventPoll, eventPollVote);
  }

  void _onMessageRead(Event event) {
    // Skip handling the event if delivered for a thread
    if (event.thread != null) return;

    final user = event.user;
    if (user == null) return;

    _mutations.onMessageRead(
      user,
      lastRead: event.createdAt,
      lastReadMessageId: event.lastReadMessageId,
    );

    // If the read event is from the current user, reconcile the
    // channel delivery status with the updated read state.
    final currentUser = _client.state.currentUser;
    if (event.isFromUser(userId: currentUser?.id)) {
      _client.channelDeliveryReporter.reconcileDelivery([_channel]);
    }
  }

  void _onNotificationMarkUnread(Event event) {
    final user = event.user;
    if (user == null) return;

    return _mutations.onNotificationMarkUnread(
      user,
      lastRead: event.lastReadAt!,
      unreadMessages: event.unreadMessages,
      lastReadMessageId: event.lastReadMessageId,
    );
  }

  void _onMessageDelivered(Event event) {
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
    if (event.isFromUser(userId: currentUser?.id)) {
      _client.channelDeliveryReporter.reconcileDelivery([_channel]);
    }
  }

  Future<void> _onChannelTruncated(Event event) async {
    final channel = event.channel!;
    await _client.chatPersistenceClient?.deleteMessageByCid(channel.cid);

    _mutations.onChannelTruncated(message: event.message);
  }

  void _onChannelUpdated(Event event) {
    final channel = event.channel!;

    return _mutations.onChannelUpdated(channel);
  }

  void _onChannelMessageCount(Event event) {
    final messageCount = event.channelMessageCount;
    if (messageCount == null) return;

    return _mutations.onChannelMessageCount(messageCount);
  }

  void _onMemberAdded(Event event) {
    final member = event.member!;

    return _mutations.onMemberAdded(member);
  }

  void _onMemberRemoved(Event event) {
    final user = event.user!;

    return _mutations.onMemberRemoved(user);
  }

  void _onMemberUserUpdated(Event event) {
    final user = event.user;
    if (user == null) return;

    return _mutations.onMemberUserUpdated(user);
  }

  void _onMemberUpdated(Event event) {
    final member = event.member!;

    return _mutations.onMemberUpdated(member);
  }

  Future<void> _onMemberBanned(Event event) async {
    // Filters channel ban from app ban.
    if (event.cid == null) return;

    final user = event.user!;
    final member = await _channel.queryMembers(filter: Filter.equal('id', user.id)).then((it) => it.members.first);

    _mutations.onMemberBanned(member);
  }

  Future<void> _onMemberUnbanned(Event event) async {
    // Filters channel ban from app ban.
    if (event.cid == null) return;

    final user = event.user!;
    final member = await _channel.queryMembers(filter: Filter.equal('id', user.id)).then((it) => it.members.first);

    _mutations.onMemberUnbanned(member);
  }

  Future<void> _onUserMessagesDeleted(Event event) async {
    final user = event.user;
    if (user == null) return;

    return _mutations.onUserMessagesDeleted(
      userId: user.id,
      hardDelete: event.hardDelete ?? false,
      deletedAt: event.createdAt,
    );
  }

  void _onUserStartWatching(Event event) {
    final watcher = event.user;
    if (watcher == null) return;

    return _mutations.onUserStartWatching(watcher, watcherCount: event.watcherCount);
  }

  void _onUserStopWatching(Event event) {
    final watcher = event.user;
    if (watcher == null) return;

    return _mutations.onUserStopWatching(watcher, watcherCount: event.watcherCount);
  }

  void _onReminderCreated(Event event) {
    final reminder = event.reminder;
    if (reminder == null) return;

    return _mutations.onReminderCreated(reminder);
  }

  void _onReminderUpdated(Event event) {
    final reminder = event.reminder;
    if (reminder == null) return;

    return _mutations.onReminderUpdated(reminder);
  }

  void _onReminderDeleted(Event event) {
    final reminder = event.reminder;
    if (reminder == null) return;

    return _mutations.onReminderDeleted(reminder);
  }

  void _onLocationShared(Event event) {
    final message = event.message;
    if (message == null || message.sharedLocation == null) return;

    return _mutations.onLocationShared(message);
  }

  void _onLocationUpdated(Event event) {
    final location = event.message?.sharedLocation;
    if (location == null) return;

    return _mutations.onLocationUpdated(location);
  }

  void _onLocationExpired(Event event) {
    final location = event.message?.sharedLocation;
    if (location == null) return;

    return _mutations.onLocationExpired(location);
  }

  void _onChannelPushPreferenceUpdated(Event event) {
    final pushPreferences = event.channelPushPreference;
    if (pushPreferences == null) return;

    return _mutations.onChannelPushPreferenceUpdated(pushPreferences);
  }
}
