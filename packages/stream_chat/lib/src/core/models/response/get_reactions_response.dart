import 'package:freezed_annotation/freezed_annotation.dart';

import '../reaction.dart';

part 'get_reactions_response.freezed.dart';

/// One page of the reactions on a message.
///
/// See also:
///
///  * [StreamChatClient.getReactions] and [Channel.getReactions], which return
///    it.
@freezed
class GetReactionsResponse with _$GetReactionsResponse {
  /// Creates a new [GetReactionsResponse].
  const GetReactionsResponse({
    required this.duration,
    required this.reactions,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The reactions on this page.
  @override
  final List<Reaction> reactions;
}
