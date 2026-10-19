// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_defaults.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppDefaults _$AppDefaultsFromJson(Map<String, dynamic> json) => AppDefaults(
  getOrCreateChannel: GetOrCreateChannelDefaults.fromJson(
    json['get_or_create_channel'] as Map<String, dynamic>,
  ),
  queryChannels: QueryChannelsDefaults.fromJson(
    json['query_channels'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$AppDefaultsToJson(AppDefaults instance) => <String, dynamic>{
  'get_or_create_channel': instance.getOrCreateChannel.toJson(),
  'query_channels': instance.queryChannels.toJson(),
};
