// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_poll_option_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdatePollOptionRequest _$UpdatePollOptionRequestFromJson(
  Map<String, dynamic> json,
) => UpdatePollOptionRequest(
  custom: json['custom'] as Map<String, dynamic>?,
  id: json['id'] as String,
  text: json['text'] as String,
);

Map<String, dynamic> _$UpdatePollOptionRequestToJson(
  UpdatePollOptionRequest instance,
) => <String, dynamic>{
  'custom': instance.custom,
  'id': instance.id,
  'text': instance.text,
};
