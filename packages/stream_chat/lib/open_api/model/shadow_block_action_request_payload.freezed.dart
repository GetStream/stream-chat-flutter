// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shadow_block_action_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShadowBlockActionRequestPayload {
  String? get reason;

  /// Create a copy of ShadowBlockActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ShadowBlockActionRequestPayloadCopyWith<ShadowBlockActionRequestPayload>
  get copyWith =>
      _$ShadowBlockActionRequestPayloadCopyWithImpl<
        ShadowBlockActionRequestPayload
      >(this as ShadowBlockActionRequestPayload, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ShadowBlockActionRequestPayload &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, reason);

  @override
  String toString() {
    return 'ShadowBlockActionRequestPayload(reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $ShadowBlockActionRequestPayloadCopyWith<$Res> {
  factory $ShadowBlockActionRequestPayloadCopyWith(
    ShadowBlockActionRequestPayload value,
    $Res Function(ShadowBlockActionRequestPayload) _then,
  ) = _$ShadowBlockActionRequestPayloadCopyWithImpl;
  @useResult
  $Res call({String? reason});
}

/// @nodoc
class _$ShadowBlockActionRequestPayloadCopyWithImpl<$Res>
    implements $ShadowBlockActionRequestPayloadCopyWith<$Res> {
  _$ShadowBlockActionRequestPayloadCopyWithImpl(this._self, this._then);

  final ShadowBlockActionRequestPayload _self;
  final $Res Function(ShadowBlockActionRequestPayload) _then;

  /// Create a copy of ShadowBlockActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? reason = freezed}) {
    return _then(
      ShadowBlockActionRequestPayload(
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
