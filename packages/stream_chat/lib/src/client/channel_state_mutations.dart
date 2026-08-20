import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:stream_chat/stream_chat.dart';

/// Applies channel event payloads as [ChannelClientState] mutations.
///
/// Owns the state writes for the events dispatched by the channel event
/// handler: each method computes the new state from the current one and the
/// given payload.
class ChannelStateMutations {
  /// Creates mutations writing to the given [_state] of the given [_channel].
  ///
  /// The write callbacks perform the state mutations that
  /// [ChannelClientState] does not expose publicly.
  const ChannelStateMutations({
    required this._channel,
    required this._state,
    required this._upsertTypingEvent,
    required this._removeTypingEvent,
    required this._removeWatcher,
    required this._updateMember,
    required this._deleteMessagesFromUser,
  });

  final Channel _channel;
  final ChannelClientState _state;

  final void Function(User user, Event event) _upsertTypingEvent;
  final void Function(User user) _removeTypingEvent;
  final void Function(User watcher, {int? watcherCount}) _removeWatcher;
  final void Function(Member member) _updateMember;
  final Future<void> Function({
    required String userId,
    bool hardDelete,
    DateTime? deletedAt,
  })
  _deleteMessagesFromUser;

  StreamChatClient get _client => _channel.client;

  /// Records the typing [event] for the given [user].
  void onTypingStart(User user, Event event) => _upsertTypingEvent(user, event);

  /// Clears the typing state for the given [user].
  void onTypingStop(User user) => _removeTypingEvent(user);

  /// Adds the new [message], updating the watcher count when provided.
  void onMessageNew(Message message, {int? watcherCount}) {
    _state.addNewMessage(message);

    if (watcherCount != null) {
      _state.updateChannelState(
        _state.channelState.copyWith(watcherCount: watcherCount),
      );
    }
  }

