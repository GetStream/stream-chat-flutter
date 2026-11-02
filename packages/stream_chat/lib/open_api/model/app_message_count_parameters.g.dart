// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_message_count_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppMessageCountParameters _$AppMessageCountParametersFromJson(
  Map<String, dynamic> json,
) => AppMessageCountParameters(
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$AppMessageCountParametersToJson(
  AppMessageCountParameters instance,
) => <String, dynamic>{
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
