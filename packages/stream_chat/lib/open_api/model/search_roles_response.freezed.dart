// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_roles_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchRolesResponse {
  String get duration;
  List<Role> get roles;

  /// Create a copy of SearchRolesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchRolesResponseCopyWith<SearchRolesResponse> get copyWith =>
      _$SearchRolesResponseCopyWithImpl<SearchRolesResponse>(
        this as SearchRolesResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchRolesResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.roles, roles));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(roles),
  );

  @override
  String toString() {
    return 'SearchRolesResponse(duration: $duration, roles: $roles)';
  }
}

/// @nodoc
abstract mixin class $SearchRolesResponseCopyWith<$Res> {
  factory $SearchRolesResponseCopyWith(
    SearchRolesResponse value,
    $Res Function(SearchRolesResponse) _then,
  ) = _$SearchRolesResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<Role> roles});
}

/// @nodoc
class _$SearchRolesResponseCopyWithImpl<$Res>
    implements $SearchRolesResponseCopyWith<$Res> {
  _$SearchRolesResponseCopyWithImpl(this._self, this._then);

  final SearchRolesResponse _self;
  final $Res Function(SearchRolesResponse) _then;

  /// Create a copy of SearchRolesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? roles = null}) {
    return _then(
      SearchRolesResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        roles: null == roles
            ? _self.roles
            : roles // ignore: cast_nullable_to_non_nullable
                  as List<Role>,
      ),
    );
  }
}
