// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_users_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryUsersResponse {
  String get duration;
  List<FullUserResponse> get users;

  /// Create a copy of QueryUsersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryUsersResponseCopyWith<QueryUsersResponse> get copyWith =>
      _$QueryUsersResponseCopyWithImpl<QueryUsersResponse>(
        this as QueryUsersResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryUsersResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.users, users));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(users),
  );

  @override
  String toString() {
    return 'QueryUsersResponse(duration: $duration, users: $users)';
  }
}

/// @nodoc
abstract mixin class $QueryUsersResponseCopyWith<$Res> {
  factory $QueryUsersResponseCopyWith(
    QueryUsersResponse value,
    $Res Function(QueryUsersResponse) _then,
  ) = _$QueryUsersResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<FullUserResponse> users});
}

/// @nodoc
class _$QueryUsersResponseCopyWithImpl<$Res>
    implements $QueryUsersResponseCopyWith<$Res> {
  _$QueryUsersResponseCopyWithImpl(this._self, this._then);

  final QueryUsersResponse _self;
  final $Res Function(QueryUsersResponse) _then;

  /// Create a copy of QueryUsersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? users = null}) {
    return _then(
      QueryUsersResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        users: null == users
            ? _self.users
            : users // ignore: cast_nullable_to_non_nullable
                  as List<FullUserResponse>,
      ),
    );
  }
}
