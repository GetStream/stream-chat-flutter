// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'unblock_action_request_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UnblockActionRequestPayload {
  String? get decisionReason;

  /// Create a copy of UnblockActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UnblockActionRequestPayloadCopyWith<UnblockActionRequestPayload>
  get copyWith =>
      _$UnblockActionRequestPayloadCopyWithImpl<UnblockActionRequestPayload>(
        this as UnblockActionRequestPayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UnblockActionRequestPayload &&
            (identical(other.decisionReason, decisionReason) ||
                other.decisionReason == decisionReason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, decisionReason);

  @override
  String toString() {
    return 'UnblockActionRequestPayload(decisionReason: $decisionReason)';
  }
}

/// @nodoc
abstract mixin class $UnblockActionRequestPayloadCopyWith<$Res> {
  factory $UnblockActionRequestPayloadCopyWith(
    UnblockActionRequestPayload value,
    $Res Function(UnblockActionRequestPayload) _then,
  ) = _$UnblockActionRequestPayloadCopyWithImpl;
  @useResult
  $Res call({String? decisionReason});
}

/// @nodoc
class _$UnblockActionRequestPayloadCopyWithImpl<$Res>
    implements $UnblockActionRequestPayloadCopyWith<$Res> {
  _$UnblockActionRequestPayloadCopyWithImpl(this._self, this._then);

  final UnblockActionRequestPayload _self;
  final $Res Function(UnblockActionRequestPayload) _then;

  /// Create a copy of UnblockActionRequestPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? decisionReason = freezed}) {
    return _then(
      UnblockActionRequestPayload(
        decisionReason: freezed == decisionReason
            ? _self.decisionReason
            : decisionReason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
