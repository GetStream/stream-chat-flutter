import 'package:freezed_annotation/freezed_annotation.dart';

import '../reaction.dart';

part 'query_reactions_response.freezed.dart';

/// One page of the reactions on a message matching a query, returned by
/// [StreamChatClient.queryReactions].
@freezed
class QueryReactionsResponse with _$QueryReactionsResponse {
  /// Creates a new [QueryReactionsResponse].
  const QueryReactionsResponse({
    required this.duration,
    required this.reactions,
    this.next,
    this.prev,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The reactions on this page.
  @override
  final List<Reaction> reactions;

  /// The cursor for the next page, or null on the last page.
  @override
  final String? next;

  /// The cursor for the previous page, or null on the first page.
  @override
  final String? prev;
}
