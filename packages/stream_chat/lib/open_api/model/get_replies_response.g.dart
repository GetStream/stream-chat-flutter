// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_replies_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetRepliesResponse _$GetRepliesResponseFromJson(Map<String, dynamic> json) => GetRepliesResponse(
  duration: json['duration'] as String,
  messages: (json['messages'] as List<dynamic>)
      .map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$GetRepliesResponseToJson(GetRepliesResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'messages': instance.messages.map((e) => e.toJson()).toList(),
};
