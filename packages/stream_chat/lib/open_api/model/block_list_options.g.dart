// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_list_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockListOptions _$BlockListOptionsFromJson(Map<String, dynamic> json) => BlockListOptions(
  behavior: json['behavior'] as ChannelModerationBehavior,
  blocklist: json['blocklist'] as String,
);

Map<String, dynamic> _$BlockListOptionsToJson(BlockListOptions instance) => <String, dynamic>{
  'behavior': instance.behavior,
  'blocklist': instance.blocklist,
};
