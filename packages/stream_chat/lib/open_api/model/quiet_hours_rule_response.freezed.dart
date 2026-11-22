// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiet_hours_rule_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$QuietHoursRuleResponse {
  List<String>? get days;
  String get end;
  String get start;

  /// Create a copy of QuietHoursRuleResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuietHoursRuleResponseCopyWith<QuietHoursRuleResponse> get copyWith =>
      _$QuietHoursRuleResponseCopyWithImpl<QuietHoursRuleResponse>(
        this as QuietHoursRuleResponse,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuietHoursRuleResponse &&
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
    return 'QuietHoursRuleResponse(days: $days, end: $end, start: $start)';
  }
}

/// @nodoc
abstract mixin class $QuietHoursRuleResponseCopyWith<$Res> {
  factory $QuietHoursRuleResponseCopyWith(
    QuietHoursRuleResponse value,
    $Res Function(QuietHoursRuleResponse) _then,
  ) = _$QuietHoursRuleResponseCopyWithImpl;
  @useResult
  $Res call({List<String>? days, String end, String start});
}

/// @nodoc
class _$QuietHoursRuleResponseCopyWithImpl<$Res> implements $QuietHoursRuleResponseCopyWith<$Res> {
  _$QuietHoursRuleResponseCopyWithImpl(this._self, this._then);

  final QuietHoursRuleResponse _self;
  final $Res Function(QuietHoursRuleResponse) _then;

  /// Create a copy of QuietHoursRuleResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? days = freezed,
    Object? end = null,
    Object? start = null,
  }) {
    return _then(
      QuietHoursRuleResponse(
        days: freezed == days
            ? _self.days
            : days // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
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
