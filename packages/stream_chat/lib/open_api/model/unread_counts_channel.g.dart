// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_counts_channel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadCountsChannel _$UnreadCountsChannelFromJson(Map<String, dynamic> json) =>
    UnreadCountsChannel(
      channelId: json['channel_id'] as String,
      lastRead: const StreamDateTimeConverter().fromJson(
        json['last_read'] as Object,
      ),
      unreadCount: (json['unread_count'] as num).toInt(),
    );

Map<String, dynamic> _$UnreadCountsChannelToJson(
  UnreadCountsChannel instance,
) => <String, dynamic>{
  'channel_id': instance.channelId,
  'last_read': const StreamDateTimeConverter().toJson(instance.lastRead),
  'unread_count': instance.unreadCount,
};
