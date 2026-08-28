// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_user_group_members_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddUserGroupMembersRequest {
  bool? get asAdmin;
  List<String> get memberIds;
  String? get teamId;

  /// Create a copy of AddUserGroupMembersRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AddUserGroupMembersRequestCopyWith<AddUserGroupMembersRequest>
  get copyWith =>
      _$AddUserGroupMembersRequestCopyWithImpl<AddUserGroupMembersRequest>(
        this as AddUserGroupMembersRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AddUserGroupMembersRequest &&
            (identical(other.asAdmin, asAdmin) || other.asAdmin == asAdmin) &&
            const DeepCollectionEquality().equals(other.memberIds, memberIds) &&
            (identical(other.teamId, teamId) || other.teamId == teamId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    asAdmin,
    const DeepCollectionEquality().hash(memberIds),
    teamId,
  );

  @override
  String toString() {
    return 'AddUserGroupMembersRequest(asAdmin: $asAdmin, memberIds: $memberIds, teamId: $teamId)';
  }
}

/// @nodoc
abstract mixin class $AddUserGroupMembersRequestCopyWith<$Res> {
  factory $AddUserGroupMembersRequestCopyWith(
    AddUserGroupMembersRequest value,
    $Res Function(AddUserGroupMembersRequest) _then,
  ) = _$AddUserGroupMembersRequestCopyWithImpl;
  @useResult
  $Res call({bool? asAdmin, List<String> memberIds, String? teamId});
}

/// @nodoc
class _$AddUserGroupMembersRequestCopyWithImpl<$Res>
    implements $AddUserGroupMembersRequestCopyWith<$Res> {
  _$AddUserGroupMembersRequestCopyWithImpl(this._self, this._then);

  final AddUserGroupMembersRequest _self;
  final $Res Function(AddUserGroupMembersRequest) _then;

  /// Create a copy of AddUserGroupMembersRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? asAdmin = freezed,
    Object? memberIds = null,
    Object? teamId = freezed,
  }) {
    return _then(
      AddUserGroupMembersRequest(
        asAdmin: freezed == asAdmin
            ? _self.asAdmin
            : asAdmin // ignore: cast_nullable_to_non_nullable
                  as bool?,
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
