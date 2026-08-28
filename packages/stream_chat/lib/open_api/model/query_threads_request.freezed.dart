// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_threads_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryThreadsRequest {
  Map<String, Object?>? get filter;
  int? get limit;
  int? get memberLimit;
  String? get next;
  int? get participantLimit;
  String? get prev;
  int? get replyLimit;
  List<SortParamRequest>? get sort;
  bool? get watch;

  /// Create a copy of QueryThreadsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryThreadsRequestCopyWith<QueryThreadsRequest> get copyWith =>
      _$QueryThreadsRequestCopyWithImpl<QueryThreadsRequest>(
        this as QueryThreadsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryThreadsRequest &&
            const DeepCollectionEquality().equals(other.filter, filter) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.memberLimit, memberLimit) ||
                other.memberLimit == memberLimit) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.participantLimit, participantLimit) ||
                other.participantLimit == participantLimit) &&
            (identical(other.prev, prev) || other.prev == prev) &&
            (identical(other.replyLimit, replyLimit) ||
                other.replyLimit == replyLimit) &&
            const DeepCollectionEquality().equals(other.sort, sort) &&
            (identical(other.watch, watch) || other.watch == watch));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(filter),
    limit,
    memberLimit,
    next,
    participantLimit,
    prev,
    replyLimit,
    const DeepCollectionEquality().hash(sort),
    watch,
  );

  @override
  String toString() {
    return 'QueryThreadsRequest(filter: $filter, limit: $limit, memberLimit: $memberLimit, next: $next, participantLimit: $participantLimit, prev: $prev, replyLimit: $replyLimit, sort: $sort, watch: $watch)';
  }
}

/// @nodoc
abstract mixin class $QueryThreadsRequestCopyWith<$Res> {
  factory $QueryThreadsRequestCopyWith(
    QueryThreadsRequest value,
    $Res Function(QueryThreadsRequest) _then,
  ) = _$QueryThreadsRequestCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? filter,
    int? limit,
    int? memberLimit,
    String? next,
    int? participantLimit,
    String? prev,
    int? replyLimit,
    List<SortParamRequest>? sort,
    bool? watch,
  });
}

/// @nodoc
class _$QueryThreadsRequestCopyWithImpl<$Res>
    implements $QueryThreadsRequestCopyWith<$Res> {
  _$QueryThreadsRequestCopyWithImpl(this._self, this._then);

  final QueryThreadsRequest _self;
  final $Res Function(QueryThreadsRequest) _then;

  /// Create a copy of QueryThreadsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filter = freezed,
    Object? limit = freezed,
    Object? memberLimit = freezed,
    Object? next = freezed,
    Object? participantLimit = freezed,
    Object? prev = freezed,
    Object? replyLimit = freezed,
    Object? sort = freezed,
    Object? watch = freezed,
  }) {
    return _then(
      QueryThreadsRequest(
        filter: freezed == filter
            ? _self.filter
            : filter // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        memberLimit: freezed == memberLimit
            ? _self.memberLimit
            : memberLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        participantLimit: freezed == participantLimit
            ? _self.participantLimit
            : participantLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
        prev: freezed == prev
            ? _self.prev
            : prev // ignore: cast_nullable_to_non_nullable
                  as String?,
        replyLimit: freezed == replyLimit
            ? _self.replyLimit
            : replyLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
        watch: freezed == watch
            ? _self.watch
            : watch // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
