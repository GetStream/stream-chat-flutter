// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_poll_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdatePollRequest {
  bool? get allowAnswers;
  bool? get allowUserSuggestedOptions;
  Map<String, Object?>? get custom;
  String? get description;
  bool? get enforceUniqueVote;
  String get id;
  bool? get isClosed;
  int? get maxVotesAllowed;
  String get name;
  List<PollOptionRequest>? get options;
  UpdatePollRequestVotingVisibility? get votingVisibility;

  /// Create a copy of UpdatePollRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdatePollRequestCopyWith<UpdatePollRequest> get copyWith =>
      _$UpdatePollRequestCopyWithImpl<UpdatePollRequest>(
        this as UpdatePollRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdatePollRequest &&
            (identical(other.allowAnswers, allowAnswers) ||
                other.allowAnswers == allowAnswers) &&
            (identical(
                  other.allowUserSuggestedOptions,
                  allowUserSuggestedOptions,
                ) ||
                other.allowUserSuggestedOptions == allowUserSuggestedOptions) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.enforceUniqueVote, enforceUniqueVote) ||
                other.enforceUniqueVote == enforceUniqueVote) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isClosed, isClosed) ||
                other.isClosed == isClosed) &&
            (identical(other.maxVotesAllowed, maxVotesAllowed) ||
                other.maxVotesAllowed == maxVotesAllowed) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other.options, options) &&
            (identical(other.votingVisibility, votingVisibility) ||
                other.votingVisibility == votingVisibility));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    allowAnswers,
    allowUserSuggestedOptions,
    const DeepCollectionEquality().hash(custom),
    description,
    enforceUniqueVote,
    id,
    isClosed,
    maxVotesAllowed,
    name,
    const DeepCollectionEquality().hash(options),
    votingVisibility,
  );

  @override
  String toString() {
    return 'UpdatePollRequest(allowAnswers: $allowAnswers, allowUserSuggestedOptions: $allowUserSuggestedOptions, custom: $custom, description: $description, enforceUniqueVote: $enforceUniqueVote, id: $id, isClosed: $isClosed, maxVotesAllowed: $maxVotesAllowed, name: $name, options: $options, votingVisibility: $votingVisibility)';
  }
}

/// @nodoc
abstract mixin class $UpdatePollRequestCopyWith<$Res> {
  factory $UpdatePollRequestCopyWith(
    UpdatePollRequest value,
    $Res Function(UpdatePollRequest) _then,
  ) = _$UpdatePollRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? allowAnswers,
    bool? allowUserSuggestedOptions,
    Map<String, Object?>? custom,
    String? description,
    bool? enforceUniqueVote,
    String id,
    bool? isClosed,
    int? maxVotesAllowed,
    String name,
    List<PollOptionRequest>? options,
    UpdatePollRequestVotingVisibility? votingVisibility,
  });
}

/// @nodoc
class _$UpdatePollRequestCopyWithImpl<$Res>
    implements $UpdatePollRequestCopyWith<$Res> {
  _$UpdatePollRequestCopyWithImpl(this._self, this._then);

  final UpdatePollRequest _self;
  final $Res Function(UpdatePollRequest) _then;

  /// Create a copy of UpdatePollRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? allowAnswers = freezed,
    Object? allowUserSuggestedOptions = freezed,
    Object? custom = freezed,
    Object? description = freezed,
    Object? enforceUniqueVote = freezed,
    Object? id = null,
    Object? isClosed = freezed,
    Object? maxVotesAllowed = freezed,
    Object? name = null,
    Object? options = freezed,
    Object? votingVisibility = freezed,
  }) {
    return _then(
      UpdatePollRequest(
        allowAnswers: freezed == allowAnswers
            ? _self.allowAnswers
            : allowAnswers // ignore: cast_nullable_to_non_nullable
                  as bool?,
        allowUserSuggestedOptions: freezed == allowUserSuggestedOptions
            ? _self.allowUserSuggestedOptions
            : allowUserSuggestedOptions // ignore: cast_nullable_to_non_nullable
                  as bool?,
        custom: freezed == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        enforceUniqueVote: freezed == enforceUniqueVote
            ? _self.enforceUniqueVote
            : enforceUniqueVote // ignore: cast_nullable_to_non_nullable
                  as bool?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        isClosed: freezed == isClosed
            ? _self.isClosed
            : isClosed // ignore: cast_nullable_to_non_nullable
                  as bool?,
        maxVotesAllowed: freezed == maxVotesAllowed
            ? _self.maxVotesAllowed
            : maxVotesAllowed // ignore: cast_nullable_to_non_nullable
                  as int?,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        options: freezed == options
            ? _self.options
            : options // ignore: cast_nullable_to_non_nullable
                  as List<PollOptionRequest>?,
        votingVisibility: freezed == votingVisibility
            ? _self.votingVisibility
            : votingVisibility // ignore: cast_nullable_to_non_nullable
                  as UpdatePollRequestVotingVisibility?,
      ),
    );
  }
}
