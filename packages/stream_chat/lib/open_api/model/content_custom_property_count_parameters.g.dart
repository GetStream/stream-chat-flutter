// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content_custom_property_count_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentCustomPropertyCountParameters
_$ContentCustomPropertyCountParametersFromJson(Map<String, dynamic> json) =>
    ContentCustomPropertyCountParameters(
      operator: json['operator'] as String?,
      propertyKey: json['property_key'] as String?,
      threshold: (json['threshold'] as num?)?.toInt(),
      timeWindow: json['time_window'] as String?,
    );

Map<String, dynamic> _$ContentCustomPropertyCountParametersToJson(
  ContentCustomPropertyCountParameters instance,
) => <String, dynamic>{
  'operator': instance.operator,
  'property_key': instance.propertyKey,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
