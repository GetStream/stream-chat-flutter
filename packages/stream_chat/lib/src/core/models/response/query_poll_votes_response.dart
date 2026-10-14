import 'package:freezed_annotation/freezed_annotation.dart';

import '../poll_vote.dart';

part 'query_poll_votes_response.freezed.dart';

/// One page of the votes and answers of a poll matching a query.
@freezed
class QueryPollVotesResponse with _$QueryPollVotesResponse {
  /// Creates a new [QueryPollVotesResponse].
  const QueryPollVotesResponse({
    required this.duration,
    required this.votes,
    this.next,
    this.prev,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The votes and answers on this page.
  @override
  final List<PollVote> votes;

  /// The cursor for the next page, or null on the last page.
  @override
  final String? next;

  /// The cursor for the previous page, or null on the first page.
  @override
  final String? prev;
}
