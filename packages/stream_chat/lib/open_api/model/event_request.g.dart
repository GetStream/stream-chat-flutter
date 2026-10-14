// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventRequest _$EventRequestFromJson(Map<String, dynamic> json) => EventRequest(
  custom: json['custom'] as Map<String, dynamic>?,
  parentId: json['parent_id'] as String?,
  type: json['type'] as String,
);

Map<String, dynamic> _$EventRequestToJson(EventRequest instance) => <String, dynamic>{
  'custom': instance.custom,
  'parent_id': instance.parentId,
  'type': instance.type,
};
