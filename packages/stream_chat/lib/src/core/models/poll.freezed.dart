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
  Map<String, String>? get nameI18n;
  String? get description;
  Map<String, String>? get descriptionI18n;
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

  /// Create a copy of Poll
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollCopyWith<Poll> get copyWith => _$PollCopyWithImpl<Poll>(this as Poll, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Poll &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.nameI18n, nameI18n) &&
            (identical(other.description, description) || other.description == description) &&
            const DeepCollectionEquality().equals(
              other.descriptionI18n,
              descriptionI18n,
            ) &&
            const DeepCollectionEquality().equals(other.options, options) &&
            (identical(other.votingVisibility, votingVisibility) || other.votingVisibility == votingVisibility) &&
            (identical(other.enforceUniqueVote, enforceUniqueVote) || other.enforceUniqueVote == enforceUniqueVote) &&
            (identical(other.maxVotesAllowed, maxVotesAllowed) || other.maxVotesAllowed == maxVotesAllowed) &&
            (identical(
                  other.allowUserSuggestedOptions,
                  allowUserSuggestedOptions,
                ) ||
                other.allowUserSuggestedOptions == allowUserSuggestedOptions) &&
            (identical(other.allowAnswers, allowAnswers) || other.allowAnswers == allowAnswers) &&
            (identical(other.isClosed, isClosed) || other.isClosed == isClosed) &&
            (identical(other.answersCount, answersCount) || other.answersCount == answersCount) &&
            const DeepCollectionEquality().equals(
              other.voteCountsByOption,
              voteCountsByOption,
            ) &&
            const DeepCollectionEquality().equals(
              other.latestVotesByOption,
              latestVotesByOption,
            ) &&
            const DeepCollectionEquality().equals(
              other.latestVotes,
              latestVotes,
            ) &&
            const DeepCollectionEquality().equals(
              other.latestAnswers,
              latestAnswers,
            ) &&
            const DeepCollectionEquality().equals(
              other.ownVotesAndAnswers,
              ownVotesAndAnswers,
            ) &&
            (identical(other.voteCount, voteCount) || other.voteCount == voteCount) &&
            const DeepCollectionEquality().equals(other.ownVotes, ownVotes) &&
            const DeepCollectionEquality().equals(
              other.ownAnswers,
              ownAnswers,
            ) &&
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
    const DeepCollectionEquality().hash(nameI18n),
    description,
    const DeepCollectionEquality().hash(descriptionI18n),
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
    return 'Poll(id: $id, name: $name, nameI18n: $nameI18n, description: $description, descriptionI18n: $descriptionI18n, options: $options, votingVisibility: $votingVisibility, enforceUniqueVote: $enforceUniqueVote, maxVotesAllowed: $maxVotesAllowed, allowUserSuggestedOptions: $allowUserSuggestedOptions, allowAnswers: $allowAnswers, isClosed: $isClosed, answersCount: $answersCount, voteCountsByOption: $voteCountsByOption, latestVotesByOption: $latestVotesByOption, latestVotes: $latestVotes, latestAnswers: $latestAnswers, ownVotesAndAnswers: $ownVotesAndAnswers, voteCount: $voteCount, ownVotes: $ownVotes, ownAnswers: $ownAnswers, createdById: $createdById, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, extraData: $extraData)';
  }
}

/// @nodoc
abstract mixin class $PollCopyWith<$Res> {
  factory $PollCopyWith(Poll value, $Res Function(Poll) _then) = _$PollCopyWithImpl;
  @useResult
  $Res call({
    String? id,
    String name,
    Map<String, String>? nameI18n,
    String? description,
    Map<String, String>? descriptionI18n,
    List<PollOption> options,
    VotingVisibility votingVisibility,
    bool enforceUniqueVote,
    int? maxVotesAllowed,
    bool allowAnswers,
    List<PollVote> latestAnswers,
    int answersCount,
    bool allowUserSuggestedOptions,
    bool isClosed,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, int> voteCountsByOption,
    int voteCount,
    Map<String, List<PollVote>> latestVotesByOption,
    String? createdById,
    User? createdBy,
    List<PollVote> ownVotesAndAnswers,
    Map<String, Object?> extraData,
  });
}

