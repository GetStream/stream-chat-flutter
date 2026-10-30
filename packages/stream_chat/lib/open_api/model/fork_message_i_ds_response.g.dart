// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fork_message_i_ds_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForkMessageIDsResponse _$ForkMessageIDsResponseFromJson(
  Map<String, dynamic> json,
) => ForkMessageIDsResponse(
  duration: json['duration'] as String,
  messageIdMap: Map<String, String>.from(json['message_id_map'] as Map),
);

Map<String, dynamic> _$ForkMessageIDsResponseToJson(
  ForkMessageIDsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'message_id_map': instance.messageIdMap,
};
