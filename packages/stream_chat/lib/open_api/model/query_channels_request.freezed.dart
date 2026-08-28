// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_channels_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryChannelsRequest {
  Map<String, Object?>? get filterConditions;
  Map<String, Object?>? get filterValues;
  int? get limit;
  List<String>? get memberCustomInclude;
  int? get memberLimit;
  int? get messageLimit;
  int? get offset;
  String? get predefinedFilter;
  bool? get presence;
  List<SortParamRequest>? get sort;
  Map<String, Object?>? get sortValues;
  bool? get state;
  bool? get watch;

  /// Create a copy of QueryChannelsRequest
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryChannelsRequestCopyWith<QueryChannelsRequest> get copyWith =>
      _$QueryChannelsRequestCopyWithImpl<QueryChannelsRequest>(
        this as QueryChannelsRequest,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryChannelsRequest &&
            const DeepCollectionEquality().equals(
              other.filterConditions,
              filterConditions,
            ) &&
            const DeepCollectionEquality().equals(
              other.filterValues,
              filterValues,
            ) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(
              other.memberCustomInclude,
              memberCustomInclude,
            ) &&
            (identical(other.memberLimit, memberLimit) ||
                other.memberLimit == memberLimit) &&
            (identical(other.messageLimit, messageLimit) ||
                other.messageLimit == messageLimit) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.predefinedFilter, predefinedFilter) ||
                other.predefinedFilter == predefinedFilter) &&
            (identical(other.presence, presence) ||
                other.presence == presence) &&
            const DeepCollectionEquality().equals(other.sort, sort) &&
            const DeepCollectionEquality().equals(
              other.sortValues,
              sortValues,
            ) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.watch, watch) || other.watch == watch));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(filterConditions),
    const DeepCollectionEquality().hash(filterValues),
    limit,
    const DeepCollectionEquality().hash(memberCustomInclude),
    memberLimit,
    messageLimit,
    offset,
    predefinedFilter,
    presence,
    const DeepCollectionEquality().hash(sort),
    const DeepCollectionEquality().hash(sortValues),
    state,
    watch,
  );

  @override
  String toString() {
    return 'QueryChannelsRequest(filterConditions: $filterConditions, filterValues: $filterValues, limit: $limit, memberCustomInclude: $memberCustomInclude, memberLimit: $memberLimit, messageLimit: $messageLimit, offset: $offset, predefinedFilter: $predefinedFilter, presence: $presence, sort: $sort, sortValues: $sortValues, state: $state, watch: $watch)';
  }
}

/// @nodoc
abstract mixin class $QueryChannelsRequestCopyWith<$Res> {
  factory $QueryChannelsRequestCopyWith(
    QueryChannelsRequest value,
    $Res Function(QueryChannelsRequest) _then,
  ) = _$QueryChannelsRequestCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?>? filterConditions,
    Map<String, Object?>? filterValues,
    int? limit,
    List<String>? memberCustomInclude,
    int? memberLimit,
    int? messageLimit,
    int? offset,
    String? predefinedFilter,
    bool? presence,
    List<SortParamRequest>? sort,
    Map<String, Object?>? sortValues,
    bool? state,
    bool? watch,
  });
}

/// @nodoc
class _$QueryChannelsRequestCopyWithImpl<$Res>
    implements $QueryChannelsRequestCopyWith<$Res> {
  _$QueryChannelsRequestCopyWithImpl(this._self, this._then);

  final QueryChannelsRequest _self;
  final $Res Function(QueryChannelsRequest) _then;

  /// Create a copy of QueryChannelsRequest
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filterConditions = freezed,
    Object? filterValues = freezed,
    Object? limit = freezed,
    Object? memberCustomInclude = freezed,
    Object? memberLimit = freezed,
    Object? messageLimit = freezed,
    Object? offset = freezed,
    Object? predefinedFilter = freezed,
    Object? presence = freezed,
    Object? sort = freezed,
    Object? sortValues = freezed,
    Object? state = freezed,
    Object? watch = freezed,
  }) {
    return _then(
      QueryChannelsRequest(
        filterConditions: freezed == filterConditions
            ? _self.filterConditions
            : filterConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        filterValues: freezed == filterValues
            ? _self.filterValues
            : filterValues // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        memberCustomInclude: freezed == memberCustomInclude
            ? _self.memberCustomInclude
            : memberCustomInclude // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        memberLimit: freezed == memberLimit
            ? _self.memberLimit
            : memberLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
        messageLimit: freezed == messageLimit
            ? _self.messageLimit
            : messageLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
        offset: freezed == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
        predefinedFilter: freezed == predefinedFilter
            ? _self.predefinedFilter
            : predefinedFilter // ignore: cast_nullable_to_non_nullable
                  as String?,
        presence: freezed == presence
            ? _self.presence
            : presence // ignore: cast_nullable_to_non_nullable
                  as bool?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
        sortValues: freezed == sortValues
            ? _self.sortValues
            : sortValues // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        state: freezed == state
            ? _self.state
            : state // ignore: cast_nullable_to_non_nullable
                  as bool?,
        watch: freezed == watch
            ? _self.watch
            : watch // ignore: cast_nullable_to_non_nullable
                  as bool?,
      ),
    );
  }
}
