// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queue_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueueResponse _$QueueResponseFromJson(Map<String, dynamic> json) => QueueResponse(
  duration: json['duration'] as String,
  queue: json['queue'] == null
      ? null
      : ModerationQueueResponse.fromJson(
          json['queue'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$QueueResponseToJson(QueueResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'queue': instance.queue?.toJson(),
};
