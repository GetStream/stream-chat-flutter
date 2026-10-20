// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_messages_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchMessagesResponse {
  String get duration;
  List<SearchMessageResult> get results;
  String? get next;
  String? get previous;

  /// Create a copy of SearchMessagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SearchMessagesResponseCopyWith<SearchMessagesResponse> get copyWith =>
      _$SearchMessagesResponseCopyWithImpl<SearchMessagesResponse>(this as SearchMessagesResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SearchMessagesResponse &&
            (identical(other.duration, duration) || other.duration == duration) &&
            const DeepCollectionEquality().equals(other.results, results) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.previous, previous) || other.previous == previous));
  }

  @override
  int get hashCode => Object.hash(runtimeType, duration, const DeepCollectionEquality().hash(results), next, previous);

  @override
  String toString() {
    return 'SearchMessagesResponse(duration: $duration, results: $results, next: $next, previous: $previous)';
  }
}

/// @nodoc
abstract mixin class $SearchMessagesResponseCopyWith<$Res> {
  factory $SearchMessagesResponseCopyWith(SearchMessagesResponse value, $Res Function(SearchMessagesResponse) _then) =
      _$SearchMessagesResponseCopyWithImpl;
  @useResult
  $Res call({String duration, List<SearchMessageResult> results, String? next, String? previous});
}

/// @nodoc
class _$SearchMessagesResponseCopyWithImpl<$Res> implements $SearchMessagesResponseCopyWith<$Res> {
  _$SearchMessagesResponseCopyWithImpl(this._self, this._then);

  final SearchMessagesResponse _self;
  final $Res Function(SearchMessagesResponse) _then;

  /// Create a copy of SearchMessagesResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? duration = null, Object? results = null, Object? next = freezed, Object? previous = freezed}) {
    return _then(
      SearchMessagesResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        results: null == results
            ? _self.results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<SearchMessageResult>,
        next: freezed == next
            ? _self.next
            : next // ignore: cast_nullable_to_non_nullable
                  as String?,
        previous: freezed == previous
            ? _self.previous
            : previous // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
