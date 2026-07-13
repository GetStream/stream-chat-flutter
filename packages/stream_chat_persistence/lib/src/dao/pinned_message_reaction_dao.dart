import 'package:drift/drift.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';
import 'package:stream_chat_persistence/src/db/query_utils.dart';
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

  /// Returns pinned-message reactions for every id in [messageIds], grouped
  /// by message id.
  Future<Map<String, List<Reaction>>> getReactionsForMessages(
    List<String> messageIds,
  ) async {
    if (messageIds.isEmpty) return const {};
    final grouped = <String, List<Reaction>>{
      for (final id in messageIds) id: <Reaction>[],
    };
    for (final chunk in chunked(messageIds)) {
      final where = pinnedMessageReactions.messageId.isIn(chunk);
      final rows = await _selectReactions(where);
      for (final r in rows) {
        grouped[r.messageId]!.add(r);
      }
    }
    return grouped;
  }

  /// Returns pinned-message reactions for every id in [messageIds] that were
  /// added by [userId], grouped by message id.
  Future<Map<String, List<Reaction>>> getReactionsForMessagesByUserId(
    List<String> messageIds,
    String userId,
  ) async {
    if (messageIds.isEmpty) return const {};
    final grouped = <String, List<Reaction>>{
      for (final id in messageIds) id: <Reaction>[],
    };
    for (final chunk in chunked(messageIds)) {
      final where = pinnedMessageReactions.messageId.isIn(chunk) &
          pinnedMessageReactions.userId.equals(userId);
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
