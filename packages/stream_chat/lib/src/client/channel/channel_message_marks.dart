import 'package:collection/collection.dart';

import '../../../stream_chat.dart';

// The most markers a mark group lists.
const _latestByLimit = 100;

/// Adds [mark] to the message it marks in [state].
///
/// The message is looked up among the channel messages and, if [parentId] is
/// given, that thread's replies.
/// A mark by another user joins [Message.markGroups] on a message by
/// [currentUserId]. A mark by [currentUserId] joins [Message.ownMarks] on
/// another user's message. Any other mark, a marker already listed for that
/// type, or a message [state] does not hold leaves [state] unchanged.
void addMessageMark(
  ChannelClientState state,
  MessageMark mark, {
  required String currentUserId,
  String? parentId,
}) {
  final messages = [...state.messages, ...?state.threads[parentId]];
  final message = messages.firstWhereOrNull((it) => it.id == mark.messageId);
  if (message == null) return;

  final updated = _withMark(message, mark, currentUserId: currentUserId);
  if (updated == null) return;

  return state.updateMessage(updated, upsert: false);
}

// Returns [message] with [mark] added, or null when [mark] changes nothing.
Message? _withMark(
  Message message,
  MessageMark mark, {
  required String currentUserId,
}) {
  final authorId = message.user?.id;
  if (authorId == null || mark.userId == authorId) return null;

  if (authorId == currentUserId) {
    final group = message.markGroups?[mark.type] ?? const MarkGroup();
    if (group.latestBy.any((it) => it.userId == mark.userId)) return null;

    final marker = MessageMarker(
      userId: mark.userId,
      createdAt: mark.createdAt,
    );
    final latestBy = [marker, ...group.latestBy].take(_latestByLimit);
    final updatedGroup = group.copyWith(
      count: group.count + 1,
      latestBy: latestBy.toList(),
    );

    return message.copyWith(
      markGroups: {...?message.markGroups, mark.type: updatedGroup},
    );
  }

  if (mark.userId != currentUserId) return null;

  final ownMarks = message.ownMarks ?? const [];
  if (ownMarks.any((it) => it.type == mark.type)) return null;

  final ownMark = OwnMark(type: mark.type, createdAt: mark.createdAt);
  return message.copyWith(ownMarks: [...ownMarks, ownMark]);
}
