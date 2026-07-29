import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/db/query_utils.dart';
import 'package:stream_chat_persistence/src/entity/reactions.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'reaction_dao.g.dart';

/// The Data Access Object for operations in [Reactions] table.
@DriftAccessor(tables: [Reactions, Users])
class ReactionDao extends DatabaseAccessor<DriftChatDatabase> with _$ReactionDaoMixin {
  /// Creates a new reaction dao instance
  ReactionDao(super.db);

  /// Returns reactions for every id in [messageIds], grouped by message id.
  Future<Map<String, List<Reaction>>> getReactionsForMessages(
    List<String> messageIds,
  ) async {
    if (messageIds.isEmpty) return const {};
    final grouped = <String, List<Reaction>>{
      for (final id in messageIds) id: <Reaction>[],
    };
    for (final chunk in chunked(messageIds)) {
      final where = reactions.messageId.isIn(chunk);
      final rows = await _selectReactions(where);
      for (final r in rows) {
        grouped[r.messageId]!.add(r);
      }
    }
    return grouped;
  }

  /// Returns reactions for every id in [messageIds] that were added by
  /// [userId], grouped by message id.
  Future<Map<String, List<Reaction>>> getReactionsForMessagesByUserId(
    List<String> messageIds,
    String userId,
  ) async {
    if (messageIds.isEmpty) return const {};
    final grouped = <String, List<Reaction>>{
      for (final id in messageIds) id: <Reaction>[],
    };
    for (final chunk in chunked(messageIds)) {
      final where = reactions.messageId.isIn(chunk) & reactions.userId.equals(userId);
      final rows = await _selectReactions(where);
      for (final r in rows) {
        grouped[r.messageId]!.add(r);
      }
    }
    return grouped;
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
  Future<void> deleteReactionsByMessageIds(List<String> messageIds) => batch((it) {
    it.deleteWhere<Reactions, ReactionEntity>(
      reactions,
      (r) => r.messageId.isIn(messageIds),
    );
  });

  Future<List<Reaction>> _selectReactions(Expression<bool> where) {
    final rows = select(reactions).join([leftOuterJoin(users, reactions.userId.equalsExp(users.id))])
      ..where(where)
      ..orderBy([OrderingTerm.asc(reactions.createdAt)]);
    return rows.map((row) {
      final reactionEntity = row.readTable(reactions);
      final userEntity = row.readTableOrNull(users);
      return reactionEntity.toReaction(user: userEntity?.toUser());
    }).get();
  }
}
