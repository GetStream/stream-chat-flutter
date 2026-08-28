// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delete_action_config_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeleteActionConfigResponse {
  int get deleted;
  String get duration;

  /// Create a copy of DeleteActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeleteActionConfigResponseCopyWith<DeleteActionConfigResponse>
  get copyWith =>
      _$DeleteActionConfigResponseCopyWithImpl<DeleteActionConfigResponse>(
        this as DeleteActionConfigResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeleteActionConfigResponse &&
            (identical(other.deleted, deleted) || other.deleted == deleted) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @override
  int get hashCode => Object.hash(runtimeType, deleted, duration);

  @override
  String toString() {
    return 'DeleteActionConfigResponse(deleted: $deleted, duration: $duration)';
  }
}

/// @nodoc
abstract mixin class $DeleteActionConfigResponseCopyWith<$Res> {
  factory $DeleteActionConfigResponseCopyWith(
    DeleteActionConfigResponse value,
    $Res Function(DeleteActionConfigResponse) _then,
  ) = _$DeleteActionConfigResponseCopyWithImpl;
  @useResult
  $Res call({int deleted, String duration});
}

/// @nodoc
class _$DeleteActionConfigResponseCopyWithImpl<$Res>
    implements $DeleteActionConfigResponseCopyWith<$Res> {
  _$DeleteActionConfigResponseCopyWithImpl(this._self, this._then);

  final DeleteActionConfigResponse _self;
  final $Res Function(DeleteActionConfigResponse) _then;

  /// Create a copy of DeleteActionConfigResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? deleted = null, Object? duration = null}) {
    return _then(
      DeleteActionConfigResponse(
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
