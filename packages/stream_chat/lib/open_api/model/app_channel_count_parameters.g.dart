// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_channel_count_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppChannelCountParameters _$AppChannelCountParametersFromJson(
  Map<String, dynamic> json,
) => AppChannelCountParameters(
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$AppChannelCountParametersToJson(
  AppChannelCountParameters instance,
) => <String, dynamic>{
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
