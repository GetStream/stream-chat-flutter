// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_group.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserGroup {
  int get appPk;
  DateTime get createdAt;
  String? get createdBy;
  String? get description;
  String get id;
  List<UserGroupMember>? get members;
  String get name;
  String? get teamId;
  DateTime get updatedAt;

  /// Create a copy of UserGroup
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupCopyWith<UserGroup> get copyWith =>
      _$UserGroupCopyWithImpl<UserGroup>(this as UserGroup, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroup &&
            (identical(other.appPk, appPk) || other.appPk == appPk) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    appPk,
    createdAt,
    createdBy,
    description,
    id,
    const DeepCollectionEquality().hash(members),
    name,
    teamId,
    updatedAt,
  );

  @override
  String toString() {
    return 'UserGroup(appPk: $appPk, createdAt: $createdAt, createdBy: $createdBy, description: $description, id: $id, members: $members, name: $name, teamId: $teamId, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $UserGroupCopyWith<$Res> {
  factory $UserGroupCopyWith(UserGroup value, $Res Function(UserGroup) _then) =
      _$UserGroupCopyWithImpl;
  @useResult
  $Res call({
    int appPk,
    DateTime createdAt,
    String? createdBy,
    String? description,
    String id,
    List<UserGroupMember>? members,
    String name,
    String? teamId,
    DateTime updatedAt,
  });
}

/// @nodoc
class _$UserGroupCopyWithImpl<$Res> implements $UserGroupCopyWith<$Res> {
  _$UserGroupCopyWithImpl(this._self, this._then);

  final UserGroup _self;
  final $Res Function(UserGroup) _then;

  /// Create a copy of UserGroup
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appPk = null,
    Object? createdAt = null,
    Object? createdBy = freezed,
    Object? description = freezed,
    Object? id = null,
    Object? members = freezed,
    Object? name = null,
    Object? teamId = freezed,
    Object? updatedAt = null,
  }) {
    return _then(
      UserGroup(
        appPk: null == appPk
            ? _self.appPk
            : appPk // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: freezed == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        members: freezed == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<UserGroupMember>?,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        teamId: freezed == teamId
            ? _self.teamId
            : teamId // ignore: cast_nullable_to_non_nullable
                  as String?,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
