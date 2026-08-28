// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_queue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateQueueRequest _$CreateQueueRequestFromJson(Map<String, dynamic> json) =>
    CreateQueueRequest(
      description: json['description'] as String?,
      filters: json['filters'] as Map<String, dynamic>?,
      name: json['name'] as String,
      sort: (json['sort'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      type: CreateQueueRequestType.fromJson(json['type'] as String),
    );

Map<String, dynamic> _$CreateQueueRequestToJson(CreateQueueRequest instance) =>
    <String, dynamic>{
      'description': instance.description,
      'filters': instance.filters,
      'name': instance.name,
      'sort': instance.sort,
      'type': instance.type.toJson(),
    };
