// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'push_schedule_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PushScheduleResponse {
  List<QuietHoursRuleResponse> get quietHours;
  String get timezone;

  /// Create a copy of PushScheduleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PushScheduleResponseCopyWith<PushScheduleResponse> get copyWith =>
      _$PushScheduleResponseCopyWithImpl<PushScheduleResponse>(
        this as PushScheduleResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PushScheduleResponse &&
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
    return 'PushScheduleResponse(quietHours: $quietHours, timezone: $timezone)';
  }
}

/// @nodoc
abstract mixin class $PushScheduleResponseCopyWith<$Res> {
  factory $PushScheduleResponseCopyWith(
    PushScheduleResponse value,
    $Res Function(PushScheduleResponse) _then,
  ) = _$PushScheduleResponseCopyWithImpl;
  @useResult
  $Res call({List<QuietHoursRuleResponse> quietHours, String timezone});
}

/// @nodoc
class _$PushScheduleResponseCopyWithImpl<$Res> implements $PushScheduleResponseCopyWith<$Res> {
  _$PushScheduleResponseCopyWithImpl(this._self, this._then);

  final PushScheduleResponse _self;
  final $Res Function(PushScheduleResponse) _then;

  /// Create a copy of PushScheduleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? quietHours = null, Object? timezone = null}) {
    return _then(
      PushScheduleResponse(
        quietHours: null == quietHours
            ? _self.quietHours
            : quietHours // ignore: cast_nullable_to_non_nullable
                  as List<QuietHoursRuleResponse>,
        timezone: null == timezone
            ? _self.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
