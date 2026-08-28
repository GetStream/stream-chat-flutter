// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_banned_users_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryBannedUsersPayload {
  bool? get excludeExpiredBans;
  Map<String, Object?> get filterConditions;
  int? get limit;
  int? get offset;
  List<SortParamRequest>? get sort;

  /// Create a copy of QueryBannedUsersPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryBannedUsersPayloadCopyWith<QueryBannedUsersPayload> get copyWith =>
      _$QueryBannedUsersPayloadCopyWithImpl<QueryBannedUsersPayload>(
        this as QueryBannedUsersPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryBannedUsersPayload &&
            (identical(other.excludeExpiredBans, excludeExpiredBans) ||
                other.excludeExpiredBans == excludeExpiredBans) &&
            const DeepCollectionEquality().equals(
              other.filterConditions,
              filterConditions,
            ) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            const DeepCollectionEquality().equals(other.sort, sort));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    excludeExpiredBans,
    const DeepCollectionEquality().hash(filterConditions),
    limit,
    offset,
    const DeepCollectionEquality().hash(sort),
  );

  @override
  String toString() {
    return 'QueryBannedUsersPayload(excludeExpiredBans: $excludeExpiredBans, filterConditions: $filterConditions, limit: $limit, offset: $offset, sort: $sort)';
  }
}

/// @nodoc
abstract mixin class $QueryBannedUsersPayloadCopyWith<$Res> {
  factory $QueryBannedUsersPayloadCopyWith(
    QueryBannedUsersPayload value,
    $Res Function(QueryBannedUsersPayload) _then,
  ) = _$QueryBannedUsersPayloadCopyWithImpl;
  @useResult
  $Res call({
    bool? excludeExpiredBans,
    Map<String, Object?> filterConditions,
    int? limit,
    int? offset,
    List<SortParamRequest>? sort,
  });
}

/// @nodoc
class _$QueryBannedUsersPayloadCopyWithImpl<$Res>
    implements $QueryBannedUsersPayloadCopyWith<$Res> {
  _$QueryBannedUsersPayloadCopyWithImpl(this._self, this._then);

  final QueryBannedUsersPayload _self;
  final $Res Function(QueryBannedUsersPayload) _then;

  /// Create a copy of QueryBannedUsersPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? excludeExpiredBans = freezed,
    Object? filterConditions = null,
    Object? limit = freezed,
    Object? offset = freezed,
    Object? sort = freezed,
  }) {
    return _then(
      QueryBannedUsersPayload(
        excludeExpiredBans: freezed == excludeExpiredBans
            ? _self.excludeExpiredBans
            : excludeExpiredBans // ignore: cast_nullable_to_non_nullable
                  as bool?,
        filterConditions: null == filterConditions
            ? _self.filterConditions
            : filterConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        offset: freezed == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
      ),
    );
  }
}
