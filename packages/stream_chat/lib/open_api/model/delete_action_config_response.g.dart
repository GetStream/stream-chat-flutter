// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_action_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteActionConfigResponse _$DeleteActionConfigResponseFromJson(
  Map<String, dynamic> json,
) => DeleteActionConfigResponse(
  deleted: (json['deleted'] as num).toInt(),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$DeleteActionConfigResponseToJson(
  DeleteActionConfigResponse instance,
) => <String, dynamic>{
  'deleted': instance.deleted,
  'duration': instance.duration,
};
