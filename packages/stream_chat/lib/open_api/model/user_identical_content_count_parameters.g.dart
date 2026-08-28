// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_identical_content_count_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIdenticalContentCountParameters
_$UserIdenticalContentCountParametersFromJson(Map<String, dynamic> json) =>
    UserIdenticalContentCountParameters(
      threshold: (json['threshold'] as num?)?.toInt(),
      timeWindow: json['time_window'] as String?,
    );

Map<String, dynamic> _$UserIdenticalContentCountParametersToJson(
  UserIdenticalContentCountParameters instance,
) => <String, dynamic>{
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
