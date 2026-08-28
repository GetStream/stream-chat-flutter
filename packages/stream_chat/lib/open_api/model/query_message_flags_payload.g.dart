// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_message_flags_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryMessageFlagsPayload _$QueryMessageFlagsPayloadFromJson(
  Map<String, dynamic> json,
) => QueryMessageFlagsPayload(
  filterConditions: json['filter_conditions'] as Map<String, dynamic>?,
  limit: (json['limit'] as num?)?.toInt(),
  offset: (json['offset'] as num?)?.toInt(),
  showDeletedMessages: json['show_deleted_messages'] as bool?,
  sort: (json['sort'] as List<dynamic>?)
      ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QueryMessageFlagsPayloadToJson(
  QueryMessageFlagsPayload instance,
) => <String, dynamic>{
  'filter_conditions': instance.filterConditions,
  'limit': instance.limit,
  'offset': instance.offset,
  'show_deleted_messages': instance.showDeletedMessages,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
};
