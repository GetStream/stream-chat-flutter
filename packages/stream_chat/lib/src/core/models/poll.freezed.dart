// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Poll {
  String get id;
  String get name;
  String? get description;
  List<PollOption> get options;
  VotingVisibility get votingVisibility;
  bool get enforceUniqueVote;
  int? get maxVotesAllowed;
  bool get allowUserSuggestedOptions;
  bool get allowAnswers;
  bool get isClosed;
  int get answersCount;
  Map<String, int> get voteCountsByOption;
  Map<String, List<PollVote>> get latestVotesByOption;
  List<PollVote> get latestVotes;
  List<PollVote> get latestAnswers;
  List<PollVote> get ownVotesAndAnswers;
  int get voteCount;
  List<PollVote> get ownVotes;
  List<PollVote> get ownAnswers;
  String? get createdById;
  User? get createdBy;
  DateTime get createdAt;
  DateTime get updatedAt;
  Map<String, Object?> get extraData;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Poll &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) || other.description == description) &&
            const DeepCollectionEquality().equals(other.options, options) &&
            (identical(other.votingVisibility, votingVisibility) || other.votingVisibility == votingVisibility) &&
            (identical(other.enforceUniqueVote, enforceUniqueVote) || other.enforceUniqueVote == enforceUniqueVote) &&
            (identical(other.maxVotesAllowed, maxVotesAllowed) || other.maxVotesAllowed == maxVotesAllowed) &&
            (identical(other.allowUserSuggestedOptions, allowUserSuggestedOptions) ||
                other.allowUserSuggestedOptions == allowUserSuggestedOptions) &&
            (identical(other.allowAnswers, allowAnswers) || other.allowAnswers == allowAnswers) &&
            (identical(other.isClosed, isClosed) || other.isClosed == isClosed) &&
            (identical(other.answersCount, answersCount) || other.answersCount == answersCount) &&
            const DeepCollectionEquality().equals(other.voteCountsByOption, voteCountsByOption) &&
            const DeepCollectionEquality().equals(other.latestVotesByOption, latestVotesByOption) &&
            const DeepCollectionEquality().equals(other.latestVotes, latestVotes) &&
            const DeepCollectionEquality().equals(other.latestAnswers, latestAnswers) &&
            const DeepCollectionEquality().equals(other.ownVotesAndAnswers, ownVotesAndAnswers) &&
            (identical(other.voteCount, voteCount) || other.voteCount == voteCount) &&
            const DeepCollectionEquality().equals(other.ownVotes, ownVotes) &&
            const DeepCollectionEquality().equals(other.ownAnswers, ownAnswers) &&
            (identical(other.createdById, createdById) || other.createdById == createdById) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other.extraData, extraData));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    description,
    const DeepCollectionEquality().hash(options),
    votingVisibility,
    enforceUniqueVote,
    maxVotesAllowed,
    allowUserSuggestedOptions,
    allowAnswers,
    isClosed,
    answersCount,
    const DeepCollectionEquality().hash(voteCountsByOption),
    const DeepCollectionEquality().hash(latestVotesByOption),
    const DeepCollectionEquality().hash(latestVotes),
    const DeepCollectionEquality().hash(latestAnswers),
    const DeepCollectionEquality().hash(ownVotesAndAnswers),
    voteCount,
    const DeepCollectionEquality().hash(ownVotes),
    const DeepCollectionEquality().hash(ownAnswers),
    createdById,
    createdBy,
    createdAt,
    updatedAt,
    const DeepCollectionEquality().hash(extraData),
  ]);

  @override
  String toString() {
    return 'Poll(id: $id, name: $name, description: $description, options: $options, votingVisibility: $votingVisibility, enforceUniqueVote: $enforceUniqueVote, maxVotesAllowed: $maxVotesAllowed, allowUserSuggestedOptions: $allowUserSuggestedOptions, allowAnswers: $allowAnswers, isClosed: $isClosed, answersCount: $answersCount, voteCountsByOption: $voteCountsByOption, latestVotesByOption: $latestVotesByOption, latestVotes: $latestVotes, latestAnswers: $latestAnswers, ownVotesAndAnswers: $ownVotesAndAnswers, voteCount: $voteCount, ownVotes: $ownVotes, ownAnswers: $ownAnswers, createdById: $createdById, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, extraData: $extraData)';
  }
}
