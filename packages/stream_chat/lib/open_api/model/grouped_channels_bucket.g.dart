// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_channels_bucket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupedChannelsBucket _$GroupedChannelsBucketFromJson(
  Map<String, dynamic> json,
) => GroupedChannelsBucket(
  channels: (json['channels'] as List<dynamic>)
      .map(
        (e) => ChannelStateResponseFields.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
);

Map<String, dynamic> _$GroupedChannelsBucketToJson(
  GroupedChannelsBucket instance,
) => <String, dynamic>{
  'channels': instance.channels.map((e) => e.toJson()).toList(),
  'next': instance.next,
  'prev': instance.prev,
  'unread_channels': instance.unreadChannels,
};
