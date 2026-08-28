// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_users_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateUsersResponse {
  String get duration;
  String get membershipDeletionTaskId;
  Map<String, FullUserResponse> get users;

  /// Create a copy of UpdateUsersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateUsersResponseCopyWith<UpdateUsersResponse> get copyWith =>
      _$UpdateUsersResponseCopyWithImpl<UpdateUsersResponse>(
        this as UpdateUsersResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateUsersResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(
                  other.membershipDeletionTaskId,
                  membershipDeletionTaskId,
                ) ||
                other.membershipDeletionTaskId == membershipDeletionTaskId) &&
            const DeepCollectionEquality().equals(other.users, users));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    membershipDeletionTaskId,
    const DeepCollectionEquality().hash(users),
  );

  @override
  String toString() {
    return 'UpdateUsersResponse(duration: $duration, membershipDeletionTaskId: $membershipDeletionTaskId, users: $users)';
  }
}

/// @nodoc
abstract mixin class $UpdateUsersResponseCopyWith<$Res> {
  factory $UpdateUsersResponseCopyWith(
    UpdateUsersResponse value,
    $Res Function(UpdateUsersResponse) _then,
  ) = _$UpdateUsersResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String membershipDeletionTaskId,
    Map<String, FullUserResponse> users,
  });
}

/// @nodoc
class _$UpdateUsersResponseCopyWithImpl<$Res>
    implements $UpdateUsersResponseCopyWith<$Res> {
  _$UpdateUsersResponseCopyWithImpl(this._self, this._then);

  final UpdateUsersResponse _self;
  final $Res Function(UpdateUsersResponse) _then;

  /// Create a copy of UpdateUsersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? membershipDeletionTaskId = null,
    Object? users = null,
  }) {
    return _then(
      UpdateUsersResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        membershipDeletionTaskId: null == membershipDeletionTaskId
            ? _self.membershipDeletionTaskId
            : membershipDeletionTaskId // ignore: cast_nullable_to_non_nullable
                  as String,
        users: null == users
            ? _self.users
            : users // ignore: cast_nullable_to_non_nullable
                  as Map<String, FullUserResponse>,
      ),
    );
  }
}
