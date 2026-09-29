// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_vote_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollVoteResponse _$PollVoteResponseFromJson(Map<String, dynamic> json) => PollVoteResponse(
  duration: json['duration'] as String,
  poll: json['poll'] == null ? null : PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
  vote: json['vote'] == null ? null : PollVoteResponseData.fromJson(json['vote'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PollVoteResponseToJson(PollVoteResponse instance) => <String, dynamic>{
  'duration': instance.duration,
  'poll': instance.poll?.toJson(),
  'vote': instance.vote?.toJson(),
};
