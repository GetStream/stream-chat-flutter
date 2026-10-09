// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_pinned_messages_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPinnedMessagesResponse _$GetPinnedMessagesResponseFromJson(
  Map<String, dynamic> json,
) => GetPinnedMessagesResponse(
  duration: json['duration'] as String,
  messages: (json['messages'] as List<dynamic>)
      .map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetPinnedMessagesResponseToJson(
  GetPinnedMessagesResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'messages': instance.messages.map((e) => e.toJson()).toList(),
};
