// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_message_partial_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMessagePartialResponse _$UpdateMessagePartialResponseFromJson(
  Map<String, dynamic> json,
) => UpdateMessagePartialResponse(
  duration: json['duration'] as String,
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UpdateMessagePartialResponseToJson(
  UpdateMessagePartialResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'message': instance.message?.toJson(),
};
