// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchPayload _$SearchPayloadFromJson(Map<String, dynamic> json) => SearchPayload(
  filterConditions: json['filter_conditions'] as Map<String, dynamic>,
  forceDefaultSearch: json['force_default_search'] as bool?,
  forceSqlV2Backend: json['force_sql_v2_backend'] as bool?,
  limit: (json['limit'] as num?)?.toInt(),
  messageFilterConditions: json['message_filter_conditions'] as Map<String, dynamic>?,
  messageOptions: json['message_options'] == null
      ? null
      : MessageOptions.fromJson(
          json['message_options'] as Map<String, dynamic>,
        ),
  next: json['next'] as String?,
  offset: (json['offset'] as num?)?.toInt(),
  query: json['query'] as String?,
  sort: (json['sort'] as List<dynamic>?)?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$SearchPayloadToJson(SearchPayload instance) => <String, dynamic>{
  'filter_conditions': instance.filterConditions,
  'force_default_search': instance.forceDefaultSearch,
  'force_sql_v2_backend': instance.forceSqlV2Backend,
  'limit': instance.limit,
  'message_filter_conditions': instance.messageFilterConditions,
  'message_options': instance.messageOptions?.toJson(),
  'next': instance.next,
  'offset': instance.offset,
  'query': instance.query,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
};
