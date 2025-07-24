import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/src/db/drift_chat_database.dart';

/// Useful mapping functions for [ReactionEntity]
extension ReactionEntityX on ReactionEntity {
  /// Maps a [ReactionEntity] into [Reaction]
  Reaction toReaction({User? user}) => Reaction(
        type: type,
        userId: userId,
        user: user,
        messageId: messageId,
        score: score,
        emojiCode: emojiCode,
        createdAt: createdAt,
        updatedAt: updatedAt,
        extraData: extraData ?? <String, Object>{},
      );
}

/// Useful mapping functions for [Reaction]
extension ReactionX on Reaction {
  /// Maps a [Reaction] into [ReactionEntity]
  ReactionEntity toEntity() => ReactionEntity(
        type: type,
        userId: userId ?? user?.id,
        messageId: messageId,
        score: score,
        emojiCode: emojiCode,
        createdAt: createdAt,
        updatedAt: updatedAt,
        extraData: extraData,
      );
}
