// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_appeal_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkAppealError {
  String get appealId;
  String get error;

  /// Create a copy of BulkAppealError
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BulkAppealErrorCopyWith<BulkAppealError> get copyWith =>
      _$BulkAppealErrorCopyWithImpl<BulkAppealError>(
        this as BulkAppealError,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BulkAppealError &&
            (identical(other.appealId, appealId) ||
                other.appealId == appealId) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, appealId, error);

  @override
  String toString() {
    return 'BulkAppealError(appealId: $appealId, error: $error)';
  }
}

/// @nodoc
abstract mixin class $BulkAppealErrorCopyWith<$Res> {
  factory $BulkAppealErrorCopyWith(
    BulkAppealError value,
    $Res Function(BulkAppealError) _then,
  ) = _$BulkAppealErrorCopyWithImpl;
  @useResult
  $Res call({String appealId, String error});
}

/// @nodoc
class _$BulkAppealErrorCopyWithImpl<$Res>
    implements $BulkAppealErrorCopyWith<$Res> {
  _$BulkAppealErrorCopyWithImpl(this._self, this._then);

  final BulkAppealError _self;
  final $Res Function(BulkAppealError) _then;

  /// Create a copy of BulkAppealError
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? appealId = null, Object? error = null}) {
    return _then(
      BulkAppealError(
        appealId: null == appealId
            ? _self.appealId
            : appealId // ignore: cast_nullable_to_non_nullable
                  as String,
        error: null == error
            ? _self.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
