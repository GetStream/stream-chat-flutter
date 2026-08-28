// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_users_partial_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateUsersPartialRequest {
  List<UpdateUserPartialRequest> get users;

  /// Create a copy of UpdateUsersPartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateUsersPartialRequestCopyWith<UpdateUsersPartialRequest> get copyWith =>
      _$UpdateUsersPartialRequestCopyWithImpl<UpdateUsersPartialRequest>(
        this as UpdateUsersPartialRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateUsersPartialRequest &&
            const DeepCollectionEquality().equals(other.users, users));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(users));

  @override
  String toString() {
    return 'UpdateUsersPartialRequest(users: $users)';
  }
}

/// @nodoc
abstract mixin class $UpdateUsersPartialRequestCopyWith<$Res> {
  factory $UpdateUsersPartialRequestCopyWith(
    UpdateUsersPartialRequest value,
    $Res Function(UpdateUsersPartialRequest) _then,
  ) = _$UpdateUsersPartialRequestCopyWithImpl;
  @useResult
  $Res call({List<UpdateUserPartialRequest> users});
}

/// @nodoc
class _$UpdateUsersPartialRequestCopyWithImpl<$Res>
    implements $UpdateUsersPartialRequestCopyWith<$Res> {
  _$UpdateUsersPartialRequestCopyWithImpl(this._self, this._then);

  final UpdateUsersPartialRequest _self;
  final $Res Function(UpdateUsersPartialRequest) _then;

  /// Create a copy of UpdateUsersPartialRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? users = null}) {
    return _then(
      UpdateUsersPartialRequest(
        users: null == users
            ? _self.users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<UpdateUserPartialRequest>,
      ),
    );
  }
}
