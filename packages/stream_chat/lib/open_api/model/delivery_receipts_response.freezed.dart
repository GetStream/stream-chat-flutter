// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'delivery_receipts_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DeliveryReceiptsResponse {
  bool get enabled;

  /// Create a copy of DeliveryReceiptsResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DeliveryReceiptsResponseCopyWith<DeliveryReceiptsResponse> get copyWith =>
      _$DeliveryReceiptsResponseCopyWithImpl<DeliveryReceiptsResponse>(
        this as DeliveryReceiptsResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DeliveryReceiptsResponse &&
            (identical(other.enabled, enabled) || other.enabled == enabled));
  }

  @override
  int get hashCode => Object.hash(runtimeType, enabled);

  @override
  String toString() {
    return 'DeliveryReceiptsResponse(enabled: $enabled)';
  }
}

/// @nodoc
abstract mixin class $DeliveryReceiptsResponseCopyWith<$Res> {
  factory $DeliveryReceiptsResponseCopyWith(
    DeliveryReceiptsResponse value,
    $Res Function(DeliveryReceiptsResponse) _then,
  ) = _$DeliveryReceiptsResponseCopyWithImpl;
  @useResult
  $Res call({bool enabled});
}

/// @nodoc
class _$DeliveryReceiptsResponseCopyWithImpl<$Res> implements $DeliveryReceiptsResponseCopyWith<$Res> {
  _$DeliveryReceiptsResponseCopyWithImpl(this._self, this._then);

  final DeliveryReceiptsResponse _self;
  final $Res Function(DeliveryReceiptsResponse) _then;

  /// Create a copy of DeliveryReceiptsResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? enabled = null}) {
    return _then(
      DeliveryReceiptsResponse(
        enabled: null == enabled
            ? _self.enabled
            : enabled // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
