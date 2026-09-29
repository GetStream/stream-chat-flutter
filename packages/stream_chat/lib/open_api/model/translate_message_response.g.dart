// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslateMessageResponse _$TranslateMessageResponseFromJson(
  Map<String, dynamic> json,
) => TranslateMessageResponse(
  duration: json['duration'] as String,
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$TranslateMessageResponseToJson(
  TranslateMessageResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'message': instance.message.toJson(),
};
