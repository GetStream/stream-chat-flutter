// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_custom_property_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentCustomPropertyParameters {
  String? get operator;
  String? get propertyKey;

  /// Create a copy of ContentCustomPropertyParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContentCustomPropertyParametersCopyWith<ContentCustomPropertyParameters> get copyWith =>
      _$ContentCustomPropertyParametersCopyWithImpl<ContentCustomPropertyParameters>(
        this as ContentCustomPropertyParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContentCustomPropertyParameters &&
            (identical(other.operator, operator) || other.operator == operator) &&
            (identical(other.propertyKey, propertyKey) || other.propertyKey == propertyKey));
  }

  @override
  int get hashCode => Object.hash(runtimeType, operator, propertyKey);

  @override
  String toString() {
    return 'ContentCustomPropertyParameters(operator: $operator, propertyKey: $propertyKey)';
  }
}

/// @nodoc
abstract mixin class $ContentCustomPropertyParametersCopyWith<$Res> {
  factory $ContentCustomPropertyParametersCopyWith(
    ContentCustomPropertyParameters value,
    $Res Function(ContentCustomPropertyParameters) _then,
  ) = _$ContentCustomPropertyParametersCopyWithImpl;
  @useResult
  $Res call({String? operator, String? propertyKey});
}

/// @nodoc
class _$ContentCustomPropertyParametersCopyWithImpl<$Res> implements $ContentCustomPropertyParametersCopyWith<$Res> {
  _$ContentCustomPropertyParametersCopyWithImpl(this._self, this._then);

  final ContentCustomPropertyParameters _self;
  final $Res Function(ContentCustomPropertyParameters) _then;

  /// Create a copy of ContentCustomPropertyParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? operator = freezed, Object? propertyKey = freezed}) {
    return _then(
      ContentCustomPropertyParameters(
        operator: freezed == operator
            ? _self.operator
            : operator // ignore: cast_nullable_to_non_nullable
                  as String?,
        propertyKey: freezed == propertyKey
            ? _self.propertyKey
            : propertyKey // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
