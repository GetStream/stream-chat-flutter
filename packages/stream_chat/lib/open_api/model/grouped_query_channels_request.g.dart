// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_query_channels_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupedQueryChannelsRequest _$GroupedQueryChannelsRequestFromJson(
  Map<String, dynamic> json,
) => GroupedQueryChannelsRequest(
  groups: (json['groups'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(
      k,
      GroupedChannelsGroupRequest.fromJson(e as Map<String, dynamic>),
    ),
  ),
  limit: (json['limit'] as num?)?.toInt(),
  presence: json['presence'] as bool?,
  watch: json['watch'] as bool?,
);

Map<String, dynamic> _$GroupedQueryChannelsRequestToJson(
  GroupedQueryChannelsRequest instance,
) => <String, dynamic>{
  'groups': instance.groups?.map((k, e) => MapEntry(k, e.toJson())),
  'limit': instance.limit,
  'presence': instance.presence,
  'watch': instance.watch,
};
