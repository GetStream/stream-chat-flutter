// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_channels_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteChannelsResponse _$DeleteChannelsResponseFromJson(
  Map<String, dynamic> json,
) => DeleteChannelsResponse(
  duration: json['duration'] as String,
  result: (json['result'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      DeleteChannelsResultResponse.fromJson(e as Map<String, dynamic>),
    ),
  ),
  taskId: json['task_id'] as String?,
);

Map<String, dynamic> _$DeleteChannelsResponseToJson(
  DeleteChannelsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'result': instance.result?.map((k, e) => MapEntry(k, e.toJson())),
  'task_id': instance.taskId,
};
