// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_users_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateUsersRequest {
  Map<String, UserRequest> get users;

  /// Create a copy of UpdateUsersRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UpdateUsersRequestCopyWith<UpdateUsersRequest> get copyWith =>
      _$UpdateUsersRequestCopyWithImpl<UpdateUsersRequest>(
        this as UpdateUsersRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UpdateUsersRequest &&
            const DeepCollectionEquality().equals(other.users, users));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(users));

  @override
  String toString() {
    return 'UpdateUsersRequest(users: $users)';
  }
}

/// @nodoc
abstract mixin class $UpdateUsersRequestCopyWith<$Res> {
  factory $UpdateUsersRequestCopyWith(
    UpdateUsersRequest value,
    $Res Function(UpdateUsersRequest) _then,
  ) = _$UpdateUsersRequestCopyWithImpl;
  @useResult
  $Res call({Map<String, UserRequest> users});
}

/// @nodoc
class _$UpdateUsersRequestCopyWithImpl<$Res>
    implements $UpdateUsersRequestCopyWith<$Res> {
  _$UpdateUsersRequestCopyWithImpl(this._self, this._then);

  final UpdateUsersRequest _self;
  final $Res Function(UpdateUsersRequest) _then;

  /// Create a copy of UpdateUsersRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? users = null}) {
    return _then(
      UpdateUsersRequest(
        users: null == users
            ? _self.users
            : users // ignore: cast_nullable_to_non_nullable
                  as Map<String, UserRequest>,
      ),
    );
  }
}
