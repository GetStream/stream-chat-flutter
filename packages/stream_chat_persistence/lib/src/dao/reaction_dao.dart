import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/reactions.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'reaction_dao.g.dart';

/// The Data Access Object for operations in [Reactions] table.
@DriftAccessor(tables: [Reactions, Users])
class ReactionDao extends DatabaseAccessor<DriftChatDatabase>
    with _$ReactionDaoMixin {
  /// Creates a new reaction dao instance
  ReactionDao(super.db);

  /// Returns all the reactions of a particular message by matching
  /// [Reactions.messageId] with [messageId]
  Future<List<Reaction>> getReactions(String messageId) {
    final where = reactions.messageId.equals(messageId);
    return _selectReactions(where);
  }

  /// Returns all the reactions of a particular message
  /// added by a particular user by matching
  /// [Reactions.messageId] with [messageId] and
  /// [Reactions.userId] with [userId]
  Future<List<Reaction>> getReactionsByUserId(
    String messageId,
    String userId,
  ) {
    final where =
        reactions.messageId.equals(messageId) & reactions.userId.equals(userId);
    return _selectReactions(where);
  }

  /// Updates the reactions data with the new [reactionList] data
  Future<void> updateReactions(List<Reaction> reactionList) => batch((it) {
        it.insertAllOnConflictUpdate(
          reactions,
          reactionList.map((r) => r.toEntity()).toList(),
        );
      });

  /// Deletes all the reactions whose [Reactions.messageId] is
  /// present in [messageIds]
  Future<void> deleteReactionsByMessageIds(List<String> messageIds) =>
      batch((it) {
        it.deleteWhere<Reactions, ReactionEntity>(
          reactions,
          (r) => r.messageId.isIn(messageIds),
        );
      });

  Future<List<Reaction>> _selectReactions(Expression<bool> where) {
    final rows = select(reactions)
        .join([leftOuterJoin(users, reactions.userId.equalsExp(users.id))])
      ..where(where)
      ..orderBy([OrderingTerm.asc(reactions.createdAt)]);
    return rows.map((row) {
      final reactionEntity = row.readTable(reactions);
      final userEntity = row.readTableOrNull(users);
      return reactionEntity.toReaction(user: userEntity?.toUser());
    }).get();
  }
}