/// @nodoc
class _$PollCopyWithImpl<$Res> implements $PollCopyWith<$Res> {
  _$PollCopyWithImpl(this._self, this._then);

  final Poll _self;
  final $Res Function(Poll) _then;

  /// Create a copy of Poll
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? nameI18n = freezed,
    Object? description = freezed,
    Object? descriptionI18n = freezed,
    Object? options = null,
    Object? votingVisibility = null,
    Object? enforceUniqueVote = null,
    Object? maxVotesAllowed = freezed,
    Object? allowAnswers = null,
    Object? latestAnswers = null,
    Object? answersCount = null,
    Object? allowUserSuggestedOptions = null,
    Object? isClosed = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? voteCountsByOption = null,
    Object? voteCount = null,
    Object? latestVotesByOption = null,
    Object? createdById = freezed,
    Object? createdBy = freezed,
    Object? ownVotesAndAnswers = null,
    Object? extraData = null,
  }) {
    return _then(
      Poll(
        id: freezed == id
            ? _self.id!
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        nameI18n: freezed == nameI18n
            ? _self.nameI18n
            : nameI18n // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        descriptionI18n: freezed == descriptionI18n
            ? _self.descriptionI18n
            : descriptionI18n // ignore: cast_nullable_to_non_nullable
                  as Map<String, String>?,
        options: null == options
            ? _self.options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<PollOption>,
        votingVisibility: null == votingVisibility
            ? _self.votingVisibility
            : votingVisibility // ignore: cast_nullable_to_non_nullable
                  as VotingVisibility,
        enforceUniqueVote: null == enforceUniqueVote
            ? _self.enforceUniqueVote
            : enforceUniqueVote // ignore: cast_nullable_to_non_nullable
                  as bool,
        maxVotesAllowed: freezed == maxVotesAllowed
            ? _self.maxVotesAllowed
            : maxVotesAllowed // ignore: cast_nullable_to_non_nullable
                  as int?,
        allowAnswers: null == allowAnswers
            ? _self.allowAnswers
            : allowAnswers // ignore: cast_nullable_to_non_nullable
                  as bool,
        latestAnswers: null == latestAnswers
            ? _self.latestAnswers
            : latestAnswers // ignore: cast_nullable_to_non_nullable
                  as List<PollVote>,
        answersCount: null == answersCount
            ? _self.answersCount
            : answersCount // ignore: cast_nullable_to_non_nullable
                  as int,
        allowUserSuggestedOptions: null == allowUserSuggestedOptions
            ? _self.allowUserSuggestedOptions
            : allowUserSuggestedOptions // ignore: cast_nullable_to_non_nullable
                  as bool,
        isClosed: null == isClosed
            ? _self.isClosed
            : isClosed // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _self.updatedAt!
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        voteCountsByOption: null == voteCountsByOption
            ? _self.voteCountsByOption
            : voteCountsByOption // ignore: cast_nullable_to_non_nullable
                  as Map<String, int>,
        voteCount: null == voteCount
            ? _self.voteCount
            : voteCount // ignore: cast_nullable_to_non_nullable
                  as int,
        latestVotesByOption: null == latestVotesByOption
            ? _self.latestVotesByOption
            : latestVotesByOption // ignore: cast_nullable_to_non_nullable
                  as Map<String, List<PollVote>>,
        createdById: freezed == createdById
            ? _self.createdById
            : createdById // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as User?,
        ownVotesAndAnswers: null == ownVotesAndAnswers
            ? _self.ownVotesAndAnswers
            : ownVotesAndAnswers // ignore: cast_nullable_to_non_nullable
                  as List<PollVote>,
        extraData: null == extraData
            ? _self.extraData
            : extraData // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
      ),
    );
  }
}
