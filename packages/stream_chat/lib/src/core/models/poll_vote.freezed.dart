// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'poll_vote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PollVote {
  String? get id;
  String? get pollId;
  String? get optionId;
  String? get answerText;
  DateTime get createdAt;
  DateTime get updatedAt;
  String? get userId;
  User? get user;

  /// Create a copy of PollVote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PollVoteCopyWith<PollVote> get copyWith => _$PollVoteCopyWithImpl<PollVote>(this as PollVote, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PollVote &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.pollId, pollId) || other.pollId == pollId) &&
            (identical(other.optionId, optionId) || other.optionId == optionId) &&
            (identical(other.answerText, answerText) || other.answerText == answerText) &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.user, user) || other.user == user));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, pollId, optionId, answerText, createdAt, updatedAt, userId, user);

  @override
  String toString() {
    return 'PollVote(id: $id, pollId: $pollId, optionId: $optionId, answerText: $answerText, createdAt: $createdAt, updatedAt: $updatedAt, userId: $userId, user: $user)';
  }
}

/// @nodoc
abstract mixin class $PollVoteCopyWith<$Res> {
  factory $PollVoteCopyWith(PollVote value, $Res Function(PollVote) _then) = _$PollVoteCopyWithImpl;
  @useResult
  $Res call({
    String? id,
    String? pollId,
    String? optionId,
    String? answerText,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    User? user,
  });
}

/// @nodoc
class _$PollVoteCopyWithImpl<$Res> implements $PollVoteCopyWith<$Res> {
  _$PollVoteCopyWithImpl(this._self, this._then);

  final PollVote _self;
  final $Res Function(PollVote) _then;

  /// Create a copy of PollVote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? pollId = freezed,
    Object? optionId = freezed,
    Object? answerText = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? userId = freezed,
    Object? user = freezed,
  }) {
    return _then(
      PollVote(
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        pollId: freezed == pollId
            ? _self.pollId
            : pollId // ignore: cast_nullable_to_non_nullable
                  as String?,
        optionId: freezed == optionId
            ? _self.optionId
            : optionId // ignore: cast_nullable_to_non_nullable
                  as String?,
        answerText: freezed == answerText
            ? _self.answerText
            : answerText // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _self.createdAt!
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _self.updatedAt!
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        userId: freezed == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String?,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
      ),
    );
  }
}
