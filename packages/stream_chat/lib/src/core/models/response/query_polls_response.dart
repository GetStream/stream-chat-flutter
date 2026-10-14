import 'package:freezed_annotation/freezed_annotation.dart';

import '../poll.dart';

part 'query_polls_response.freezed.dart';

/// One page of the polls matching a query.
@freezed
class QueryPollsResponse with _$QueryPollsResponse {
  /// Creates a new [QueryPollsResponse].
  const QueryPollsResponse({
    required this.duration,
    required this.polls,
    this.next,
    this.prev,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The polls on this page.
  @override
  final List<Poll> polls;

  /// The cursor for the next page, or null on the last page.
  @override
  final String? next;

  /// The cursor for the previous page, or null on the first page.
  @override
  final String? prev;
}
