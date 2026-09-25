// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_group_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserGroupResponse {
  DateTime get createdAt;
  String? get createdBy;
  String? get description;
  String get id;
  List<UserGroupMember>? get members;
  String get name;
  String? get teamId;
  DateTime get updatedAt;

  /// Create a copy of UserGroupResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserGroupResponseCopyWith<UserGroupResponse> get copyWith => _$UserGroupResponseCopyWithImpl<UserGroupResponse>(
    this as UserGroupResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserGroupResponse &&
            (identical(other.createdAt, createdAt) || other.createdAt == createdAt) &&
            (identical(other.createdBy, createdBy) || other.createdBy == createdBy) &&
            (identical(other.description, description) || other.description == description) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.members, members) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
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
    return 'UserGroupResponse(createdAt: $createdAt, createdBy: $createdBy, description: $description, id: $id, members: $members, name: $name, teamId: $teamId, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $UserGroupResponseCopyWith<$Res> {
  factory $UserGroupResponseCopyWith(
    UserGroupResponse value,
    $Res Function(UserGroupResponse) _then,
  ) = _$UserGroupResponseCopyWithImpl;
  @useResult
  $Res call({
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
class _$UserGroupResponseCopyWithImpl<$Res> implements $UserGroupResponseCopyWith<$Res> {
  _$UserGroupResponseCopyWithImpl(this._self, this._then);

  final UserGroupResponse _self;
  final $Res Function(UserGroupResponse) _then;

  /// Create a copy of UserGroupResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
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
      UserGroupResponse(
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
