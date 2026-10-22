import '../../../open_api/api.dart' as api;
import '../../core/models/reaction.dart';
import '../../core/models/reaction_group.dart';
import '../../core/util/extension.dart';
import 'users_mapper.dart';

// TODO(openapi-migration): re-point these mappers in group 10.

/// Maps a generated [api.ReactionResponse] to a [Reaction].
extension ReactionResponseMapper on api.ReactionResponse {
  /// Converts this response into a [Reaction].
  ///
  /// [Reaction.emojiCode] is read from [custom], and [Reaction.custom] still
  /// holds it.
  Reaction toModel() => Reaction(
    messageId: messageId,
    type: type,
    user: user.toModel(),
    userId: userId,
    score: score,
    emojiCode: custom['emoji_code'].safeCast<String>(),
    createdAt: createdAt,
    updatedAt: updatedAt,
    custom: custom,
  );
}

/// Maps a generated [api.ReactionGroupResponse] to a [ReactionGroup].
extension ReactionGroupResponseMapper on api.ReactionGroupResponse {
  /// Converts this response into a [ReactionGroup].
  ReactionGroup toModel() => ReactionGroup(
    count: count,
    sumScores: sumScores,
    firstReactionAt: firstReactionAt,
    lastReactionAt: lastReactionAt,
  );
}
