// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_message_flags_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryMessageFlagsResponse _$QueryMessageFlagsResponseFromJson(
  Map<String, dynamic> json,
) => QueryMessageFlagsResponse(
  duration: json['duration'] as String,
  flags: (json['flags'] as List<dynamic>)
      .map((e) => MessageFlagResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QueryMessageFlagsResponseToJson(
  QueryMessageFlagsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'flags': instance.flags.map((e) => e.toJson()).toList(),
};
