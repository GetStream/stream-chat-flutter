// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_group_member.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserGroupMember {
  int get appPk;
  DateTime get createdAt;
  String get groupId;
  bool get isAdmin;
  String get userId;

  /// Create a copy of UserGroupMember
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupMemberCopyWith<UserGroupMember> get copyWith =>
      _$UserGroupMemberCopyWithImpl<UserGroupMember>(
        this as UserGroupMember,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroupMember &&
            (identical(other.appPk, appPk) || other.appPk == appPk) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.groupId, groupId) || other.groupId == groupId) &&
            (identical(other.isAdmin, isAdmin) || other.isAdmin == isAdmin) &&
            (identical(other.userId, userId) || other.userId == userId));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, appPk, createdAt, groupId, isAdmin, userId);

  @override
  String toString() {
    return 'UserGroupMember(appPk: $appPk, createdAt: $createdAt, groupId: $groupId, isAdmin: $isAdmin, userId: $userId)';
  }
}

/// @nodoc
abstract mixin class $UserGroupMemberCopyWith<$Res> {
  factory $UserGroupMemberCopyWith(
    UserGroupMember value,
    $Res Function(UserGroupMember) _then,
  ) = _$UserGroupMemberCopyWithImpl;
  @useResult
  $Res call({
    int appPk,
    DateTime createdAt,
    String groupId,
    bool isAdmin,
    String userId,
  });
}

/// @nodoc
class _$UserGroupMemberCopyWithImpl<$Res>
    implements $UserGroupMemberCopyWith<$Res> {
  _$UserGroupMemberCopyWithImpl(this._self, this._then);

  final UserGroupMember _self;
  final $Res Function(UserGroupMember) _then;

  /// Create a copy of UserGroupMember
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appPk = null,
    Object? createdAt = null,
    Object? groupId = null,
    Object? isAdmin = null,
    Object? userId = null,
  }) {
    return _then(
      UserGroupMember(
        appPk: null == appPk
            ? _self.appPk
            : appPk // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        groupId: null == groupId
            ? _self.groupId
            : groupId // ignore: cast_nullable_to_non_nullable
                  as String,
        isAdmin: null == isAdmin
            ? _self.isAdmin
            : isAdmin // ignore: cast_nullable_to_non_nullable
                  as bool,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
