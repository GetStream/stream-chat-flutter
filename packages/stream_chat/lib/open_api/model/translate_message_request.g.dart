// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate_message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TranslateMessageRequest _$TranslateMessageRequestFromJson(
  Map<String, dynamic> json,
) => TranslateMessageRequest(
  language: TranslateMessageRequestLanguage.fromJson(
    json['language'] as String,
  ),
);

Map<String, dynamic> _$TranslateMessageRequestToJson(
  TranslateMessageRequest instance,
) => <String, dynamic>{'language': instance.language.toJson()};
