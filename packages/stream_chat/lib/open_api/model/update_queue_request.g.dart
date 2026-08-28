// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_queue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateQueueRequest _$UpdateQueueRequestFromJson(Map<String, dynamic> json) =>
    UpdateQueueRequest(
      description: json['description'] as String?,
      filters: json['filters'] as Map<String, dynamic>?,
      name: json['name'] as String?,
      sort: (json['sort'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$UpdateQueueRequestToJson(UpdateQueueRequest instance) =>
    <String, dynamic>{
      'description': instance.description,
      'filters': instance.filters,
      'name': instance.name,
      'sort': instance.sort,
    };
