// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remove_user_group_members_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RemoveUserGroupMembersRequest {
  List<String> get memberIds;
  String? get teamId;

  /// Create a copy of RemoveUserGroupMembersRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RemoveUserGroupMembersRequestCopyWith<RemoveUserGroupMembersRequest>
  get copyWith =>
      _$RemoveUserGroupMembersRequestCopyWithImpl<
        RemoveUserGroupMembersRequest
      >(this as RemoveUserGroupMembersRequest, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RemoveUserGroupMembersRequest &&
            const DeepCollectionEquality().equals(other.memberIds, memberIds) &&
            (identical(other.teamId, teamId) || other.teamId == teamId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(memberIds),
    teamId,
  );

  @override
  String toString() {
    return 'RemoveUserGroupMembersRequest(memberIds: $memberIds, teamId: $teamId)';
  }
}

/// @nodoc
abstract mixin class $RemoveUserGroupMembersRequestCopyWith<$Res> {
  factory $RemoveUserGroupMembersRequestCopyWith(
    RemoveUserGroupMembersRequest value,
    $Res Function(RemoveUserGroupMembersRequest) _then,
  ) = _$RemoveUserGroupMembersRequestCopyWithImpl;
  @useResult
  $Res call({List<String> memberIds, String? teamId});
}

/// @nodoc
class _$RemoveUserGroupMembersRequestCopyWithImpl<$Res>
    implements $RemoveUserGroupMembersRequestCopyWith<$Res> {
  _$RemoveUserGroupMembersRequestCopyWithImpl(this._self, this._then);

  final RemoveUserGroupMembersRequest _self;
  final $Res Function(RemoveUserGroupMembersRequest) _then;

  /// Create a copy of RemoveUserGroupMembersRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? memberIds = null, Object? teamId = freezed}) {
    return _then(
      RemoveUserGroupMembersRequest(
        memberIds: null == memberIds
            ? _self.memberIds
            : memberIds // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        teamId: freezed == teamId
            ? _self.teamId
            : teamId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
