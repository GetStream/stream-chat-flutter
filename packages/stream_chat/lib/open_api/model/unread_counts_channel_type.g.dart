// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unread_counts_channel_type.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UnreadCountsChannelType _$UnreadCountsChannelTypeFromJson(
  Map<String, dynamic> json,
) => UnreadCountsChannelType(
  channelCount: (json['channel_count'] as num).toInt(),
  channelType: json['channel_type'] as String,
  unreadCount: (json['unread_count'] as num).toInt(),
);

Map<String, dynamic> _$UnreadCountsChannelTypeToJson(
  UnreadCountsChannelType instance,
) => <String, dynamic>{
  'channel_count': instance.channelCount,
  'channel_type': instance.channelType,
  'unread_count': instance.unreadCount,
};
