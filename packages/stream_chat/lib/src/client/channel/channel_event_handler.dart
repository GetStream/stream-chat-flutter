import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:stream_chat/stream_chat.dart';

/// Translates channel events into [ChannelClientState] mutations.
class ChannelEventHandler {
  /// Creates a handler updating the given [_state] of the given [_channel].
  const ChannelEventHandler({
    required this._channel,
    required this._state,
  });

  final Channel _channel;
  final ChannelClientState _state;

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

    _state.upsertTypingEvent(user, event);
  }

  void _onTypingStop(Event event) {
    final user = event.user;
    if (user == null) return;

    final currentUser = _client.state.currentUser;
    if (event.isFromUser(userId: currentUser?.id)) return;

    _state.removeTypingEvent(user);
  }

  void _onMessageNew(Event event) {
    final message = event.message;
    if (message == null) return;

    _state.addNewMessage(message);

    // Only message.new carries a reliable watcher count;
    // notification.message_new targets non-watchers and reports 0.
    if (event.watcherCount case final watcherCount? when event.type == EventType.messageNew) {
      _state.updateChannelState(
        _state.channelState.copyWith(watcherCount: watcherCount),
      );
    }
  }

  void _onMessageDeleted(Event event) {
    final hardDelete = event.hardDelete ?? false;

    final message = event.message!.copyWith(
      // TODO: Remove once deletedForMe is properly enriched on the backend.
      deletedForMe: event.deletedForMe,
    );

    // Decrement the locally-tracked unread count for hard-deleted
    // messages that would have counted as unread. Soft-deleted messages
    // keep their slot. Only applies to channels that track unread counts
    // locally (see [Channel.usesLocalUnreadCount]) — server-driven
    // channels get corrected counts from server read events instead.
    if (hardDelete && _channel.usesLocalUnreadCount && MessageRules.canCountAsUnread(message, _channel)) {
      _state.unreadCount = math.max(0, _state.unreadCount - 1);
    }

    return _state.deleteMessage(message, hardDelete: hardDelete);
  }

  void _onMessageUpdated(Event event) {
    final message = event.message;
    if (message == null) return;

    return _state.updateMessage(message, upsert: false);
  }

  void _onDraftUpdated(Event event) {
    final draft = event.draft;
    if (draft == null) return;

    return _state.updateDraft(draft);
  }

  void _onDraftDeleted(Event event) {
    final draft = event.draft;
    if (draft == null) return;

    return _state.deleteDraft(draft);
  }

  void _onReactionNew(Event event) {
    final (eventReaction, eventMessage) = (event.reaction, event.message);
    if (eventReaction == null || eventMessage == null) return;

    final messageId = eventMessage.id;
    final parentId = eventMessage.parentId;

    for (final message in [..._state.messages, ...?_state.threads[parentId]]) {
      if (message.id == messageId) {
        final currentUserId = _client.state.currentUser?.id;

        final currentMessage = switch (currentUserId) {
          final userId? when userId == eventReaction.userId => message.addMyReaction(eventReaction),
          _ => message,
        };

        return _state.updateMessage(
          eventMessage.copyWith(
            ownReactions: currentMessage.ownReactions,
          ),
        );
      }
    }
  }

  void _onReactionUpdated(Event event) {
    final (eventReaction, eventMessage) = (event.reaction, event.message);
    if (eventReaction == null || eventMessage == null) return;

    final messageId = eventMessage.id;
    final parentId = eventMessage.parentId;

    for (final message in [..._state.messages, ...?_state.threads[parentId]]) {
      if (message.id == messageId) {
        final currentUserId = _client.state.currentUser?.id;

        final currentMessage = switch (currentUserId) {
          final userId? when userId == eventReaction.userId =>
            // reaction.updated is only called if enforce_unique is true
            message.addMyReaction(eventReaction, enforceUnique: true),
          _ => message,
        };

        return _state.updateMessage(
          eventMessage.copyWith(
            ownReactions: currentMessage.ownReactions,
          ),
        );
      }
    }
  }

  void _onReactionDeleted(Event event) {
    final (eventReaction, eventMessage) = (event.reaction, event.message);
    if (eventReaction == null || eventMessage == null) return;

    final messageId = eventMessage.id;
    final parentId = eventMessage.parentId;

    for (final message in [..._state.messages, ...?_state.threads[parentId]]) {
      if (message.id == messageId) {
        final currentUserId = _client.state.currentUser?.id;

        final currentMessage = switch (currentUserId) {
          final userId? when userId == eventReaction.userId => message.deleteMyReaction(
            reactionType: eventReaction.type,
          ),
          _ => message,
        };

        return _state.updateMessage(
          eventMessage.copyWith(
            ownReactions: currentMessage.ownReactions,
          ),
        );
      }
    }
  }

  Message? _findPollMessage(String pollId) {
    final message = _state.messages.firstWhereOrNull((it) => it.pollId == pollId);
    if (message != null) return message;

    final threadMessage = _state.threads.values.flattened.firstWhereOrNull((it) {
      return it.pollId == pollId;
    });

    return threadMessage;
  }

  void _onPollCreated(Event event) {
    final message = event.message;
    if (message == null || message.poll == null) return;

    return _state.addNewMessage(message);
  }

  void _onPollUpdated(Event event) {
    final eventPoll = event.poll;
    if (eventPoll == null) return;

    final pollMessage = _findPollMessage(eventPoll.id);
    if (pollMessage == null) return;

    final oldPoll = pollMessage.poll;

    final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
    final ownVotesAndAnswers = oldPoll?.ownVotesAndAnswers ?? eventPoll.ownVotesAndAnswers;

    final poll = eventPoll.copyWith(
      latestAnswers: latestAnswers,
      ownVotesAndAnswers: ownVotesAndAnswers,
    );

    final message = pollMessage.copyWith(poll: poll);
    _state.updateMessage(message);
  }

  void _onPollClosed(Event event) {
    final eventPoll = event.poll;
    if (eventPoll == null) return;

    final pollMessage = _findPollMessage(eventPoll.id);
    if (pollMessage == null) return;

    final oldPoll = pollMessage.poll;
    final poll = oldPoll?.copyWith(isClosed: true) ?? eventPoll;

    final message = pollMessage.copyWith(poll: poll);
    _state.updateMessage(message);
  }

  void _onPollAnswerCasted(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    final pollMessage = _findPollMessage(eventPoll.id);
    if (pollMessage == null) return;

    final oldPoll = pollMessage.poll;

    final latestAnswers = <String, PollVote>{
      for (final ans in oldPoll?.latestAnswers ?? []) ans.id: ans,
      eventPollVote.id!: eventPollVote,
    };

    final currentUserId = _client.state.currentUser?.id;
    final ownVotesAndAnswers = <String, PollVote>{
      for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
      if (eventPollVote.userId == currentUserId) eventPollVote.id!: eventPollVote,
    };

    final poll = eventPoll.copyWith(
      latestAnswers: [...latestAnswers.values],
      ownVotesAndAnswers: [...ownVotesAndAnswers.values],
    );

    final message = pollMessage.copyWith(poll: poll);
    _state.updateMessage(message);
  }

  void _onPollVoteCasted(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    final pollMessage = _findPollMessage(eventPoll.id);
    if (pollMessage == null) return;

    final oldPoll = pollMessage.poll;

    final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
    final currentUserId = _client.state.currentUser?.id;
    final ownVotesAndAnswers = <String, PollVote>{
      for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
      if (eventPollVote.userId == currentUserId) eventPollVote.id!: eventPollVote,
    };

    final poll = eventPoll.copyWith(
      latestAnswers: latestAnswers,
      ownVotesAndAnswers: [...ownVotesAndAnswers.values],
    );

    final message = pollMessage.copyWith(poll: poll);
    _state.updateMessage(message);
  }

  void _onPollVoteChanged(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    final pollMessage = _findPollMessage(eventPoll.id);
    if (pollMessage == null) return;

    final oldPoll = pollMessage.poll;

    final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
    final currentUserId = _client.state.currentUser?.id;
    final ownVotesAndAnswers = <String, PollVote>{
      for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
      if (eventPollVote.userId == currentUserId) eventPollVote.id!: eventPollVote,
    };

    final poll = eventPoll.copyWith(
      latestAnswers: latestAnswers,
      ownVotesAndAnswers: [...ownVotesAndAnswers.values],
    );

    final message = pollMessage.copyWith(poll: poll);
    _state.updateMessage(message);
  }

  void _onPollAnswerRemoved(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    final pollMessage = _findPollMessage(eventPoll.id);
    if (pollMessage == null) return;

    final oldPoll = pollMessage.poll;

    final latestAnswers = <String, PollVote>{
      for (final ans in oldPoll?.latestAnswers ?? []) ans.id: ans,
    }..remove(eventPollVote.id);

    final ownVotesAndAnswers = <String, PollVote>{
      for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
    }..remove(eventPollVote.id);

    final poll = eventPoll.copyWith(
      latestAnswers: [...latestAnswers.values],
      ownVotesAndAnswers: [...ownVotesAndAnswers.values],
    );

    final message = pollMessage.copyWith(poll: poll);
    _state.updateMessage(message);
  }

  void _onPollVoteRemoved(Event event) {
    final (eventPoll, eventPollVote) = (event.poll, event.pollVote);
    if (eventPoll == null || eventPollVote == null) return;

    final pollMessage = _findPollMessage(eventPoll.id);
    if (pollMessage == null) return;

    final oldPoll = pollMessage.poll;

    final latestAnswers = oldPoll?.latestAnswers ?? eventPoll.latestAnswers;
    final ownVotesAndAnswers = <String, PollVote>{
      for (final vote in oldPoll?.ownVotesAndAnswers ?? []) vote.id: vote,
    }..remove(eventPollVote.id);

    final poll = eventPoll.copyWith(
      latestAnswers: latestAnswers,
      ownVotesAndAnswers: [...ownVotesAndAnswers.values],
    );

    final message = pollMessage.copyWith(poll: poll);
    _state.updateMessage(message);
  }

  void _onMessageRead(Event event) {
    // Skip handling the event if delivered for a thread
    if (event.thread != null) return;

    final user = event.user;
    if (user == null) return;

    final currentRead = _state.userReadOf(userId: user.id);

    final updatedRead = Read(
      user: user,
      lastRead: event.createdAt,
      unreadMessages: 0, // Reset unread count
      lastReadMessageId: event.lastReadMessageId,
      // Preserve delivery info as it's not part of the read event.
      lastDeliveredAt: currentRead?.lastDeliveredAt,
      lastDeliveredMessageId: currentRead?.lastDeliveredMessageId,
    );

    _state.updateRead([updatedRead]);

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

    final currentRead = _state.userReadOf(userId: user.id);

    final updatedRead = Read(
      user: user,
      lastRead: event.lastReadAt!,
      unreadMessages: event.unreadMessages,
      lastReadMessageId: event.lastReadMessageId,
      // Preserve delivery info as it's not part of the read event.
      lastDeliveredAt: currentRead?.lastDeliveredAt,
      lastDeliveredMessageId: currentRead?.lastDeliveredMessageId,
    );

    return _state.updateRead([updatedRead]);
  }

  void _onMessageDelivered(Event event) {
    final user = event.user;
    if (user == null) return;

    final currentRead = _state.userReadOf(userId: user.id);
    final never = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

    final updatedRead = Read(
      user: user,
      lastDeliveredAt: event.lastDeliveredAt,
      lastDeliveredMessageId: event.lastDeliveredMessageId,
      // Preserve read info as it's not part of the delivery event.
      lastRead: currentRead?.lastRead ?? never,
      unreadMessages: currentRead?.unreadMessages,
      lastReadMessageId: currentRead?.lastReadMessageId,
    );

    _state.updateRead([updatedRead]);

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
    _state.truncate();
    if (event.message != null) {
      _state.updateMessage(event.message!);
    }
  }

  void _onChannelUpdated(Event event) {
    final channel = event.channel!;
    _state.updateChannelState(
      _state.channelState.copyWith(
        channel: _state.channelState.channel?.merge(channel),
        members: channel.members,
      ),
    );
  }

  void _onChannelMessageCount(Event event) {
    final messageCount = event.channelMessageCount;
    if (messageCount == null) return;

    _state.updateChannelState(
      _state.channelState.copyWith(
        channel: _state.channelState.channel?.copyWith(
          messageCount: messageCount,
        ),
      ),
    );
  }

  void _onMemberAdded(Event event) {
    final member = event.member!;
    final existingMembers = _state.channelState.members ?? [];

    _state.updateChannelState(
      _state.channelState.copyWith(
        members: [...existingMembers, member],
      ),
    );
  }

  void _onMemberRemoved(Event event) {
    final user = event.user!;
    final existingRead = _state.channelState.read ?? [];
    final existingMembers = _state.channelState.members ?? [];

    _state.updateChannelState(
      _state.channelState.copyWith(
        read: [...existingRead.where((r) => r.user.id != user.id)],
        members: [...existingMembers.where((m) => m.userId != user.id)],
      ),
    );
  }

  void _onMemberUserUpdated(Event event) {
    final user = event.user;
    if (user == null) return;

    final existingMembers = [...?_state.channelState.members];
    final existingMembership = _state.channelState.membership;

    // Return if the user is not a existing member of the channel.
    if (!existingMembers.any((m) => m.userId == user.id)) return;

    Member? maybeUpdateMemberUser(Member? existingMember) {
      if (existingMember == null) return null;
      if (existingMember.userId == user.id) {
        return existingMember.copyWith(user: user);
      }
      return existingMember;
    }

    _state.updateChannelState(
      _state.channelState.copyWith(
        membership: maybeUpdateMemberUser(existingMembership),
        members: [...existingMembers.map(maybeUpdateMemberUser).nonNulls],
      ),
    );
  }

  void _onMemberUpdated(Event event) {
    final member = event.member!;
    final existingMembers = _state.channelState.members ?? [];
    final existingMembership = _state.channelState.membership;

    Member? maybeUpdateMember(Member? existingMember) {
      if (existingMember == null) return null;
      if (existingMember.userId == member.userId) return member;
      return existingMember;
    }

    _state.updateChannelState(
      _state.channelState.copyWith(
        membership: maybeUpdateMember(existingMembership),
        members: [...existingMembers.map(maybeUpdateMember).nonNulls],
      ),
    );
  }

  Future<void> _onMemberBanned(Event event) async {
    // Filters channel ban from app ban.
    if (event.cid == null) return;

    final user = event.user!;
    final member = await _channel.queryMembers(filter: Filter.equal('id', user.id)).then((it) => it.members.first);

    _state.updateMember(member);
  }

  Future<void> _onMemberUnbanned(Event event) async {
    // Filters channel ban from app ban.
    if (event.cid == null) return;

    final user = event.user!;
    final member = await _channel.queryMembers(filter: Filter.equal('id', user.id)).then((it) => it.members.first);

    _state.updateMember(member);
  }

  Future<void> _onUserMessagesDeleted(Event event) async {
    final user = event.user;
    if (user == null) return;

    return _state.deleteMessagesFromUser(
      userId: user.id,
      hardDelete: event.hardDelete ?? false,
      deletedAt: event.createdAt,
    );
  }

  void _onUserStartWatching(Event event) {
    final watcher = event.user;
    if (watcher != null) {
      final existingWatchers = _state.channelState.watchers;
      _state.updateChannelState(
        _state.channelState.copyWith(
          watchers: [
            watcher,
            ...?existingWatchers?.where((user) => user.id != watcher.id),
          ],
          watcherCount: event.watcherCount,
        ),
      );
    }
  }

  void _onUserStopWatching(Event event) {
    final watcher = event.user;
    if (watcher != null) {
      _state.removeWatcher(watcher, watcherCount: event.watcherCount);
    }
  }

  void _onReminderCreated(Event event) {
    final reminder = event.reminder;
    if (reminder == null) return;

    _state.updateReminder(reminder);
  }

  void _onReminderUpdated(Event event) {
    final reminder = event.reminder;
    if (reminder == null) return;

    _state.updateReminder(reminder);
  }

  void _onReminderDeleted(Event event) {
    final reminder = event.reminder;
    if (reminder == null) return;

    _state.deleteReminder(reminder);
  }

  void _onLocationShared(Event event) {
    final message = event.message;
    if (message == null || message.sharedLocation == null) return;

    return _state.addNewMessage(message);
  }

  Message? _findLocationMessage(String id) {
    final message = _state.messages.firstWhereOrNull((it) {
      return it.sharedLocation?.messageId == id;
    });

    if (message != null) return message;

    return _state.threads.values.flattened.firstWhereOrNull((it) {
      return it.sharedLocation?.messageId == id;
    });
  }

  void _onLocationUpdated(Event event) {
    final location = event.message?.sharedLocation;
    if (location == null) return;

    final messageId = location.messageId;
    if (messageId == null) return;

    final oldMessage = _findLocationMessage(messageId);
    if (oldMessage == null) return;

    final updatedMessage = oldMessage.copyWith(sharedLocation: location);
    return _state.updateMessage(updatedMessage);
  }

  void _onLocationExpired(Event event) {
    final location = event.message?.sharedLocation;
    if (location == null) return;

    final messageId = location.messageId;
    if (messageId == null) return;

    final oldMessage = _findLocationMessage(messageId);
    if (oldMessage == null) return;

    final updatedMessage = oldMessage.copyWith(sharedLocation: location);
    return _state.updateMessage(updatedMessage);
  }

  void _onChannelPushPreferenceUpdated(Event event) {
    final pushPreferences = event.channelPushPreference;
    if (pushPreferences == null) return;

    _state.updateChannelState(
      _state.channelState.copyWith(
        pushPreferences: pushPreferences,
      ),
    );
  }
}
