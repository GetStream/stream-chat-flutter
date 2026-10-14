// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_identical_image_count_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserIdenticalImageCountParameters _$UserIdenticalImageCountParametersFromJson(
  Map<String, dynamic> json,
) => UserIdenticalImageCountParameters(
  match: json['match'] as String?,
  similarityDistance: (json['similarity_distance'] as num?)?.toInt(),
  threshold: (json['threshold'] as num?)?.toInt(),
  timeWindow: json['time_window'] as String?,
);

Map<String, dynamic> _$UserIdenticalImageCountParametersToJson(
  UserIdenticalImageCountParameters instance,
) => <String, dynamic>{
  'match': instance.match,
  'similarity_distance': instance.similarityDistance,
  'threshold': instance.threshold,
  'time_window': instance.timeWindow,
};
