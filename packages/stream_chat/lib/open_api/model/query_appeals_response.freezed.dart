// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'query_appeals_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QueryAppealsResponse {
  String get duration;
  List<AppealItemResponse> get items;
  String? get next;
  String? get prev;

  /// Create a copy of QueryAppealsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QueryAppealsResponseCopyWith<QueryAppealsResponse> get copyWith =>
      _$QueryAppealsResponseCopyWithImpl<QueryAppealsResponse>(
        this as QueryAppealsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QueryAppealsResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.items, items) &&
            (identical(other.next, next) || other.next == next) &&
            (identical(other.prev, prev) || other.prev == prev));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(items),
    next,
    prev,
  );

  @override
  String toString() {
    return 'QueryAppealsResponse(duration: $duration, items: $items, next: $next, prev: $prev)';
  }
}

/// @nodoc
abstract mixin class $QueryAppealsResponseCopyWith<$Res> {
  factory $QueryAppealsResponseCopyWith(
    QueryAppealsResponse value,
    $Res Function(QueryAppealsResponse) _then,
  ) = _$QueryAppealsResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    List<AppealItemResponse> items,
    String? next,
    String? prev,
  });
}

/// @nodoc
class _$QueryAppealsResponseCopyWithImpl<$Res>
    implements $QueryAppealsResponseCopyWith<$Res> {
  _$QueryAppealsResponseCopyWithImpl(this._self, this._then);

  final QueryAppealsResponse _self;
  final $Res Function(QueryAppealsResponse) _then;

  /// Create a copy of QueryAppealsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? items = null,
    Object? next = freezed,
    Object? prev = freezed,
  }) {
    return _then(
      QueryAppealsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        items: null == items
            ? _self.items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<AppealItemResponse>,
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
