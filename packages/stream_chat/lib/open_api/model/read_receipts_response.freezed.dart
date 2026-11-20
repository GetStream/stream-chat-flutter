// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'read_receipts_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ReadReceiptsResponse {
  bool get enabled;

  /// Create a copy of ReadReceiptsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ReadReceiptsResponseCopyWith<ReadReceiptsResponse> get copyWith =>
      _$ReadReceiptsResponseCopyWithImpl<ReadReceiptsResponse>(
        this as ReadReceiptsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ReadReceiptsResponse &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled);

  @override
  String toString() {
    return 'ReadReceiptsResponse(enabled: $enabled)';
  }
}

/// @nodoc
abstract mixin class $ReadReceiptsResponseCopyWith<$Res> {
  factory $ReadReceiptsResponseCopyWith(
    ReadReceiptsResponse value,
    $Res Function(ReadReceiptsResponse) _then,
  ) = _$ReadReceiptsResponseCopyWithImpl;
  @useResult
  $Res call({bool enabled});
}

/// @nodoc
class _$ReadReceiptsResponseCopyWithImpl<$Res> implements $ReadReceiptsResponseCopyWith<$Res> {
  _$ReadReceiptsResponseCopyWithImpl(this._self, this._then);

  final ReadReceiptsResponse _self;
  final $Res Function(ReadReceiptsResponse) _then;

  /// Create a copy of ReadReceiptsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? enabled = null}) {
    return _then(
      ReadReceiptsResponse(
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