  /// Marks the [message] as deleted.
  void onMessageDeleted(Message message, {bool hardDelete = false}) {
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

  /// Applies the updated [message] without inserting it when absent.
  void onMessageUpdated(Message message) {
    return _state.updateMessage(message, upsert: false);
  }

  /// Applies the updated [draft].
  void onDraftUpdated(Draft draft) => _state.updateDraft(draft);

  /// Removes the deleted [draft].
  void onDraftDeleted(Draft draft) => _state.deleteDraft(draft);

  /// Applies the [eventMessage] carrying the new [eventReaction], preserving
  /// the current user's own reactions.
  void onReactionNew(Message eventMessage, Reaction eventReaction) {
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

  /// Applies the [eventMessage] carrying the updated [eventReaction],
  /// preserving the current user's own reactions.
  void onReactionUpdated(Message eventMessage, Reaction eventReaction) {
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

  /// Applies the [eventMessage] carrying the deleted [eventReaction],
  /// preserving the current user's own reactions.
  void onReactionDeleted(Message eventMessage, Reaction eventReaction) {
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

  /// Adds the [message] carrying a newly created poll.
  void onPollCreated(Message message) => _state.addNewMessage(message);

  /// Applies the updated [eventPoll] to the message carrying it, preserving
  /// the known answers and own votes.
  void onPollUpdated(Poll eventPoll) {
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

  /// Marks the poll matching [eventPoll] as closed.
  void onPollClosed(Poll eventPoll) {
    final pollMessage = _findPollMessage(eventPoll.id);
    if (pollMessage == null) return;

    final oldPoll = pollMessage.poll;
    final poll = oldPoll?.copyWith(isClosed: true) ?? eventPoll;

    final message = pollMessage.copyWith(poll: poll);
    _state.updateMessage(message);
  }

  /// Applies the casted answer [eventPollVote] to the poll matching
  /// [eventPoll].
  void onPollAnswerCasted(Poll eventPoll, PollVote eventPollVote) {
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

  /// Applies the casted [eventPollVote] to the poll matching [eventPoll].
  void onPollVoteCasted(Poll eventPoll, PollVote eventPollVote) {
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

  /// Applies the changed [eventPollVote] to the poll matching [eventPoll].
  void onPollVoteChanged(Poll eventPoll, PollVote eventPollVote) {
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

  /// Removes the answer [eventPollVote] from the poll matching [eventPoll].
  void onPollAnswerRemoved(Poll eventPoll, PollVote eventPollVote) {
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

  /// Removes the [eventPollVote] from the poll matching [eventPoll].
  void onPollVoteRemoved(Poll eventPoll, PollVote eventPollVote) {
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

  /// Applies a read for the [user], resetting its unread count and
  /// preserving its delivery info.
  void onMessageRead(
    User user, {
    required DateTime lastRead,
    String? lastReadMessageId,
  }) {
    final currentRead = _state.userReadOf(userId: user.id);

    final updatedRead = Read(
      user: user,
      lastRead: lastRead,
      unreadMessages: 0, // Reset unread count
      lastReadMessageId: lastReadMessageId,
      // Preserve delivery info as it's not part of the read event.
      lastDeliveredAt: currentRead?.lastDeliveredAt,
      lastDeliveredMessageId: currentRead?.lastDeliveredMessageId,
    );

    _state.updateRead([updatedRead]);
  }

  /// Applies an unread mark for the [user], preserving its delivery info.
  void onNotificationMarkUnread(
    User user, {
    required DateTime lastRead,
    int? unreadMessages,
    String? lastReadMessageId,
  }) {
    final currentRead = _state.userReadOf(userId: user.id);

    final updatedRead = Read(
      user: user,
      lastRead: lastRead,
      unreadMessages: unreadMessages,
      lastReadMessageId: lastReadMessageId,
      // Preserve delivery info as it's not part of the read event.
      lastDeliveredAt: currentRead?.lastDeliveredAt,
      lastDeliveredMessageId: currentRead?.lastDeliveredMessageId,
    );

    return _state.updateRead([updatedRead]);
  }

  /// Applies a delivery for the [user], preserving its read info.
  void onMessageDelivered(
    User user, {
    DateTime? lastDeliveredAt,
    String? lastDeliveredMessageId,
  }) {
    final currentRead = _state.userReadOf(userId: user.id);
    final never = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

    final updatedRead = Read(
      user: user,
      lastDeliveredAt: lastDeliveredAt,
      lastDeliveredMessageId: lastDeliveredMessageId,
      // Preserve read info as it's not part of the delivery event.
      lastRead: currentRead?.lastRead ?? never,
      unreadMessages: currentRead?.unreadMessages,
      lastReadMessageId: currentRead?.lastReadMessageId,
    );

    _state.updateRead([updatedRead]);
  }

  /// Clears the channel messages, applying the truncation system [message]
  /// when provided.
  void onChannelTruncated({Message? message}) {
    _state.truncate();
    if (message != null) {
      _state.updateMessage(message);
    }
  }

  /// Merges the updated [channel] model and replaces the member list.
  void onChannelUpdated(ChannelModel channel) {
    _state.updateChannelState(
      _state.channelState.copyWith(
        channel: _state.channelState.channel?.merge(channel),
        members: channel.members,
      ),
    );
  }

  /// Updates the channel [messageCount].
  void onChannelMessageCount(int messageCount) {
    _state.updateChannelState(
      _state.channelState.copyWith(
        channel: _state.channelState.channel?.copyWith(
          messageCount: messageCount,
        ),
      ),
    );
  }

  /// Appends the added [member] to the member list.
  void onMemberAdded(Member member) {
    final existingMembers = _state.channelState.members ?? [];

    _state.updateChannelState(
      _state.channelState.copyWith(
        members: [...existingMembers, member],
      ),
    );
  }

  /// Removes the [user]'s membership and read state.
  void onMemberRemoved(User user) {
    final existingRead = _state.channelState.read ?? [];
    final existingMembers = _state.channelState.members ?? [];

    _state.updateChannelState(
      _state.channelState.copyWith(
        read: [...existingRead.where((r) => r.user.id != user.id)],
        members: [...existingMembers.where((m) => m.userId != user.id)],
      ),
    );
  }

  /// Merges the updated [user] into the matching member and membership.
  ///
  /// Does nothing if the user is not an existing member of the channel.
  void onMemberUserUpdated(User user) {
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

  /// Replaces the matching [member] and membership.
  void onMemberUpdated(Member member) {
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

  /// Replaces the [member] refreshed after a ban.
  void onMemberBanned(Member member) => _updateMember(member);

  /// Replaces the [member] refreshed after an unban.
  void onMemberUnbanned(Member member) => _updateMember(member);

  /// Marks all messages from the user identified by [userId] as deleted.
  Future<void> onUserMessagesDeleted({
    required String userId,
    bool hardDelete = false,
    DateTime? deletedAt,
  }) {
    return _deleteMessagesFromUser(
      userId: userId,
      hardDelete: hardDelete,
      deletedAt: deletedAt,
    );
  }

  /// Adds the [watcher], updating the watcher count when provided.
  void onUserStartWatching(User watcher, {int? watcherCount}) {
    final existingWatchers = _state.channelState.watchers;

    _state.updateChannelState(
      _state.channelState.copyWith(
        watchers: [
          watcher,
          ...?existingWatchers?.where((user) => user.id != watcher.id),
        ],
        watcherCount: watcherCount,
      ),
    );
  }

  /// Removes the [watcher], updating the watcher count when provided.
  void onUserStopWatching(User watcher, {int? watcherCount}) {
    return _removeWatcher(watcher, watcherCount: watcherCount);
  }

  /// Applies the created [reminder].
  void onReminderCreated(MessageReminder reminder) => _state.updateReminder(reminder);

  /// Applies the updated [reminder].
  void onReminderUpdated(MessageReminder reminder) => _state.updateReminder(reminder);

  /// Removes the deleted [reminder].
  void onReminderDeleted(MessageReminder reminder) => _state.deleteReminder(reminder);

  Message? _findLocationMessage(String id) {
    final message = _state.messages.firstWhereOrNull((it) {
      return it.sharedLocation?.messageId == id;
    });

    if (message != null) return message;

    return _state.threads.values.flattened.firstWhereOrNull((it) {
      return it.sharedLocation?.messageId == id;
    });
  }

  /// Adds the [message] sharing a live location.
  void onLocationShared(Message message) => _state.addNewMessage(message);

  /// Applies the updated [location] to the message sharing it.
  void onLocationUpdated(Location location) {
    final messageId = location.messageId;
    if (messageId == null) return;

    final oldMessage = _findLocationMessage(messageId);
    if (oldMessage == null) return;

    final updatedMessage = oldMessage.copyWith(sharedLocation: location);
    return _state.updateMessage(updatedMessage);
  }

  /// Applies the expired [location] to the message sharing it.
  void onLocationExpired(Location location) {
    final messageId = location.messageId;
    if (messageId == null) return;

    final oldMessage = _findLocationMessage(messageId);
    if (oldMessage == null) return;

    final updatedMessage = oldMessage.copyWith(sharedLocation: location);
    return _state.updateMessage(updatedMessage);
  }

  /// Applies the updated channel [pushPreferences].
  void onChannelPushPreferenceUpdated(ChannelPushPreference pushPreferences) {
    _state.updateChannelState(
      _state.channelState.copyWith(
        pushPreferences: pushPreferences,
      ),
    );
  }
}
