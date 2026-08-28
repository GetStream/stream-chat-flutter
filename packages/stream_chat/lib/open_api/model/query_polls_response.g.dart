// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'query_polls_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QueryPollsResponse _$QueryPollsResponseFromJson(Map<String, dynamic> json) =>
    QueryPollsResponse(
      duration: json['duration'] as String,
      next: json['next'] as String?,
      polls: (json['polls'] as List<dynamic>)
          .map((e) => PollResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
      prev: json['prev'] as String?,
    );

Map<String, dynamic> _$QueryPollsResponseToJson(QueryPollsResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'next': instance.next,
      'polls': instance.polls.map((e) => e.toJson()).toList(),
      'prev': instance.prev,
    };
