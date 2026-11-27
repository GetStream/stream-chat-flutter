// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grouped_channels_group_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupedChannelsGroupRequest _$GroupedChannelsGroupRequestFromJson(
  Map<String, dynamic> json,
) => GroupedChannelsGroupRequest(
  filterConditions: json['filter_conditions'] as Map<String, dynamic>?,
  limit: (json['limit'] as num?)?.toInt(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$GroupedChannelsGroupRequestToJson(
  GroupedChannelsGroupRequest instance,
) => <String, dynamic>{
  'filter_conditions': instance.filterConditions,
  'limit': instance.limit,
  'next': instance.next,
  'prev': instance.prev,
};
