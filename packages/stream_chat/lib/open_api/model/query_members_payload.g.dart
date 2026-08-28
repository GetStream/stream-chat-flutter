// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_members_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryMembersPayload _$QueryMembersPayloadFromJson(Map<String, dynamic> json) =>
    QueryMembersPayload(
      filterConditions: json['filter_conditions'] as Map<String, dynamic>?,
      id: json['id'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => ChannelMemberRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      offset: (json['offset'] as num?)?.toInt(),
      sort: (json['sort'] as List<dynamic>?)
          ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      type: json['type'] as String,
    );

Map<String, dynamic> _$QueryMembersPayloadToJson(
  QueryMembersPayload instance,
) => <String, dynamic>{
  'filter_conditions': instance.filterConditions,
  'id': instance.id,
  'limit': instance.limit,
  'members': instance.members?.map((e) => e.toJson()).toList(),
  'offset': instance.offset,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
  'type': instance.type,
};
