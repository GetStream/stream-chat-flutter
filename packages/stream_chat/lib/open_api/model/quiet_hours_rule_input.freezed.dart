// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiet_hours_rule_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuietHoursRuleInput {
  List<QuietHoursRuleInputDays>? get days;
  String get end;
  String get start;

  /// Create a copy of QuietHoursRuleInput
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuietHoursRuleInputCopyWith<QuietHoursRuleInput> get copyWith =>
      _$QuietHoursRuleInputCopyWithImpl<QuietHoursRuleInput>(
        this as QuietHoursRuleInput,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuietHoursRuleInput &&
            const DeepCollectionEquality().equals(other.days, days) &&
            (identical(other.end, end) || other.end == end) &&
            (identical(other.start, start) || other.start == start));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(days),
    end,
    start,
  );

  @override
  String toString() {
    return 'QuietHoursRuleInput(days: $days, end: $end, start: $start)';
  }
}

/// @nodoc
abstract mixin class $QuietHoursRuleInputCopyWith<$Res> {
  factory $QuietHoursRuleInputCopyWith(
    QuietHoursRuleInput value,
    $Res Function(QuietHoursRuleInput) _then,
  ) = _$QuietHoursRuleInputCopyWithImpl;
  @useResult
  $Res call({List<QuietHoursRuleInputDays>? days, String end, String start});
}

/// @nodoc
class _$QuietHoursRuleInputCopyWithImpl<$Res> implements $QuietHoursRuleInputCopyWith<$Res> {
  _$QuietHoursRuleInputCopyWithImpl(this._self, this._then);

  final QuietHoursRuleInput _self;
  final $Res Function(QuietHoursRuleInput) _then;

  /// Create a copy of QuietHoursRuleInput
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = freezed,
    Object? end = null,
    Object? start = null,
  }) {
    return _then(
      QuietHoursRuleInput(
        days: freezed == days
            ? _self.days
            : days // ignore: cast_nullable_to_non_nullable
                  as List<QuietHoursRuleInputDays>?,
        end: null == end
            ? _self.end
            : end // ignore: cast_nullable_to_non_nullable
                  as String,
        start: null == start
            ? _self.start
            : start // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
