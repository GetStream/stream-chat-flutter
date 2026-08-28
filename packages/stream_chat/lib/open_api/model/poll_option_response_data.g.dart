// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_option_response_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollOptionResponseData _$PollOptionResponseDataFromJson(
  Map<String, dynamic> json,
) => PollOptionResponseData(
  custom: json['custom'] as Map<String, dynamic>,
  id: json['id'] as String,
  text: json['text'] as String,
);

Map<String, dynamic> _$PollOptionResponseDataToJson(
  PollOptionResponseData instance,
) => <String, dynamic>{
  'custom': instance.custom,
  'id': instance.id,
  'text': instance.text,
};
