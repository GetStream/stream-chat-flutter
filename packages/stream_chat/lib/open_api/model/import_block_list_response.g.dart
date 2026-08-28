// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_block_list_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImportBlockListResponse _$ImportBlockListResponseFromJson(
  Map<String, dynamic> json,
) => ImportBlockListResponse(
  duration: json['duration'] as String,
  taskId: json['task_id'] as String,
);

Map<String, dynamic> _$ImportBlockListResponseToJson(
  ImportBlockListResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'task_id': instance.taskId,
};
