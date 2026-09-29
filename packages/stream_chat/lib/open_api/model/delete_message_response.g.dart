// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeleteMessageResponse _$DeleteMessageResponseFromJson(
  Map<String, dynamic> json,
) => DeleteMessageResponse(
  duration: json['duration'] as String,
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeleteMessageResponseToJson(
  DeleteMessageResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'message': instance.message.toJson(),
};
