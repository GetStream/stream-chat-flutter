// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_or_create_channel_defaults.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetOrCreateChannelDefaults _$GetOrCreateChannelDefaultsFromJson(
  Map<String, dynamic> json,
) => GetOrCreateChannelDefaults(
  members: PagerDefaults.fromJson(json['members'] as Map<String, dynamic>),
  messages: PagerDefaults.fromJson(json['messages'] as Map<String, dynamic>),
);

Map<String, dynamic> _$GetOrCreateChannelDefaultsToJson(
  GetOrCreateChannelDefaults instance,
) => <String, dynamic>{
  'members': instance.members.toJson(),
  'messages': instance.messages.toJson(),
};
