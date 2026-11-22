// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_schedule_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushScheduleInput {
  List<QuietHoursRuleInput>? get quietHours;
  String? get timezone;

  /// Create a copy of PushScheduleInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PushScheduleInputCopyWith<PushScheduleInput> get copyWith => _$PushScheduleInputCopyWithImpl<PushScheduleInput>(
    this as PushScheduleInput,
    _$identity,
  );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PushScheduleInput &&
            const DeepCollectionEquality().equals(
              other.quietHours,
              quietHours,
            ) &&
            (identical(other.timezone, timezone) || other.timezone == timezone));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(quietHours),
    timezone,
  );

  @override
  String toString() {
    return 'PushScheduleInput(quietHours: $quietHours, timezone: $timezone)';
  }
}

/// @nodoc
abstract mixin class $PushScheduleInputCopyWith<$Res> {
  factory $PushScheduleInputCopyWith(
    PushScheduleInput value,
    $Res Function(PushScheduleInput) _then,
  ) = _$PushScheduleInputCopyWithImpl;
  @useResult
  $Res call({List<QuietHoursRuleInput>? quietHours, String? timezone});
}

/// @nodoc
class _$PushScheduleInputCopyWithImpl<$Res> implements $PushScheduleInputCopyWith<$Res> {
  _$PushScheduleInputCopyWithImpl(this._self, this._then);

  final PushScheduleInput _self;
  final $Res Function(PushScheduleInput) _then;

  /// Create a copy of PushScheduleInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quietHours = freezed, Object? timezone = freezed}) {
    return _then(
      PushScheduleInput(
        quietHours: freezed == quietHours
            ? _self.quietHours
            : quietHours // ignore: cast_nullable_to_non_nullable
                  as List<QuietHoursRuleInput>?,
        timezone: freezed == timezone
            ? _self.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
