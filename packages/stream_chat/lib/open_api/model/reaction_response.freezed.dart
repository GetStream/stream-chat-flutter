// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reaction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReactionResponse {
  DateTime get createdAt;
  Map<String, Object?> get custom;
  String get messageId;
  int get score;
  String get type;
  DateTime get updatedAt;
  UserResponse get user;
  String get userId;

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReactionResponseCopyWith<ReactionResponse> get copyWith =>
      _$ReactionResponseCopyWithImpl<ReactionResponse>(
        this as ReactionResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReactionResponse &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.custom, custom) &&
            (identical(other.messageId, messageId) ||
                other.messageId == messageId) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    createdAt,
    const DeepCollectionEquality().hash(custom),
    messageId,
    score,
    type,
    updatedAt,
    user,
    userId,
  );

  @override
  String toString() {
    return 'ReactionResponse(createdAt: $createdAt, custom: $custom, messageId: $messageId, score: $score, type: $type, updatedAt: $updatedAt, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ReactionResponseCopyWith<$Res> {
  factory $ReactionResponseCopyWith(
    ReactionResponse value,
    $Res Function(ReactionResponse) _then,
  ) = _$ReactionResponseCopyWithImpl;
  @useResult
  $Res call({
    DateTime createdAt,
    Map<String, Object?> custom,
    String messageId,
    int score,
    String type,
    DateTime updatedAt,
    UserResponse user,
    String userId,
  });
}

/// @nodoc
class _$ReactionResponseCopyWithImpl<$Res>
    implements $ReactionResponseCopyWith<$Res> {
  _$ReactionResponseCopyWithImpl(this._self, this._then);

  final ReactionResponse _self;
  final $Res Function(ReactionResponse) _then;

  /// Create a copy of ReactionResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? custom = null,
    Object? messageId = null,
    Object? score = null,
    Object? type = null,
    Object? updatedAt = null,
    Object? user = null,
    Object? userId = null,
  }) {
    return _then(
      ReactionResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        custom: null == custom
            ? _self.custom
            : custom // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        messageId: null == messageId
            ? _self.messageId
            : messageId // ignore: cast_nullable_to_non_nullable
                  as String,
        score: null == score
            ? _self.score
            : score // ignore: cast_nullable_to_non_nullable
                  as int,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: null == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
