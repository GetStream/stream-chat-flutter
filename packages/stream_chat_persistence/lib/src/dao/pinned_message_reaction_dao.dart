import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/pinned_message_reactions.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import 'package:stream_chat_persistence/src/mapper/mapper.dart';

part 'pinned_message_reaction_dao.g.dart';

/// The Data Access Object for operations in [PinnedMessageReactions] table.
@UseDao(tables: [PinnedMessageReactions, Users])
class PinnedMessageReactionDao extends DatabaseAccessor<MoorChatDatabase>
    with _$PinnedMessageReactionDaoMixin {
  /// Creates a new reaction dao instance
  PinnedMessageReactionDao(MoorChatDatabase db) : super(db);

  /// Returns all the reactions of a particular message by matching
  /// [Reactions.messageId] with [messageId]
  Future<List<Reaction>> getReactions(String messageId) =>
      (select(pinnedMessageReactions).join([
        leftOuterJoin(users, pinnedMessageReactions.userId.equalsExp(users.id)),
      ])
            ..where(pinnedMessageReactions.messageId.equals(messageId))
            ..orderBy([OrderingTerm.asc(pinnedMessageReactions.createdAt)]))
          .map((rows) {
        final userEntity = rows.readTableOrNull(users);
        final reactionEntity = rows.readTable(pinnedMessageReactions);
        return reactionEntity.toReaction(user: userEntity?.toUser());
      }).get();

  /// Returns all the reactions of a particular message
  /// added by a particular user by matching
  /// [Reactions.messageId] with [messageId] and
  /// [Reactions.userId] with [userId]
  Future<List<Reaction>> getReactionsByUserId(
    String messageId,
    String userId,
  ) async {
    final reactions = await getReactions(messageId);
    return reactions.where((it) => it.userId == userId).toList();
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
}
