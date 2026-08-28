// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remove_user_group_members_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemoveUserGroupMembersResponse {
  String get duration;
  UserGroupResponse? get userGroup;

  /// Create a copy of RemoveUserGroupMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RemoveUserGroupMembersResponseCopyWith<RemoveUserGroupMembersResponse>
  get copyWith =>
      _$RemoveUserGroupMembersResponseCopyWithImpl<
        RemoveUserGroupMembersResponse
      >(this as RemoveUserGroupMembersResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RemoveUserGroupMembersResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.userGroup, userGroup) ||
                other.userGroup == userGroup));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, userGroup);

  @override
  String toString() {
    return 'RemoveUserGroupMembersResponse(duration: $duration, userGroup: $userGroup)';
  }
}

/// @nodoc
abstract mixin class $RemoveUserGroupMembersResponseCopyWith<$Res> {
  factory $RemoveUserGroupMembersResponseCopyWith(
    RemoveUserGroupMembersResponse value,
    $Res Function(RemoveUserGroupMembersResponse) _then,
  ) = _$RemoveUserGroupMembersResponseCopyWithImpl;
  @useResult
  $Res call({String duration, UserGroupResponse? userGroup});
}

/// @nodoc
class _$RemoveUserGroupMembersResponseCopyWithImpl<$Res>
    implements $RemoveUserGroupMembersResponseCopyWith<$Res> {
  _$RemoveUserGroupMembersResponseCopyWithImpl(this._self, this._then);

  final RemoveUserGroupMembersResponse _self;
  final $Res Function(RemoveUserGroupMembersResponse) _then;

  /// Create a copy of RemoveUserGroupMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? userGroup = freezed}) {
    return _then(
      RemoveUserGroupMembersResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        userGroup: freezed == userGroup
            ? _self.userGroup
            : userGroup // ignore: cast_nullable_to_non_nullable
                  as UserGroupResponse?,
      ),
    );
  }
}
