// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_users_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryUsersPayload {
  Map<String, Object?> get filterConditions;
  bool? get includeDeactivatedUsers;
  int? get limit;
  int? get offset;
  bool? get presence;
  List<SortParamRequest>? get sort;

  /// Create a copy of QueryUsersPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryUsersPayloadCopyWith<QueryUsersPayload> get copyWith =>
      _$QueryUsersPayloadCopyWithImpl<QueryUsersPayload>(
        this as QueryUsersPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryUsersPayload &&
            const DeepCollectionEquality().equals(
              other.filterConditions,
              filterConditions,
            ) &&
            (identical(
                  other.includeDeactivatedUsers,
                  includeDeactivatedUsers,
                ) ||
                other.includeDeactivatedUsers == includeDeactivatedUsers) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.presence, presence) ||
                other.presence == presence) &&
            const DeepCollectionEquality().equals(other.sort, sort));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(filterConditions),
    includeDeactivatedUsers,
    limit,
    offset,
    presence,
    const DeepCollectionEquality().hash(sort),
  );

  @override
  String toString() {
    return 'QueryUsersPayload(filterConditions: $filterConditions, includeDeactivatedUsers: $includeDeactivatedUsers, limit: $limit, offset: $offset, presence: $presence, sort: $sort)';
  }
}

/// @nodoc
abstract mixin class $QueryUsersPayloadCopyWith<$Res> {
  factory $QueryUsersPayloadCopyWith(
    QueryUsersPayload value,
    $Res Function(QueryUsersPayload) _then,
  ) = _$QueryUsersPayloadCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?> filterConditions,
    bool? includeDeactivatedUsers,
    int? limit,
    int? offset,
    bool? presence,
    List<SortParamRequest>? sort,
  });
}

/// @nodoc
class _$QueryUsersPayloadCopyWithImpl<$Res>
    implements $QueryUsersPayloadCopyWith<$Res> {
  _$QueryUsersPayloadCopyWithImpl(this._self, this._then);

  final QueryUsersPayload _self;
  final $Res Function(QueryUsersPayload) _then;

  /// Create a copy of QueryUsersPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filterConditions = null,
    Object? includeDeactivatedUsers = freezed,
    Object? limit = freezed,
    Object? offset = freezed,
    Object? presence = freezed,
    Object? sort = freezed,
  }) {
    return _then(
      QueryUsersPayload(
        filterConditions: null == filterConditions
            ? _self.filterConditions
            : filterConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        includeDeactivatedUsers: freezed == includeDeactivatedUsers
            ? _self.includeDeactivatedUsers
            : includeDeactivatedUsers // ignore: cast_nullable_to_non_nullable
                  as bool?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        offset: freezed == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
        presence: freezed == presence
            ? _self.presence
            : presence // ignore: cast_nullable_to_non_nullable
                  as bool?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
      ),
    );
  }
}
