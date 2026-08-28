// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'escalation_metadata.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EscalationMetadata {
  String? get notes;
  String? get priority;
  String? get reason;

  /// Create a copy of EscalationMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EscalationMetadataCopyWith<EscalationMetadata> get copyWith =>
      _$EscalationMetadataCopyWithImpl<EscalationMetadata>(
        this as EscalationMetadata,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EscalationMetadata &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @override
  int get hashCode => Object.hash(runtimeType, notes, priority, reason);

  @override
  String toString() {
    return 'EscalationMetadata(notes: $notes, priority: $priority, reason: $reason)';
  }
}

/// @nodoc
abstract mixin class $EscalationMetadataCopyWith<$Res> {
  factory $EscalationMetadataCopyWith(
    EscalationMetadata value,
    $Res Function(EscalationMetadata) _then,
  ) = _$EscalationMetadataCopyWithImpl;
  @useResult
  $Res call({String? notes, String? priority, String? reason});
}

/// @nodoc
class _$EscalationMetadataCopyWithImpl<$Res>
    implements $EscalationMetadataCopyWith<$Res> {
  _$EscalationMetadataCopyWithImpl(this._self, this._then);

  final EscalationMetadata _self;
  final $Res Function(EscalationMetadata) _then;

  /// Create a copy of EscalationMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? notes = freezed,
    Object? priority = freezed,
    Object? reason = freezed,
  }) {
    return _then(
      EscalationMetadata(
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
