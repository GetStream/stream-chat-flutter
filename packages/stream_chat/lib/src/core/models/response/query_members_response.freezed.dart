// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_members_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryMembersResponse {
  String get duration;
  List<Member> get members;

  /// Create a copy of QueryMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryMembersResponseCopyWith<QueryMembersResponse> get copyWith =>
      _$QueryMembersResponseCopyWithImpl<QueryMembersResponse>(this as QueryMembersResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryMembersResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(other.members, members));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, const DeepCollectionEquality().hash(members));

  @override
  String toString() {
    return 'QueryMembersResponse(duration: $duration, members: $members)';
  }
}

/// @nodoc
abstract mixin class $QueryMembersResponseCopyWith<$Res> {
  factory $QueryMembersResponseCopyWith(QueryMembersResponse value, $Res Function(QueryMembersResponse) _then) =
      _$QueryMembersResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<Member> members});
}

/// @nodoc
class _$QueryMembersResponseCopyWithImpl<$Res> implements $QueryMembersResponseCopyWith<$Res> {
  _$QueryMembersResponseCopyWithImpl(this._self, this._then);

  final QueryMembersResponse _self;
  final $Res Function(QueryMembersResponse) _then;

  /// Create a copy of QueryMembersResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? members = null}) {
    return _then(
      QueryMembersResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        members: null == members
            ? _self.members
            : members // ignore: cast_nullable_to_non_nullable
                  as List<Member>,
      ),
    );
  }
}
