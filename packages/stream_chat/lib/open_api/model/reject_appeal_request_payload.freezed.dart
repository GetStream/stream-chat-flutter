// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reject_appeal_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RejectAppealRequestPayload {
  String get decisionReason;

  /// Create a copy of RejectAppealRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RejectAppealRequestPayloadCopyWith<RejectAppealRequestPayload>
  get copyWith =>
      _$RejectAppealRequestPayloadCopyWithImpl<RejectAppealRequestPayload>(
        this as RejectAppealRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RejectAppealRequestPayload &&
            (identical(other.decisionReason, decisionReason) ||
                other.decisionReason == decisionReason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, decisionReason);

  @override
  String toString() {
    return 'RejectAppealRequestPayload(decisionReason: $decisionReason)';
  }
}

/// @nodoc
abstract mixin class $RejectAppealRequestPayloadCopyWith<$Res> {
  factory $RejectAppealRequestPayloadCopyWith(
    RejectAppealRequestPayload value,
    $Res Function(RejectAppealRequestPayload) _then,
  ) = _$RejectAppealRequestPayloadCopyWithImpl;
  @useResult
  $Res call({String decisionReason});
}

/// @nodoc
class _$RejectAppealRequestPayloadCopyWithImpl<$Res>
    implements $RejectAppealRequestPayloadCopyWith<$Res> {
  _$RejectAppealRequestPayloadCopyWithImpl(this._self, this._then);

  final RejectAppealRequestPayload _self;
  final $Res Function(RejectAppealRequestPayload) _then;

  /// Create a copy of RejectAppealRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? decisionReason = null}) {
    return _then(
      RejectAppealRequestPayload(
        decisionReason: null == decisionReason
            ? _self.decisionReason
            : decisionReason // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
