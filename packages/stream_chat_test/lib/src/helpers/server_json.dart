import 'package:stream_chat/stream_chat.dart';

/// Serializes [event] the way a server sends it over the WebSocket.
///
/// `Event.toJson` produces the client's outgoing shape: nested payloads like
/// [Message] and [Reaction] omit their server-assigned fields (sender,
/// timestamps, reactions, ...), so an event round-tripped through it loses
/// data a real server push always carries. This restores those payloads to
/// their full wire shape; `WebSocketTester.emitEvent` emits every event
/// through it.
Map<String, Object?> serverEventJson(Event event) {
  return {
    ...event.toJson(),
    if (event.channel case final channel?) 'channel': serverChannelJson(channel),
    if (event.message case final message?) 'message': serverMessageJson(message),
    if (event.reaction case final reaction?) 'reaction': serverReactionJson(reaction),
    if (event.poll case final poll?) 'poll': serverPollJson(poll),
    if (event.pollVote case final pollVote?) 'poll_vote': serverPollVoteJson(pollVote),
    if (event.draft case final draft?) 'draft': serverDraftJson(draft),
    if (event.reminder case final reminder?) 'reminder': serverReminderJson(reminder),
  };
}

/// Serializes [channel] the way a server sends it, restoring the
/// server-assigned fields that `ChannelModel.toJson` omits.
Map<String, Object?> serverChannelJson(ChannelModel channel) {
  return {
    ...channel.toJson(),
    'cid': channel.cid,
    if (channel.ownCapabilities case final ownCapabilities?) 'own_capabilities': ownCapabilities,
    'config': channel.config.toJson(),
    if (channel.createdBy case final createdBy?) 'created_by': createdBy.toJson(),
    if (channel.lastMessageAt case final lastMessageAt?) 'last_message_at': lastMessageAt.toIso8601String(),
    'created_at': channel.createdAt.toIso8601String(),
    'updated_at': channel.updatedAt.toIso8601String(),
    if (channel.deletedAt case final deletedAt?) 'deleted_at': deletedAt.toIso8601String(),
    'member_count': channel.memberCount,
    if (channel.members case final members?) 'members': [for (final member in members) member.toJson()],
    if (channel.team case final team?) 'team': team,
    if (channel.messageCount case final messageCount?) 'message_count': messageCount,
    if (channel.filterTags case final filterTags?) 'filter_tags': filterTags,
  };
}

/// Serializes [message] the way a server sends it, restoring the
/// server-assigned fields that `Message.toJson` omits.
Map<String, Object?> serverMessageJson(Message message) {
  return {
    ...message.toJson(),
    // The request shape only carries regular/system types; a server push
    // carries every type.
    'type': message.type,
    if (message.user case final user?) 'user': user.toJson(),
    'created_at': message.createdAt.toIso8601String(),
    'updated_at': message.updatedAt.toIso8601String(),
    if (message.deletedAt case final deletedAt?) 'deleted_at': deletedAt.toIso8601String(),
    'shadowed': message.shadowed,
    if (message.latestReactions case final reactions?)
      'latest_reactions': [for (final reaction in reactions) serverReactionJson(reaction)],
    if (message.ownReactions case final reactions?)
      'own_reactions': [for (final reaction in reactions) serverReactionJson(reaction)],
    if (message.reactionGroups case final groups?)
      'reaction_groups': groups.map((type, group) => MapEntry(type, group.toJson())),
    if (message.replyCount case final replyCount?) 'reply_count': replyCount,
    if (message.threadParticipants case final participants?)
      'thread_participants': [for (final user in participants) user.toJson()],
    if (message.pinnedAt case final pinnedAt?) 'pinned_at': pinnedAt.toIso8601String(),
    if (message.pinnedBy case final pinnedBy?) 'pinned_by': pinnedBy.toJson(),
    if (message.quotedMessage case final quotedMessage?) 'quoted_message': serverMessageJson(quotedMessage),
    if (message.poll case final poll?) 'poll': serverPollJson(poll),
    if (message.draft case final draft?) 'draft': serverDraftJson(draft),
    if (message.reminder case final reminder?) 'reminder': serverReminderJson(reminder),
    if (message.i18n case final i18n?) 'i18n': i18n,
    if (message.moderation case final moderation?) 'moderation': moderation.toJson(),
    if (message.mentionedGroups case final groups?) 'mentioned_groups': [for (final group in groups) group.toJson()],
    // The sender's channel role rides inside the message's `member` object,
    // which is where `Message.fromJson` reads it back from.
    if (message.channelRole case final channelRole?) 'member': {'channel_role': channelRole},
    if (message.messageTextUpdatedAt case final textUpdatedAt?)
      'message_text_updated_at': textUpdatedAt.toIso8601String(),
    if (message.deletedForMe case final deletedForMe?) 'deleted_for_me': deletedForMe,
    if (message.command case final command?) 'command': command,
    if (message.sharedLocation case final location?) 'shared_location': serverLocationJson(location),
  };
}

