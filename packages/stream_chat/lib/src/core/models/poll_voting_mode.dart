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

// coverage:ignore-start

/// @nodoc
extension PollVotingModePatternMatching on PollVotingMode {
  /// @nodoc
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() disabled,
    required TResult Function() unique,
    required TResult Function(int count) limited,
    required TResult Function() all,
  }) {
    final votingMode = this;
    return switch (votingMode) {
      VotingDisabled() => disabled(),
      VotingUnique() => unique(),
      VotingLimited() => limited(votingMode.count),
      VotingAll() => all(),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? disabled,
    TResult? Function()? unique,
    TResult? Function(int count)? limited,
    TResult? Function()? all,
  }) {
    final votingMode = this;
    return switch (votingMode) {
      VotingDisabled() => disabled?.call(),
      VotingUnique() => unique?.call(),
      VotingLimited() => limited?.call(votingMode.count),
      VotingAll() => all?.call(),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? disabled,
    TResult Function()? unique,
    TResult Function(int count)? limited,
    TResult Function()? all,
    required TResult orElse(),
  }) {
    final votingMode = this;
    final result = switch (votingMode) {
      VotingDisabled() => disabled?.call(),
      VotingUnique() => unique?.call(),
      VotingLimited() => limited?.call(votingMode.count),
      VotingAll() => all?.call(),
    };

    return result ?? orElse();
  }

  /// @nodoc
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(VotingDisabled value) disabled,
    required TResult Function(VotingUnique value) unique,
    required TResult Function(VotingLimited value) limited,
    required TResult Function(VotingAll value) all,
  }) {
    final votingMode = this;
    return switch (votingMode) {
      VotingDisabled() => disabled(votingMode),
      VotingUnique() => unique(votingMode),
      VotingLimited() => limited(votingMode),
      VotingAll() => all(votingMode),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(VotingDisabled value)? disabled,
    TResult? Function(VotingUnique value)? unique,
    TResult? Function(VotingLimited value)? limited,
    TResult? Function(VotingAll value)? all,
  }) {
    final votingMode = this;
    return switch (votingMode) {
      VotingDisabled() => disabled?.call(votingMode),
      VotingUnique() => unique?.call(votingMode),
      VotingLimited() => limited?.call(votingMode),
      VotingAll() => all?.call(votingMode),
    };
  }

  /// @nodoc
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(VotingDisabled value)? disabled,
    TResult Function(VotingUnique value)? unique,
    TResult Function(VotingLimited value)? limited,
    TResult Function(VotingAll value)? all,
    required TResult orElse(),
  }) {
    final votingMode = this;
    final result = switch (votingMode) {
      VotingDisabled() => disabled?.call(votingMode),
      VotingUnique() => unique?.call(votingMode),
      VotingLimited() => limited?.call(votingMode),
      VotingAll() => all?.call(votingMode),
    };

    return result ?? orElse();
  }
}

// coverage:ignore-end