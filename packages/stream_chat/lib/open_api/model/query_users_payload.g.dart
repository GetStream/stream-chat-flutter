// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_users_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryUsersPayload _$QueryUsersPayloadFromJson(Map<String, dynamic> json) =>
    QueryUsersPayload(
      filterConditions: json['filter_conditions'] as Map<String, dynamic>,
      includeDeactivatedUsers: json['include_deactivated_users'] as bool?,
      limit: (json['limit'] as num?)?.toInt(),
      offset: (json['offset'] as num?)?.toInt(),
      presence: json['presence'] as bool?,
      sort: (json['sort'] as List<dynamic>?)
          ?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$QueryUsersPayloadToJson(QueryUsersPayload instance) =>
    <String, dynamic>{
      'filter_conditions': instance.filterConditions,
      'include_deactivated_users': instance.includeDeactivatedUsers,
      'limit': instance.limit,
      'offset': instance.offset,
      'presence': instance.presence,
      'sort': instance.sort?.map((e) => e.toJson()).toList(),
    };
