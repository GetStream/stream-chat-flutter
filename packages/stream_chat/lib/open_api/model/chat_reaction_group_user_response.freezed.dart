// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_reaction_group_user_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ChatReactionGroupUserResponse {
  DateTime get createdAt;
  UserResponse? get user;
  String get userId;

  /// Create a copy of ChatReactionGroupUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ChatReactionGroupUserResponseCopyWith<ChatReactionGroupUserResponse>
  get copyWith =>
      _$ChatReactionGroupUserResponseCopyWithImpl<
        ChatReactionGroupUserResponse
      >(this as ChatReactionGroupUserResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ChatReactionGroupUserResponse &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, createdAt, user, userId);

  @override
  String toString() {
    return 'ChatReactionGroupUserResponse(createdAt: $createdAt, user: $user, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $ChatReactionGroupUserResponseCopyWith<$Res> {
  factory $ChatReactionGroupUserResponseCopyWith(
    ChatReactionGroupUserResponse value,
    $Res Function(ChatReactionGroupUserResponse) _then,
  ) = _$ChatReactionGroupUserResponseCopyWithImpl;
  @useResult
  $Res call({DateTime createdAt, UserResponse? user, String userId});
}

/// @nodoc
class _$ChatReactionGroupUserResponseCopyWithImpl<$Res>
    implements $ChatReactionGroupUserResponseCopyWith<$Res> {
  _$ChatReactionGroupUserResponseCopyWithImpl(this._self, this._then);

  final ChatReactionGroupUserResponse _self;
  final $Res Function(ChatReactionGroupUserResponse) _then;

  /// Create a copy of ChatReactionGroupUserResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? createdAt = null,
    Object? user = freezed,
    Object? userId = null,
  }) {
    return _then(
      ChatReactionGroupUserResponse(
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        user: freezed == user
            ? _self.user
            : user // ignore: cast_nullable_to_non_nullable
                  as UserResponse?,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
