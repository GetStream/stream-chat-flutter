// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bulk_delete_action_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BulkDeleteActionConfigResponse {
  int get deleted;
  String get duration;

  /// Create a copy of BulkDeleteActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BulkDeleteActionConfigResponseCopyWith<BulkDeleteActionConfigResponse>
  get copyWith =>
      _$BulkDeleteActionConfigResponseCopyWithImpl<
        BulkDeleteActionConfigResponse
      >(this as BulkDeleteActionConfigResponse, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BulkDeleteActionConfigResponse &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, deleted, duration);

  @override
  String toString() {
    return 'BulkDeleteActionConfigResponse(deleted: $deleted, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $BulkDeleteActionConfigResponseCopyWith<$Res> {
  factory $BulkDeleteActionConfigResponseCopyWith(
    BulkDeleteActionConfigResponse value,
    $Res Function(BulkDeleteActionConfigResponse) _then,
  ) = _$BulkDeleteActionConfigResponseCopyWithImpl;
  @useResult
  $Res call({int deleted, String duration});
}

/// @nodoc
class _$BulkDeleteActionConfigResponseCopyWithImpl<$Res>
    implements $BulkDeleteActionConfigResponseCopyWith<$Res> {
  _$BulkDeleteActionConfigResponseCopyWithImpl(this._self, this._then);

  final BulkDeleteActionConfigResponse _self;
  final $Res Function(BulkDeleteActionConfigResponse) _then;

  /// Create a copy of BulkDeleteActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? deleted = null, Object? duration = null}) {
    return _then(
      BulkDeleteActionConfigResponse(
        deleted: null == deleted
            ? _self.deleted
            : deleted // ignore: cast_nullable_to_non_nullable
                  as int,
        duration: null == duration
            ? _self.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
