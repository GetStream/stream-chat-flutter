// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncRequest _$SyncRequestFromJson(Map<String, dynamic> json) => SyncRequest(
  channelCids: (json['channel_cids'] as List<dynamic>).map((e) => e as String).toList(),
  lastSyncAt: const StreamDateTimeConverter().fromJson(
    json['last_sync_at'] as Object,
  ),
);

Map<String, dynamic> _$SyncRequestToJson(
  SyncRequest instance,
) => <String, dynamic>{
  'channel_cids': instance.channelCids,
  'last_sync_at': const StreamDateTimeConverter().toJson(instance.lastSyncAt),
};
