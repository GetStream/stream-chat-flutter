// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_option_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollOptionRequest _$PollOptionRequestFromJson(Map<String, dynamic> json) =>
    PollOptionRequest(
      custom: json['custom'] as Map<String, dynamic>?,
      id: json['id'] as String,
      text: json['text'] as String?,
    );

Map<String, dynamic> _$PollOptionRequestToJson(PollOptionRequest instance) =>
    <String, dynamic>{
      'custom': instance.custom,
      'id': instance.id,
      'text': instance.text,
    };
