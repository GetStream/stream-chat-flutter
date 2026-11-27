// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_appeals_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryAppealsResponse _$QueryAppealsResponseFromJson(
  Map<String, dynamic> json,
) => QueryAppealsResponse(
  duration: json['duration'] as String,
  items: (json['items'] as List<dynamic>).map((e) => AppealItemResponse.fromJson(e as Map<String, dynamic>)).toList(),
  next: json['next'] as String?,
  prev: json['prev'] as String?,
);

Map<String, dynamic> _$QueryAppealsResponseToJson(
  QueryAppealsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'items': instance.items.map((e) => e.toJson()).toList(),
  'next': instance.next,
  'prev': instance.prev,
};
