// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_scheduled_messages_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryScheduledMessagesRequest _$QueryScheduledMessagesRequestFromJson(
  Map<String, dynamic> json,
) => QueryScheduledMessagesRequest(
  filter: json['filter'] == null
      ? null
      : ScheduledMessagesFilter.fromJson(
          json['filter'] as Map<String, dynamic>,
        ),
  limit: (json['limit'] as num?)?.toInt(),
  next: json['next'] as String?,
  sort: (json['sort'] as List<dynamic>?)?.map((e) => SortParamRequest.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$QueryScheduledMessagesRequestToJson(
  QueryScheduledMessagesRequest instance,
) => <String, dynamic>{
  'filter': instance.filter?.toJson(),
  'limit': instance.limit,
  'next': instance.next,
  'sort': instance.sort?.map((e) => e.toJson()).toList(),
};
