// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_channel_bans_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryChannelBansRequest {
  bool? get excludeExpiredBans;
  Map<String, Object?>? get filterConditions;
  bool? get includeTotal;
  int? get limit;
  String? get next;
  String? get prev;

  /// Create a copy of QueryChannelBansRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryChannelBansRequestCopyWith<QueryChannelBansRequest> get copyWith =>
      _$QueryChannelBansRequestCopyWithImpl<QueryChannelBansRequest>(
        this as QueryChannelBansRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryChannelBansRequest &&
            (identical(other.excludeExpiredBans, excludeExpiredBans) ||
                other.excludeExpiredBans == excludeExpiredBans) &&
            const DeepCollectionEquality().equals(
              other.filterConditions,
              filterConditions,
            ) &&
            (identical(other.includeTotal, includeTotal) || other.includeTotal == includeTotal) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    excludeExpiredBans,
    const DeepCollectionEquality().hash(filterConditions),
    includeTotal,
    limit,
    next,
    prev,
  );

  @override
  String toString() {
    return 'QueryChannelBansRequest(excludeExpiredBans: $excludeExpiredBans, filterConditions: $filterConditions, includeTotal: $includeTotal, limit: $limit, next: $next, prev: $prev)';
  }
}

/// @nodoc
abstract mixin class $QueryChannelBansRequestCopyWith<$Res> {
  factory $QueryChannelBansRequestCopyWith(
    QueryChannelBansRequest value,
    $Res Function(QueryChannelBansRequest) _then,
  ) = _$QueryChannelBansRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? excludeExpiredBans,
    Map<String, Object?>? filterConditions,
    bool? includeTotal,
    int? limit,
    String? next,
    String? prev,
  });
}

/// @nodoc
class _$QueryChannelBansRequestCopyWithImpl<$Res> implements $QueryChannelBansRequestCopyWith<$Res> {
  _$QueryChannelBansRequestCopyWithImpl(this._self, this._then);

  final QueryChannelBansRequest _self;
  final $Res Function(QueryChannelBansRequest) _then;

  /// Create a copy of QueryChannelBansRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? excludeExpiredBans = freezed,
    Object? filterConditions = freezed,
    Object? includeTotal = freezed,
    Object? limit = freezed,
    Object? next = freezed,
    Object? prev = freezed,
  }) {
    return _then(
      QueryChannelBansRequest(
        excludeExpiredBans: freezed == excludeExpiredBans
            ? _self.excludeExpiredBans
            : excludeExpiredBans // ignore: cast_nullable_to_non_nullable
                  as bool?,
        filterConditions: freezed == filterConditions
            ? _self.filterConditions
            : filterConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        includeTotal: freezed == includeTotal
            ? _self.includeTotal
            : includeTotal // ignore: cast_nullable_to_non_nullable
                  as bool?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
