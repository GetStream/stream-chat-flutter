import 'package:freezed_annotation/freezed_annotation.dart';

import '../message.dart';
import '../reaction.dart';

part 'send_reaction_response.freezed.dart';

/// The result of sending a reaction to a message, returned by
/// [StreamChatClient.sendReaction] and [Channel.sendReaction].
@freezed
class SendReactionResponse with _$SendReactionResponse {
  /// Creates a new [SendReactionResponse].
  const SendReactionResponse({
    required this.duration,
    required this.message,
    required this.reaction,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The message the reaction was sent to, including the reaction.
  @override
  final Message message;

  /// The reaction that was sent.
  @override
  final Reaction reaction;
}
