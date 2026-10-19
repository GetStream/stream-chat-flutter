import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';
import '../reaction.dart';

part 'delete_reaction_response.freezed.dart';

/// The result of removing a reaction from a message, returned by
/// [StreamChatClient.deleteReaction] and [Channel.deleteReaction].
@freezed
class DeleteReactionResponse with _$DeleteReactionResponse {
  /// Creates a new [DeleteReactionResponse].
  const DeleteReactionResponse({
    required this.duration,
    required this.message,
    required this.reaction,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The message the reaction was removed from, no longer including it.
  @override
  final Message message;

  /// The reaction that was removed.
  @override
  final Reaction reaction;
}
