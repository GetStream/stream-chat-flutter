// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_user_group_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateUserGroupRequest {
  String? get description;
  String? get id;
  List<String>? get memberIds;
  String get name;
  String? get teamId;

  /// Create a copy of CreateUserGroupRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $CreateUserGroupRequestCopyWith<CreateUserGroupRequest> get copyWith =>
      _$CreateUserGroupRequestCopyWithImpl<CreateUserGroupRequest>(
        this as CreateUserGroupRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is CreateUserGroupRequest &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.id, id) || other.id == id) &&
            const DeepCollectionEquality().equals(other.memberIds, memberIds) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.teamId, teamId) || other.teamId == teamId));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    description,
    id,
    const DeepCollectionEquality().hash(memberIds),
    name,
    teamId,
  );

  @override
  String toString() {
    return 'CreateUserGroupRequest(description: $description, id: $id, memberIds: $memberIds, name: $name, teamId: $teamId)';
  }
}

/// @nodoc
abstract mixin class $CreateUserGroupRequestCopyWith<$Res> {
  factory $CreateUserGroupRequestCopyWith(
    CreateUserGroupRequest value,
    $Res Function(CreateUserGroupRequest) _then,
  ) = _$CreateUserGroupRequestCopyWithImpl;
  @useResult
  $Res call({
    String? description,
    String? id,
    List<String>? memberIds,
    String name,
    String? teamId,
  });
}

/// @nodoc
class _$CreateUserGroupRequestCopyWithImpl<$Res>
    implements $CreateUserGroupRequestCopyWith<$Res> {
  _$CreateUserGroupRequestCopyWithImpl(this._self, this._then);

  final CreateUserGroupRequest _self;
  final $Res Function(CreateUserGroupRequest) _then;

  /// Create a copy of CreateUserGroupRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? id = freezed,
    Object? memberIds = freezed,
    Object? name = null,
    Object? teamId = freezed,
  }) {
    return _then(
      CreateUserGroupRequest(
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        id: freezed == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String?,
        memberIds: freezed == memberIds
            ? _self.memberIds
            : memberIds // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        teamId: freezed == teamId
            ? _self.teamId
            : teamId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
