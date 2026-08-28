// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_votes_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollVotesResponse _$PollVotesResponseFromJson(Map<String, dynamic> json) =>
    PollVotesResponse(
      duration: json['duration'] as String,
      next: json['next'] as String?,
      prev: json['prev'] as String?,
      votes: (json['votes'] as List<dynamic>)
          .map((e) => PollVoteResponseData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PollVotesResponseToJson(PollVotesResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'next': instance.next,
      'prev': instance.prev,
      'votes': instance.votes.map((e) => e.toJson()).toList(),
    };
