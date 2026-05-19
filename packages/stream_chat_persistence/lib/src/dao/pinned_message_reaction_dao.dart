import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/pinned_message_reactions.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'pinned_message_reaction_dao.g.dart';

/// The Data Access Object for operations in [PinnedMessageReactions] table.
@DriftAccessor(tables: [PinnedMessageReactions, Users])
class PinnedMessageReactionDao extends DatabaseAccessor<DriftChatDatabase>
    with _$PinnedMessageReactionDaoMixin {
  /// Creates a new reaction dao instance
  PinnedMessageReactionDao(super.db);

  /// Returns all the reactions of a particular message by matching
  /// [Reactions.messageId] with [messageId]
  Future<List<Reaction>> getReactions(String messageId) {
    final where = pinnedMessageReactions.messageId.equals(messageId);
    return _selectReactions(where);
  }

  /// Returns all the reactions of a particular message
  /// added by a particular user by matching
  /// [Reactions.messageId] with [messageId] and
  /// [Reactions.userId] with [userId]
  Future<List<Reaction>> getReactionsByUserId(
    String messageId,
    String userId,) {
    final where = pinnedMessageReactions.messageId.equals(
        messageId) & pinnedMessageReactions.userId.equals(userId);
    return _selectReactions(where);
  }

  /// Updates the reactions data with the new [reactionList] data
  Future<void> updateReactions(List<Reaction> reactionList) => batch((it) {
        it.insertAllOnConflictUpdate(
          pinnedMessageReactions,
          reactionList.map((r) => r.toPinnedEntity()).toList(),
        );
      });

  /// Deletes all the reactions whose [Reactions.messageId] is
  /// present in [messageIds]
  Future<void> deleteReactionsByMessageIds(List<String> messageIds) =>
      batch((it) {
        it.deleteWhere<PinnedMessageReactions, PinnedMessageReactionEntity>(
          pinnedMessageReactions,
          (r) => r.messageId.isIn(messageIds),
        );
      });

  Future<List<Reaction>> _selectReactions(Expression<bool> where) {
    final rows = select(pinnedMessageReactions).join([
      leftOuterJoin(users, pinnedMessageReactions.userId.equalsExp(users.id)),
    ])
      ..where(where)
      ..orderBy([OrderingTerm.asc(pinnedMessageReactions.createdAt)]);
    return rows.map((row) {
      final reactionEntity = row.readTable(pinnedMessageReactions);
      final userEntity = row.readTableOrNull(users);
      return reactionEntity.toReaction(user: userEntity?.toUser());
    }).get();
  }
}
