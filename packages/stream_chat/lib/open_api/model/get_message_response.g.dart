// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMessageResponse _$GetMessageResponseFromJson(Map<String, dynamic> json) => GetMessageResponse(
  duration: json['duration'] as String,
  message: MessageWithChannelResponse.fromJson(
    json['message'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$GetMessageResponseToJson(GetMessageResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'message': instance.message.toJson(),
};
