// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_action_appeals_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkActionAppealsResponse {
  String get duration;
  List<BulkAppealError> get errors;
  List<BulkAppealResult> get results;

  /// Create a copy of BulkActionAppealsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BulkActionAppealsResponseCopyWith<BulkActionAppealsResponse> get copyWith =>
      _$BulkActionAppealsResponseCopyWithImpl<BulkActionAppealsResponse>(
        this as BulkActionAppealsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BulkActionAppealsResponse &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            const DeepCollectionEquality().equals(other.errors, errors) &&
            const DeepCollectionEquality().equals(other.results, results));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    duration,
    const DeepCollectionEquality().hash(errors),
    const DeepCollectionEquality().hash(results),
  );

  @override
  String toString() {
    return 'BulkActionAppealsResponse(duration: $duration, errors: $errors, results: $results)';
  }
}

/// @nodoc
abstract mixin class $BulkActionAppealsResponseCopyWith<$Res> {
  factory $BulkActionAppealsResponseCopyWith(
    BulkActionAppealsResponse value,
    $Res Function(BulkActionAppealsResponse) _then,
  ) = _$BulkActionAppealsResponseCopyWithImpl;
  @useResult
  $Res call({
    String duration,
    List<BulkAppealError> errors,
    List<BulkAppealResult> results,
  });
}

/// @nodoc
class _$BulkActionAppealsResponseCopyWithImpl<$Res>
    implements $BulkActionAppealsResponseCopyWith<$Res> {
  _$BulkActionAppealsResponseCopyWithImpl(this._self, this._then);

  final BulkActionAppealsResponse _self;
  final $Res Function(BulkActionAppealsResponse) _then;

  /// Create a copy of BulkActionAppealsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? duration = null,
    Object? errors = null,
    Object? results = null,
  }) {
    return _then(
      BulkActionAppealsResponse(
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
        errors: null == errors
            ? _self.errors
            : errors // ignore: cast_nullable_to_non_nullable
                  as List<BulkAppealError>,
        results: null == results
            ? _self.results
            : results // ignore: cast_nullable_to_non_nullable
                  as List<BulkAppealResult>,
      ),
    );
  }
}
