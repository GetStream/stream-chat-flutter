// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_action_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageActionResponse _$MessageActionResponseFromJson(
  Map<String, dynamic> json,
) => MessageActionResponse(
  duration: json['duration'] as String,
  message: json['message'] == null
      ? null
      : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageActionResponseToJson(
  MessageActionResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'message': instance.message?.toJson(),
};
