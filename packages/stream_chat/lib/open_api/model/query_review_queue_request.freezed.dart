// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_review_queue_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryReviewQueueRequest {
  bool? get excludeDefaultActionConfig;
  Map<String, Object?>? get filter;
  int? get limit;
  int? get lockCount;
  int? get lockDuration;
  bool? get lockItems;
  String? get next;
  String? get prev;
  List<SortParamRequest>? get sort;
  bool? get statsOnly;

  /// Create a copy of QueryReviewQueueRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryReviewQueueRequestCopyWith<QueryReviewQueueRequest> get copyWith =>
      _$QueryReviewQueueRequestCopyWithImpl<QueryReviewQueueRequest>(
        this as QueryReviewQueueRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryReviewQueueRequest &&
            (identical(
                  other.excludeDefaultActionConfig,
                  excludeDefaultActionConfig,
                ) ||
                other.excludeDefaultActionConfig ==
                    excludeDefaultActionConfig) &&
            const DeepCollectionEquality().equals(other.filter, filter) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.lockCount, lockCount) ||
                other.lockCount == lockCount) &&
            (identical(other.lockDuration, lockDuration) ||
                other.lockDuration == lockDuration) &&
            (identical(other.lockItems, lockItems) ||
                other.lockItems == lockItems) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            const DeepCollectionEquality().equals(other.sort, sort) &&
            (identical(other.statsOnly, statsOnly) ||
                other.statsOnly == statsOnly));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    excludeDefaultActionConfig,
    const DeepCollectionEquality().hash(filter),
    limit,
    lockCount,
    lockDuration,
    lockItems,
    next,
    prev,
    const DeepCollectionEquality().hash(sort),
    statsOnly,
  );

  @override
  String toString() {
    return 'QueryReviewQueueRequest(excludeDefaultActionConfig: $excludeDefaultActionConfig, filter: $filter, limit: $limit, lockCount: $lockCount, lockDuration: $lockDuration, lockItems: $lockItems, next: $next, prev: $prev, sort: $sort, statsOnly: $statsOnly)';
  }
}

/// @nodoc
abstract mixin class $QueryReviewQueueRequestCopyWith<$Res> {
  factory $QueryReviewQueueRequestCopyWith(
    QueryReviewQueueRequest value,
    $Res Function(QueryReviewQueueRequest) _then,
  ) = _$QueryReviewQueueRequestCopyWithImpl;
  @useResult
  $Res call({
    bool? excludeDefaultActionConfig,
    Map<String, Object?>? filter,
    int? limit,
    int? lockCount,
    int? lockDuration,
    bool? lockItems,
    String? next,
    String? prev,
    List<SortParamRequest>? sort,
    bool? statsOnly,
  });
}

/// @nodoc
class _$QueryReviewQueueRequestCopyWithImpl<$Res>
    implements $QueryReviewQueueRequestCopyWith<$Res> {
  _$QueryReviewQueueRequestCopyWithImpl(this._self, this._then);

  final QueryReviewQueueRequest _self;
  final $Res Function(QueryReviewQueueRequest) _then;

  /// Create a copy of QueryReviewQueueRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? excludeDefaultActionConfig = freezed,
    Object? filter = freezed,
    Object? limit = freezed,
    Object? lockCount = freezed,
    Object? lockDuration = freezed,
    Object? lockItems = freezed,
    Object? next = freezed,
    Object? prev = freezed,
    Object? sort = freezed,
    Object? statsOnly = freezed,
  }) {
    return _then(
      QueryReviewQueueRequest(
        excludeDefaultActionConfig: freezed == excludeDefaultActionConfig
            ? _self.excludeDefaultActionConfig
            : excludeDefaultActionConfig // ignore: cast_nullable_to_non_nullable
                  as bool?,
        filter: freezed == filter
            ? _self.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        lockCount: freezed == lockCount
            ? _self.lockCount
            : lockCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        lockDuration: freezed == lockDuration
            ? _self.lockDuration
            : lockDuration // ignore: cast_nullable_to_non_nullable
                  as int?,
        lockItems: freezed == lockItems
            ? _self.lockItems
            : lockItems // ignore: cast_nullable_to_non_nullable
                  as bool?,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
        statsOnly: freezed == statsOnly
            ? _self.statsOnly
            : statsOnly // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
