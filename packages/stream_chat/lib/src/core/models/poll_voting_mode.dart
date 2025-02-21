import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_chat/src/core/models/poll.dart';

part 'poll_voting_mode.freezed.dart';

/// {@template pollVotingMode}
/// The Voting mode for a poll.
///
/// Determines how many unique options can be voted by a user in a poll.
///
/// - [VotingDisabled] means that voting is disabled and the user can't vote.
/// - [VotingUnique] means that the user can vote for only one unique option.
/// - [VotingLimited] means that the user can vote for a limited number of
///   unique options specified by [count].
/// - [VotingAll] means that the user can vote for all the available unique
///   options.
///
/// Note: [VotingLimited] with [count] equal to the number of available options
/// in a poll is equivalent to [VotingAll].
/// {@endtemplate}
@freezed
sealed class PollVotingMode with _$PollVotingMode {
  const factory PollVotingMode.disabled() = VotingDisabled;
  const factory PollVotingMode.unique() = VotingUnique;
  const factory PollVotingMode.limited({required int count}) = VotingLimited;
  const factory PollVotingMode.all() = VotingAll;
}

/// A mixin on [Poll] to determine the voting mode.
extension PollVotingModeX on Poll {
  /// Returns the voting mode based on the poll configuration.
  PollVotingMode get votingMode {
    if (isClosed) return const VotingDisabled();
    if (enforceUniqueVote) return const VotingUnique();
    if (maxVotesAllowed case final maxAllowed? when maxAllowed > 0) {
      if (maxAllowed >= options.length) return const VotingAll();
      return VotingLimited(count: maxAllowed);
    }

    return const VotingAll();
  }
}
