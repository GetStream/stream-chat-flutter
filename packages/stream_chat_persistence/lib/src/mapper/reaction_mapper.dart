import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

///
extension ReactionEntityX on ReactionEntity {
  ///
  Reaction toReaction({User user}) {
    return Reaction(
      extraData: extraData,
      type: type,
      createdAt: createdAt,
      userId: userId,
      user: user,
      messageId: messageId,
      score: score,
    );
  }
}

///
extension ReactionX on Reaction {
  ///
  ReactionEntity toEntity() {
    return ReactionEntity(
      extraData: extraData,
      type: type,
      createdAt: createdAt,
      userId: userId,
      messageId: messageId,
      score: score,
    );
  }
}
