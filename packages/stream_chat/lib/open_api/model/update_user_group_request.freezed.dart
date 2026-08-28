// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_user_group_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateUserGroupRequest {
  String? get description;
  String? get name;
  String? get teamId;

  /// Create a copy of UpdateUserGroupRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateUserGroupRequestCopyWith<UpdateUserGroupRequest> get copyWith =>
      _$UpdateUserGroupRequestCopyWithImpl<UpdateUserGroupRequest>(
        this as UpdateUserGroupRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateUserGroupRequest &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.teamId, teamId) || other.teamId == teamId));
  }

  @override
  int get hashCode => Object.hash(runtimeType, description, name, teamId);

  @override
  String toString() {
    return 'UpdateUserGroupRequest(description: $description, name: $name, teamId: $teamId)';
  }
}

/// @nodoc
abstract mixin class $UpdateUserGroupRequestCopyWith<$Res> {
  factory $UpdateUserGroupRequestCopyWith(
    UpdateUserGroupRequest value,
    $Res Function(UpdateUserGroupRequest) _then,
  ) = _$UpdateUserGroupRequestCopyWithImpl;
  @useResult
  $Res call({String? description, String? name, String? teamId});
}

/// @nodoc
class _$UpdateUserGroupRequestCopyWithImpl<$Res>
    implements $UpdateUserGroupRequestCopyWith<$Res> {
  _$UpdateUserGroupRequestCopyWithImpl(this._self, this._then);

  final UpdateUserGroupRequest _self;
  final $Res Function(UpdateUserGroupRequest) _then;

  /// Create a copy of UpdateUserGroupRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? description = freezed,
    Object? name = freezed,
    Object? teamId = freezed,
  }) {
    return _then(
      UpdateUserGroupRequest(
        description: freezed == description
            ? _self.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        name: freezed == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String?,
        teamId: freezed == teamId
            ? _self.teamId
            : teamId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
