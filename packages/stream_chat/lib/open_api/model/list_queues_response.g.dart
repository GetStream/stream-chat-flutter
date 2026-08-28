// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_queues_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListQueuesResponse _$ListQueuesResponseFromJson(Map<String, dynamic> json) =>
    ListQueuesResponse(
      duration: json['duration'] as String,
      queues: (json['queues'] as List<dynamic>)
          .map(
            (e) => ModerationQueueResponse.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$ListQueuesResponseToJson(ListQueuesResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'queues': instance.queues.map((e) => e.toJson()).toList(),
    };
