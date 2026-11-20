import 'package:freezed_annotation/freezed_annotation.dart';

import '../poll_vote.dart';

part 'poll_vote_response.freezed.dart';

/// The result of casting or removing a vote or an answer on a poll.
@freezed
class PollVoteResponse with _$PollVoteResponse {
  /// Creates a new [PollVoteResponse].
  const PollVoteResponse({
    required this.duration,
    this.vote,
  });

  /// How long the request took to handle, such as `4.21ms`.
  @override
  final String duration;

  /// The vote that was cast or removed.
  @override
  final PollVote? vote;
}