/// Serializes [draft] the way a server sends it, restoring the nested
/// payloads that `Draft.toJson` serializes through lossy request shapes.
Map<String, Object?> serverDraftJson(Draft draft) {
  return {
    ...draft.toJson(),
    'message': serverDraftMessageJson(draft.message),
    if (draft.channel case final channel?) 'channel': serverChannelJson(channel),
    if (draft.parentMessage case final parentMessage?) 'parent_message': serverMessageJson(parentMessage),
    if (draft.quotedMessage case final quotedMessage?) 'quoted_message': serverMessageJson(quotedMessage),
  };
}

/// Serializes [message] the way a server sends it, restoring the fields
/// that `DraftMessage.toJson` omits or rewrites (command, poll, quoted
/// message, full mentioned users, command-prefixed text).
Map<String, Object?> serverDraftMessageJson(DraftMessage message) {
  return {
    ...message.toJson(),
    if (message.text case final text?) 'text': text,
    'mentioned_users': [for (final user in message.mentionedUsers) user.toJson()],
    if (message.quotedMessage case final quotedMessage?) 'quoted_message': serverMessageJson(quotedMessage),
    if (message.command case final command?) 'command': command,
    if (message.poll case final poll?) 'poll': serverPollJson(poll),
  };
}

/// Serializes [reminder] the way a server sends it, restoring the
/// server-assigned fields that `MessageReminder.toJson` omits.
Map<String, Object?> serverReminderJson(MessageReminder reminder) {
  return {
    ...reminder.toJson(),
    if (reminder.channel case final channel?) 'channel': serverChannelJson(channel),
    if (reminder.message case final message?) 'message': serverMessageJson(message),
    if (reminder.user case final user?) 'user': user.toJson(),
  };
}

/// Serializes [location] the way a server sends it, restoring the
/// server-assigned fields that `Location.toJson` omits.
Map<String, Object?> serverLocationJson(Location location) {
  return {
    ...location.toJson(),
    if (location.channelCid case final channelCid?) 'channel_cid': channelCid,
    if (location.messageId case final messageId?) 'message_id': messageId,
    if (location.userId case final userId?) 'user_id': userId,
    'created_at': location.createdAt.toIso8601String(),
    'updated_at': location.updatedAt.toIso8601String(),
  };
}

/// Serializes [poll] the way a server sends it, restoring the
/// server-assigned fields that `Poll.toJson` omits.
Map<String, Object?> serverPollJson(Poll poll) {
  return {
    ...poll.toJson(),
    'answers_count': poll.answersCount,
    'vote_counts_by_option': poll.voteCountsByOption,
    'latest_votes_by_option': poll.latestVotesByOption.map(
      (optionId, votes) => MapEntry(optionId, [for (final vote in votes) serverPollVoteJson(vote)]),
    ),
    'latest_answers': [for (final answer in poll.latestAnswers) serverPollVoteJson(answer)],
    'own_votes': [for (final vote in poll.ownVotesAndAnswers) serverPollVoteJson(vote)],
    'vote_count': poll.voteCount,
    if (poll.createdById case final createdById?) 'created_by_id': createdById,
    if (poll.createdBy case final createdBy?) 'created_by': createdBy.toJson(),
    'created_at': poll.createdAt.toIso8601String(),
    'updated_at': poll.updatedAt.toIso8601String(),
  };
}

/// Serializes [pollVote] the way a server sends it, restoring the
/// server-assigned fields that `PollVote.toJson` omits.
Map<String, Object?> serverPollVoteJson(PollVote pollVote) {
  return {
    ...pollVote.toJson(),
    if (pollVote.pollId case final pollId?) 'poll_id': pollId,
    if (pollVote.userId case final userId?) 'user_id': userId,
    if (pollVote.user case final user?) 'user': user.toJson(),
    'created_at': pollVote.createdAt.toIso8601String(),
    'updated_at': pollVote.updatedAt.toIso8601String(),
  };
}

/// Serializes [reaction] the way a server sends it, restoring the
/// server-assigned fields that `Reaction.toJson` omits.
Map<String, Object?> serverReactionJson(Reaction reaction) {
  return {
    ...reaction.toJson(),
    if (reaction.messageId case final messageId?) 'message_id': messageId,
    if (reaction.user case final user?) 'user': user.toJson(),
    if (reaction.userId case final userId?) 'user_id': userId,
    'created_at': reaction.createdAt.toIso8601String(),
    'updated_at': reaction.updatedAt.toIso8601String(),
  };
}
