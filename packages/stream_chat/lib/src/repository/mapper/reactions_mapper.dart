import '../../../open_api/api.dart' as api;
import '../../core/models/reaction.dart';
import '../../core/models/reaction_group.dart';
import '../../core/models/response/delete_reaction_response.dart';
import '../../core/models/response/get_reactions_response.dart';
import '../../core/models/response/query_reactions_response.dart';
import '../../core/models/response/send_reaction_response.dart';
import '../../core/util/extension.dart';
import 'messages_mapper.dart';
import 'users_mapper.dart';

/// Maps a generated [api.SendReactionResponse] to a [SendReactionResponse].
extension SendReactionResponseMapper on api.SendReactionResponse {
  /// Converts this response into a [SendReactionResponse].
  SendReactionResponse toModel() => SendReactionResponse(
    duration: duration,
    message: message.toModel(),
    reaction: reaction.toModel(),
  );
}

/// Maps a generated [api.DeleteReactionResponse] to a [DeleteReactionResponse].
extension DeleteReactionResponseMapper on api.DeleteReactionResponse {
  /// Converts this response into a [DeleteReactionResponse].
  DeleteReactionResponse toModel() => DeleteReactionResponse(
    duration: duration,
    message: message.toModel(),
    reaction: reaction.toModel(),
  );
}

/// Maps a generated [api.GetReactionsResponse] to a [GetReactionsResponse].
extension GetReactionsResponseMapper on api.GetReactionsResponse {
  /// Converts this response into a [GetReactionsResponse].
  GetReactionsResponse toModel() => GetReactionsResponse(
    duration: duration,
    reactions: [for (final reaction in reactions) reaction.toModel()],
  );
}

/// Maps a generated [api.QueryReactionsResponse] to a [QueryReactionsResponse].
extension QueryReactionsResponseMapper on api.QueryReactionsResponse {
  /// Converts this response into a [QueryReactionsResponse].
  QueryReactionsResponse toModel() => QueryReactionsResponse(
    duration: duration,
    reactions: [for (final reaction in reactions) reaction.toModel()],
    next: next,
    prev: prev,
  );
}

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

/// Maps a [Reaction] to the generated [api.ReactionRequest] that sends it.
extension ReactionRequestMapper on Reaction {
  /// Converts this reaction into the request that sends it.
  ///
  /// The [emojiCode] takes precedence over a custom entry it would clash with.
  /// The dates are left out.
  api.ReactionRequest toRequest() => api.ReactionRequest(
    type: type,
    score: score,
    custom: {
      ...custom,
      if (emojiCode case final emojiCode?) 'emoji_code': emojiCode,
    },
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
