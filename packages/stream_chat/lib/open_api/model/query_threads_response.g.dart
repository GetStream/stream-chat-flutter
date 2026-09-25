// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_threads_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryThreadsResponse _$QueryThreadsResponseFromJson(
  Map<String, dynamic> json,
) => QueryThreadsResponse(
  duration: json['duration'] as String,
  next: json['next'] as String?,
  prev: json['prev'] as String?,
  threads: (json['threads'] as List<dynamic>)
      .map((e) => ThreadStateResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$QueryThreadsResponseToJson(
  QueryThreadsResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'next': instance.next,
  'prev': instance.prev,
  'threads': instance.threads.map((e) => e.toJson()).toList(),
};
