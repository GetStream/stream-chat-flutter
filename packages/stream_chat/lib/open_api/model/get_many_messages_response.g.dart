// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_many_messages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetManyMessagesResponse _$GetManyMessagesResponseFromJson(
  Map<String, dynamic> json,
) => GetManyMessagesResponse(
  duration: json['duration'] as String,
  messages: (json['messages'] as List<dynamic>)
      .map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetManyMessagesResponseToJson(
  GetManyMessagesResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'messages': instance.messages.map((e) => e.toJson()).toList(),
};
