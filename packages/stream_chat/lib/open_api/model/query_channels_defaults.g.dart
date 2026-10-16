// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_channels_defaults.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryChannelsDefaults _$QueryChannelsDefaultsFromJson(
  Map<String, dynamic> json,
) => QueryChannelsDefaults(
  limit: (json['limit'] as num).toInt(),
  maxLimit: (json['max_limit'] as num).toInt(),
  memberLimit: (json['member_limit'] as num).toInt(),
  messageLimit: (json['message_limit'] as num).toInt(),
);

Map<String, dynamic> _$QueryChannelsDefaultsToJson(
  QueryChannelsDefaults instance,
) => <String, dynamic>{
  'limit': instance.limit,
  'max_limit': instance.maxLimit,
  'member_limit': instance.memberLimit,
  'message_limit': instance.messageLimit,
};
