// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cast_poll_vote_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CastPollVoteRequest _$CastPollVoteRequestFromJson(Map<String, dynamic> json) =>
    CastPollVoteRequest(
      vote: json['vote'] == null
          ? null
          : VoteData.fromJson(json['vote'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CastPollVoteRequestToJson(
  CastPollVoteRequest instance,
) => <String, dynamic>{'vote': instance.vote?.toJson()};
