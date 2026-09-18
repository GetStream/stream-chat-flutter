// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncResponse _$SyncResponseFromJson(Map<String, dynamic> json) => SyncResponse(
  duration: json['duration'] as String,
  events: wsEventListFromJson(json['events'] as List),
  inaccessibleCids: (json['inaccessible_cids'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$SyncResponseToJson(SyncResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'events': wsEventListToJson(instance.events),
  'inaccessible_cids': instance.inaccessibleCids,
};
