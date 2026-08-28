// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_custom_property_count_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentCustomPropertyCountParameters {
  String? get operator;
  String? get propertyKey;
  int? get threshold;
  String? get timeWindow;

  /// Create a copy of ContentCustomPropertyCountParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContentCustomPropertyCountParametersCopyWith<
    ContentCustomPropertyCountParameters
  >
  get copyWith =>
      _$ContentCustomPropertyCountParametersCopyWithImpl<
        ContentCustomPropertyCountParameters
      >(this as ContentCustomPropertyCountParameters, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContentCustomPropertyCountParameters &&
            (identical(other.operator, operator) ||
                other.operator == operator) &&
            (identical(other.propertyKey, propertyKey) ||
                other.propertyKey == propertyKey) &&
            (identical(other.threshold, threshold) ||
                other.threshold == threshold) &&
            (identical(other.timeWindow, timeWindow) ||
                other.timeWindow == timeWindow));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, operator, propertyKey, threshold, timeWindow);

  @override
  String toString() {
    return 'ContentCustomPropertyCountParameters(operator: $operator, propertyKey: $propertyKey, threshold: $threshold, timeWindow: $timeWindow)';
  }
}

/// @nodoc
abstract mixin class $ContentCustomPropertyCountParametersCopyWith<$Res> {
  factory $ContentCustomPropertyCountParametersCopyWith(
    ContentCustomPropertyCountParameters value,
    $Res Function(ContentCustomPropertyCountParameters) _then,
  ) = _$ContentCustomPropertyCountParametersCopyWithImpl;
  @useResult
  $Res call({
    String? operator,
    String? propertyKey,
    int? threshold,
    String? timeWindow,
  });
}

/// @nodoc
class _$ContentCustomPropertyCountParametersCopyWithImpl<$Res>
    implements $ContentCustomPropertyCountParametersCopyWith<$Res> {
  _$ContentCustomPropertyCountParametersCopyWithImpl(this._self, this._then);

  final ContentCustomPropertyCountParameters _self;
  final $Res Function(ContentCustomPropertyCountParameters) _then;

  /// Create a copy of ContentCustomPropertyCountParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? operator = freezed,
    Object? propertyKey = freezed,
    Object? threshold = freezed,
    Object? timeWindow = freezed,
  }) {
    return _then(
      ContentCustomPropertyCountParameters(
        operator: freezed == operator
            ? _self.operator
            : operator // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyKey: freezed == propertyKey
            ? _self.propertyKey
            : propertyKey // ignore: cast_nullable_to_non_nullable
                  as String?,
        threshold: freezed == threshold
            ? _self.threshold
            : threshold // ignore: cast_nullable_to_non_nullable
                  as int?,
        timeWindow: freezed == timeWindow
            ? _self.timeWindow
            : timeWindow // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
