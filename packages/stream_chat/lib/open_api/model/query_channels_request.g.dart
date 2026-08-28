// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_channels_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryChannelsRequest _$QueryChannelsRequestFromJson(
  Map<String, dynamic> json,
) => QueryChannelsRequest(
  filterConditions: json['filter_conditions'] as Map<String, dynamic>?,
  filterValues: json['filter_values'] as Map<String, dynamic>?,
  limit: (json['limit'] as num?)?.toInt(),
  memberCustomInclude: (json['member_custom_include'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  memberLimit: (json['member_limit'] as num?)?.toInt(),
  messageLimit: (json['message_limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
  predefinedFilter: json['predefined_filter'] as String?,
  presence: json['presence'] as bool?,
  sort: (json['sort'] as List<dynamic>?)
      ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  sortValues: json['sort_values'] as Map<String, dynamic>?,
  state: json['state'] as bool?,
  watch: json['watch'] as bool?,
);

Map<String, dynamic> _$QueryChannelsRequestToJson(
  QueryChannelsRequest instance,
) => <String, dynamic>{
  'filter_conditions': instance.filterConditions,
  'filter_values': instance.filterValues,
  'limit': instance.limit,
  'member_custom_include': instance.memberCustomInclude,
  'member_limit': instance.memberLimit,
  'message_limit': instance.messageLimit,
  'offset': instance.offset,
  'predefined_filter': instance.predefinedFilter,
  'presence': instance.presence,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
  'sort_values': instance.sortValues,
  'state': instance.state,
  'watch': instance.watch,
};
