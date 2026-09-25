// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_query_channels_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupedQueryChannelsResponse _$GroupedQueryChannelsResponseFromJson(
  Map<String, dynamic> json,
) => GroupedQueryChannelsResponse(
  duration: json['duration'] as String,
  groups: (json['groups'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, GroupedChannelsBucket.fromJson(e as Map<String, dynamic>)),
  ),
);

Map<String, dynamic> _$GroupedQueryChannelsResponseToJson(
  GroupedQueryChannelsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'groups': instance.groups.map((k, e) => MapEntry(k, e.toJson())),
};
