// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_message_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMessageResponse _$UpdateMessageResponseFromJson(
  Map<String, dynamic> json,
) => UpdateMessageResponse(
  duration: json['duration'] as String,
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateMessageResponseToJson(
  UpdateMessageResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'message': instance.message.toJson(),
};
