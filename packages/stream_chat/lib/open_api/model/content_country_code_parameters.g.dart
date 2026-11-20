// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_country_code_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentCountryCodeParameters _$ContentCountryCodeParametersFromJson(
  Map<String, dynamic> json,
) => ContentCountryCodeParameters(
  countryCodes: (json['country_codes'] as List<dynamic>?)?.map((e) => e as String).toList(),
  operator: json['operator'] as String?,
);

Map<String, dynamic> _$ContentCountryCodeParametersToJson(
  ContentCountryCodeParameters instance,
) => <String, dynamic>{
  'country_codes': instance.countryCodes,
  'operator': instance.operator,
};
