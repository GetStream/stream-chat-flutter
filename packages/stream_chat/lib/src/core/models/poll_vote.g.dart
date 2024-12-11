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

Map<String, dynamic> _$PollVoteToJson(PollVote instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('option_id', instance.optionId);
  writeNotNull('answer_text', instance.answerText);
  return val;
}
