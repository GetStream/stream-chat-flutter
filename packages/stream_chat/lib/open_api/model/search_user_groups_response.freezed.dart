// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_user_groups_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchUserGroupsResponse {
  String get duration;
  List<UserGroupResponse> get userGroups;

  /// Create a copy of SearchUserGroupsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchUserGroupsResponseCopyWith<SearchUserGroupsResponse> get copyWith =>
      _$SearchUserGroupsResponseCopyWithImpl<SearchUserGroupsResponse>(
        this as SearchUserGroupsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchUserGroupsResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(
              other.userGroups,
              userGroups,
            ));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(userGroups),
  );

  @override
  String toString() {
    return 'SearchUserGroupsResponse(duration: $duration, userGroups: $userGroups)';
  }
}

/// @nodoc
abstract mixin class $SearchUserGroupsResponseCopyWith<$Res> {
  factory $SearchUserGroupsResponseCopyWith(
    SearchUserGroupsResponse value,
    $Res Function(SearchUserGroupsResponse) _then,
  ) = _$SearchUserGroupsResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<UserGroupResponse> userGroups});
}

/// @nodoc
class _$SearchUserGroupsResponseCopyWithImpl<$Res>
    implements $SearchUserGroupsResponseCopyWith<$Res> {
  _$SearchUserGroupsResponseCopyWithImpl(this._self, this._then);

  final SearchUserGroupsResponse _self;
  final $Res Function(SearchUserGroupsResponse) _then;

  /// Create a copy of SearchUserGroupsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? userGroups = null}) {
    return _then(
      SearchUserGroupsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        userGroups: null == userGroups
            ? _self.userGroups
            : userGroups // ignore: cast_nullable_to_non_nullable
                  as List<UserGroupResponse>,
      ),
    );
  }
}
