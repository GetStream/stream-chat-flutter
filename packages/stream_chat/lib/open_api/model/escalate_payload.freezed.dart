// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalate_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EscalatePayload {
  String? get notes;
  String? get priority;
  String? get reason;

  /// Create a copy of EscalatePayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EscalatePayloadCopyWith<EscalatePayload> get copyWith =>
      _$EscalatePayloadCopyWithImpl<EscalatePayload>(
        this as EscalatePayload,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EscalatePayload &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, notes, priority, reason);

  @override
  String toString() {
    return 'EscalatePayload(notes: $notes, priority: $priority, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $EscalatePayloadCopyWith<$Res> {
  factory $EscalatePayloadCopyWith(
    EscalatePayload value,
    $Res Function(EscalatePayload) _then,
  ) = _$EscalatePayloadCopyWithImpl;
  @useResult
  $Res call({String? notes, String? priority, String? reason});
}

/// @nodoc
class _$EscalatePayloadCopyWithImpl<$Res>
    implements $EscalatePayloadCopyWith<$Res> {
  _$EscalatePayloadCopyWithImpl(this._self, this._then);

  final EscalatePayload _self;
  final $Res Function(EscalatePayload) _then;

  /// Create a copy of EscalatePayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = freezed,
    Object? priority = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      EscalatePayload(
        notes: freezed == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        priority: freezed == priority
            ? _self.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as String?,
        reason: freezed == reason
            ? _self.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
