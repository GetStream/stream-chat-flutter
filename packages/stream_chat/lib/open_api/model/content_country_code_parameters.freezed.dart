// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'content_country_code_parameters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ContentCountryCodeParameters {
  List<String>? get countryCodes;
  String? get operator;

  /// Create a copy of ContentCountryCodeParameters
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ContentCountryCodeParametersCopyWith<ContentCountryCodeParameters> get copyWith =>
      _$ContentCountryCodeParametersCopyWithImpl<ContentCountryCodeParameters>(
        this as ContentCountryCodeParameters,
        _$identity,
      );

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ContentCountryCodeParameters &&
            const DeepCollectionEquality().equals(
              other.countryCodes,
              countryCodes,
            ) &&
            (identical(other.operator, operator) || other.operator == operator));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    const DeepCollectionEquality().hash(countryCodes),
    operator,
  );

  @override
  String toString() {
    return 'ContentCountryCodeParameters(countryCodes: $countryCodes, operator: $operator)';
  }
}

/// @nodoc
abstract mixin class $ContentCountryCodeParametersCopyWith<$Res> {
  factory $ContentCountryCodeParametersCopyWith(
    ContentCountryCodeParameters value,
    $Res Function(ContentCountryCodeParameters) _then,
  ) = _$ContentCountryCodeParametersCopyWithImpl;
  @useResult
  $Res call({List<String>? countryCodes, String? operator});
}

/// @nodoc
class _$ContentCountryCodeParametersCopyWithImpl<$Res> implements $ContentCountryCodeParametersCopyWith<$Res> {
  _$ContentCountryCodeParametersCopyWithImpl(this._self, this._then);

  final ContentCountryCodeParameters _self;
  final $Res Function(ContentCountryCodeParameters) _then;

  /// Create a copy of ContentCountryCodeParameters
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? countryCodes = freezed, Object? operator = freezed}) {
    return _then(
      ContentCountryCodeParameters(
        countryCodes: freezed == countryCodes
            ? _self.countryCodes
            : countryCodes // ignore: cast_nullable_to_non_nullable
                  as List<String>?,
        operator: freezed == operator
            ? _self.operator
            : operator // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
