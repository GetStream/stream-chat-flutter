// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_poll_option_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePollOptionRequest _$CreatePollOptionRequestFromJson(
  Map<String, dynamic> json,
) => CreatePollOptionRequest(
  custom: json['custom'] as Map<String, dynamic>?,
  text: json['text'] as String,
);

Map<String, dynamic> _$CreatePollOptionRequestToJson(
  CreatePollOptionRequest instance,
) => <String, dynamic>{'custom': instance.custom, 'text': instance.text};
