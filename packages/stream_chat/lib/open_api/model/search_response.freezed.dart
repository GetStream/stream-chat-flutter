// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchResponse {
  String get duration;
  String? get next;
  String? get previous;
  List<SearchResult> get results;
  SearchWarning? get resultsWarning;

  /// Create a copy of SearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchResponseCopyWith<SearchResponse> get copyWith => _$SearchResponseCopyWithImpl<SearchResponse>(
    this as SearchResponse,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.previous, previous) || other.previous == previous) &&
            const DeepCollectionEquality().equals(other.results, results) &&
            (identical(other.resultsWarning, resultsWarning) || other.resultsWarning == resultsWarning));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    next,
    previous,
    const DeepCollectionEquality().hash(results),
    resultsWarning,
  );

  @override
  String toString() {
    return 'SearchResponse(duration: $duration, next: $next, previous: $previous, results: $results, resultsWarning: $resultsWarning)';
  }
}

/// @nodoc
abstract mixin class $SearchResponseCopyWith<$Res> {
  factory $SearchResponseCopyWith(
    SearchResponse value,
    $Res Function(SearchResponse) _then,
  ) = _$SearchResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    String? next,
    String? previous,
    List<SearchResult> results,
    SearchWarning? resultsWarning,
  });
}

/// @nodoc
class _$SearchResponseCopyWithImpl<$Res> implements $SearchResponseCopyWith<$Res> {
  _$SearchResponseCopyWithImpl(this._self, this._then);

  final SearchResponse _self;
  final $Res Function(SearchResponse) _then;

  /// Create a copy of SearchResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? next = freezed,
    Object? previous = freezed,
    Object? results = null,
    Object? resultsWarning = freezed,
  }) {
    return _then(
      SearchResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        previous: freezed == previous
            ? _self.previous
            : previous // ignore: cast_nullable_to_non_nullable
                  as String?,
        results: null == results
            ? _self.results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<SearchResult>,
        resultsWarning: freezed == resultsWarning
            ? _self.resultsWarning
            : resultsWarning // ignore: cast_nullable_to_non_nullable
                  as SearchWarning?,
      ),
    );
  }
}
