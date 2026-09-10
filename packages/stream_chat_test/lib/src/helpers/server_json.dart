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
    if (event.message case final message?) 'message': serverMessageJson(message),
    if (event.reaction case final reaction?) 'reaction': serverReactionJson(reaction),
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
    if (message.poll case final poll?) 'poll': poll.toJson(),
    if (message.draft case final draft?) 'draft': draft.toJson(),
    if (message.reminder case final reminder?) 'reminder': reminder.toJson(),
    if (message.i18n case final i18n?) 'i18n': i18n,
    if (message.messageTextUpdatedAt case final textUpdatedAt?)
      'message_text_updated_at': textUpdatedAt.toIso8601String(),
    if (message.deletedForMe case final deletedForMe?) 'deleted_for_me': deletedForMe,
    if (message.command case final command?) 'command': command,
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
