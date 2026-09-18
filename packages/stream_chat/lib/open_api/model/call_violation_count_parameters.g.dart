// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_violation_count_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallViolationCountParameters _$CallViolationCountParametersFromJson(
  Map<String, dynamic> json,
) => CallViolationCountParameters(
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$CallViolationCountParametersToJson(
  CallViolationCountParameters instance,
) => <String, dynamic>{
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
