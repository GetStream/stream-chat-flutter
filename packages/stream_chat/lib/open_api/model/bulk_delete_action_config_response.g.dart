// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_delete_action_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkDeleteActionConfigResponse _$BulkDeleteActionConfigResponseFromJson(
  Map<String, dynamic> json,
) => BulkDeleteActionConfigResponse(
  deleted: (json['deleted'] as num).toInt(),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$BulkDeleteActionConfigResponseToJson(
  BulkDeleteActionConfigResponse instance,
) => <String, dynamic>{
  'deleted': instance.deleted,
  'duration': instance.duration,
};
