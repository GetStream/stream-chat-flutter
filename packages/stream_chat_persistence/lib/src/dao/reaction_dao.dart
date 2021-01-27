import 'package:moor/moor.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';
import 'package:stream_chat_persistence/src/entity/reactions.dart';
import 'package:stream_chat_persistence/src/entity/users.dart';
import '../mapper/mapper.dart';

part 'reaction_dao.g.dart';

///
@UseDao(tables: [Reactions, Users])
class ReactionDao extends DatabaseAccessor<MoorChatDatabase>
    with _$ReactionDaoMixin {
  ///
  ReactionDao(MoorChatDatabase db) : super(db);

  ///
  Future<List<Reaction>> getReactions(String messageId) {
    return (select(reactions).join([
      leftOuterJoin(users, reactions.userId.equalsExp(users.id)),
    ])
          ..where(reactions.messageId.equals(messageId))
          ..orderBy([OrderingTerm.asc(reactions.createdAt)]))
        .map((rows) {
      final userEntity = rows.readTable(users);
      final reactionEntity = rows.readTable(reactions);
      return reactionEntity.toReaction(user: userEntity?.toUser());
    }).get();
  }

  ///
  Future<List<Reaction>> getReactionsByUserId(
    String messageId,
    String userId,
  ) async {
    final reactions = await getReactions(messageId);
    return reactions.where((it) => it.userId == userId).toList();
  }

  ///
  Future<void> updateReactions(List<Reaction> reactionList) {
    return batch((it) {
      it.insertAll(
        reactions,
        reactionList.map((r) => r.toEntity()).toList(),
        mode: InsertMode.insertOrReplace,
      );
    });
  }
}
