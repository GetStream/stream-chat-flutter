// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchPayload {
  Map<String, Object?> get filterConditions;
  bool? get forceDefaultSearch;
  bool? get forceSqlV2Backend;
  int? get limit;
  Map<String, Object?>? get messageFilterConditions;
  MessageOptions? get messageOptions;
  String? get next;
  int? get offset;
  String? get query;
  List<SortParamRequest>? get sort;

  /// Create a copy of SearchPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchPayloadCopyWith<SearchPayload> get copyWith => _$SearchPayloadCopyWithImpl<SearchPayload>(
    this as SearchPayload,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchPayload &&
            const DeepCollectionEquality().equals(
              other.filterConditions,
              filterConditions,
            ) &&
            (identical(other.forceDefaultSearch, forceDefaultSearch) ||
                other.forceDefaultSearch == forceDefaultSearch) &&
            (identical(other.forceSqlV2Backend, forceSqlV2Backend) || other.forceSqlV2Backend == forceSqlV2Backend) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            const DeepCollectionEquality().equals(
              other.messageFilterConditions,
              messageFilterConditions,
            ) &&
            (identical(other.messageOptions, messageOptions) || other.messageOptions == messageOptions) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.query, query) || other.query == query) &&
            const DeepCollectionEquality().equals(other.sort, sort));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(filterConditions),
    forceDefaultSearch,
    forceSqlV2Backend,
    limit,
    const DeepCollectionEquality().hash(messageFilterConditions),
    messageOptions,
    next,
    offset,
    query,
    const DeepCollectionEquality().hash(sort),
  );

  @override
  String toString() {
    return 'SearchPayload(filterConditions: $filterConditions, forceDefaultSearch: $forceDefaultSearch, forceSqlV2Backend: $forceSqlV2Backend, limit: $limit, messageFilterConditions: $messageFilterConditions, messageOptions: $messageOptions, next: $next, offset: $offset, query: $query, sort: $sort)';
  }
}

/// @nodoc
abstract mixin class $SearchPayloadCopyWith<$Res> {
  factory $SearchPayloadCopyWith(
    SearchPayload value,
    $Res Function(SearchPayload) _then,
  ) = _$SearchPayloadCopyWithImpl;
  @useResult
  $Res call({
    Map<String, Object?> filterConditions,
    bool? forceDefaultSearch,
    bool? forceSqlV2Backend,
    int? limit,
    Map<String, Object?>? messageFilterConditions,
    MessageOptions? messageOptions,
    String? next,
    int? offset,
    String? query,
    List<SortParamRequest>? sort,
  });
}

/// @nodoc
class _$SearchPayloadCopyWithImpl<$Res> implements $SearchPayloadCopyWith<$Res> {
  _$SearchPayloadCopyWithImpl(this._self, this._then);

  final SearchPayload _self;
  final $Res Function(SearchPayload) _then;

  /// Create a copy of SearchPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? filterConditions = null,
    Object? forceDefaultSearch = freezed,
    Object? forceSqlV2Backend = freezed,
    Object? limit = freezed,
    Object? messageFilterConditions = freezed,
    Object? messageOptions = freezed,
    Object? next = freezed,
    Object? offset = freezed,
    Object? query = freezed,
    Object? sort = freezed,
  }) {
    return _then(
      SearchPayload(
        filterConditions: null == filterConditions
            ? _self.filterConditions
            : filterConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>,
        forceDefaultSearch: freezed == forceDefaultSearch
            ? _self.forceDefaultSearch
            : forceDefaultSearch // ignore: cast_nullable_to_non_nullable
                  as bool?,
        forceSqlV2Backend: freezed == forceSqlV2Backend
            ? _self.forceSqlV2Backend
            : forceSqlV2Backend // ignore: cast_nullable_to_non_nullable
                  as bool?,
        limit: freezed == limit
            ? _self.limit
            : limit // ignore: cast_nullable_to_non_nullable
                  as int?,
        messageFilterConditions: freezed == messageFilterConditions
            ? _self.messageFilterConditions
            : messageFilterConditions // ignore: cast_nullable_to_non_nullable
                  as Map<String, Object?>?,
        messageOptions: freezed == messageOptions
            ? _self.messageOptions
            : messageOptions // ignore: cast_nullable_to_non_nullable
                  as MessageOptions?,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        offset: freezed == offset
            ? _self.offset
            : offset // ignore: cast_nullable_to_non_nullable
                  as int?,
        query: freezed == query
            ? _self.query
            : query // ignore: cast_nullable_to_non_nullable
                  as String?,
        sort: freezed == sort
            ? _self.sort
            : sort // ignore: cast_nullable_to_non_nullable
                  as List<SortParamRequest>?,
      ),
    );
  }
}
