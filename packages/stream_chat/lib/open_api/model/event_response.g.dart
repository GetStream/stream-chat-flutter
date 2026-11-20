// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventResponse _$EventResponseFromJson(Map<String, dynamic> json) => EventResponse(
  duration: json['duration'] as String,
  event: WSEvent.fromJson(json['event'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EventResponseToJson(EventResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'event': instance.event.toJson(),
};
