// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_vote_response_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollVoteResponseData {
  String? get answerText;
  DateTime get createdAt;
  String get id;
  bool? get isAnswer;
  String get optionId;
  String get pollId;
  DateTime get updatedAt;
  UserResponse? get user;
  String? get userId;

  /// Create a copy of PollVoteResponseData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollVoteResponseDataCopyWith<PollVoteResponseData> get copyWith =>
      _$PollVoteResponseDataCopyWithImpl<PollVoteResponseData>(
        this as PollVoteResponseData,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVoteResponseData &&
            (identical(other.answerText, answerText) ||
                other.answerText == answerText) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.isAnswer, isAnswer) ||
                other.isAnswer == isAnswer) &&
            (identical(other.optionId, optionId) ||
                other.optionId == optionId) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    answerText,
    createdAt,
    id,
    isAnswer,
    optionId,
    pollId,
    updatedAt,
    user,
    userId,
  );

  @override
  String toString() {
    return 'PollVoteResponseData(answerText: $answerText, createdAt: $createdAt, id: $id, isAnswer: $isAnswer, optionId: $optionId, pollId: $pollId, updatedAt: $updatedAt, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $PollVoteResponseDataCopyWith<$Res> {
  factory $PollVoteResponseDataCopyWith(
    PollVoteResponseData value,
    $Res Function(PollVoteResponseData) _then,
  ) = _$PollVoteResponseDataCopyWithImpl;
  @useResult
  $Res call({
    String? answerText,
    DateTime createdAt,
    String id,
    bool? isAnswer,
    String optionId,
    String pollId,
    DateTime updatedAt,
    UserResponse? user,
    String? userId,
  });
}

/// @nodoc
class _$PollVoteResponseDataCopyWithImpl<$Res>
    implements $PollVoteResponseDataCopyWith<$Res> {
  _$PollVoteResponseDataCopyWithImpl(this._self, this._then);

  final PollVoteResponseData _self;
  final $Res Function(PollVoteResponseData) _then;

  /// Create a copy of PollVoteResponseData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? answerText = freezed,
    Object? createdAt = null,
    Object? id = null,
    Object? isAnswer = freezed,
    Object? optionId = null,
    Object? pollId = null,
    Object? updatedAt = null,
    Object? user = freezed,
    Object? userId = freezed,
  }) {
    return _then(
      PollVoteResponseData(
        answerText: freezed == answerText
            ? _self.answerText
            : answerText // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        isAnswer: freezed == isAnswer
            ? _self.isAnswer
            : isAnswer // ignore: cast_nullable_to_non_nullable
                  as bool?,
        optionId: null == optionId
            ? _self.optionId
            : optionId // ignore: cast_nullable_to_non_nullable
                  as String,
        pollId: null == pollId
            ? _self.pollId
            : pollId // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
