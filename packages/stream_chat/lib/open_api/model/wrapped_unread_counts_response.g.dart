// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wrapped_unread_counts_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WrappedUnreadCountsResponse _$WrappedUnreadCountsResponseFromJson(
  Map<String, dynamic> json,
) => WrappedUnreadCountsResponse(
  channelType: (json['channel_type'] as List<dynamic>)
      .map((e) => UnreadCountsChannelType.fromJson(e as Map<String, dynamic>))
      .toList(),
  channels: (json['channels'] as List<dynamic>)
      .map((e) => UnreadCountsChannel.fromJson(e as Map<String, dynamic>))
      .toList(),
  duration: json['duration'] as String,
  threads: (json['threads'] as List<dynamic>)
      .map((e) => UnreadCountsThread.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalUnreadCount: (json['total_unread_count'] as num).toInt(),
  totalUnreadCountByTeam:
      (json['total_unread_count_by_team'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ),
  totalUnreadThreadsCount: (json['total_unread_threads_count'] as num).toInt(),
);

Map<String, dynamic> _$WrappedUnreadCountsResponseToJson(
  WrappedUnreadCountsResponse instance,
) => <String, dynamic>{
  'channel_type': instance.channelType.map((e) => e.toJson()).toList(),
  'channels': instance.channels.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
  'threads': instance.threads.map((e) => e.toJson()).toList(),
  'total_unread_count': instance.totalUnreadCount,
  'total_unread_count_by_team': instance.totalUnreadCountByTeam,
  'total_unread_threads_count': instance.totalUnreadThreadsCount,
};
