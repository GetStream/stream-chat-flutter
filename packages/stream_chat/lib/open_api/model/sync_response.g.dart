// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) => SyncResponse(
  duration: json['duration'] as String,
  events: (json['events'] as List<dynamic>).map((e) => WSEvent.fromJson(e as Map<String, dynamic>)).toList(),
  inaccessibleCids: (json['inaccessible_cids'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$SyncResponseToJson(SyncResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'events': instance.events.map((e) => e.toJson()).toList(),
  'inaccessible_cids': instance.inaccessibleCids,
};
