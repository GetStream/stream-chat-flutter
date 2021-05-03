import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/moor_chat_database.dart';

/// Useful mapping functions for [ReactionEntity]
extension ReactionEntityX on ReactionEntity {
  /// Maps a [ReactionEntity] into [Reaction]
  Reaction toReaction({User? user}) => Reaction(
        extraData: extraData,
        type: type,
        createdAt: createdAt,
        userId: userId,
        user: user,
        messageId: messageId,
        score: score,
      );
}

/// Useful mapping functions for [Reaction]
extension ReactionX on Reaction {
  /// Maps a [Reaction] into [ReactionEntity]
  ReactionEntity toEntity() => ReactionEntity(
        extraData: extraData,
        type: type,
        createdAt: createdAt,
        userId: userId!,
        messageId: messageId!,
        score: score,
      );
}
