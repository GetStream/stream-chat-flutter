// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intent_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntentConfigResponse _$IntentConfigResponseFromJson(
  Map<String, dynamic> json,
) => IntentConfigResponse(
  topics: (json['topics'] as List<dynamic>)
      .map((e) => IntentTopicResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$IntentConfigResponseToJson(
  IntentConfigResponse instance,
) => <String, dynamic>{
  'topics': instance.topics.map((e) => e.toJson()).toList(),
};
