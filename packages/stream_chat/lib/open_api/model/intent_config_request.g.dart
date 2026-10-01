// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'intent_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntentConfigRequest _$IntentConfigRequestFromJson(Map<String, dynamic> json) => IntentConfigRequest(
  topics: (json['topics'] as List<dynamic>?)
      ?.map((e) => IntentTopicRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$IntentConfigRequestToJson(
  IntentConfigRequest instance,
) => <String, dynamic>{
  'topics': instance.topics?.map((e) => e.toJson()).toList(),
};
