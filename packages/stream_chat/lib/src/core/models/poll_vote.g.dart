// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'poll_vote.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PollVote _$PollVoteFromJson(Map<String, dynamic> json) => PollVote(
      id: json['id'] as String?,
      pollId: json['poll_id'] as String?,
      optionId: json['option_id'] as String?,
      answerText: json['answer_text'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      userId: json['user_id'] as String?,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PollVoteToJson(PollVote instance) => <String, dynamic>{
      if (instance.id case final value?) 'id': value,
      if (instance.optionId case final value?) 'option_id': value,
      if (instance.answerText case final value?) 'answer_text': value,
    };
