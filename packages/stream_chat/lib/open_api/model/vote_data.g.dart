// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vote_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VoteData _$VoteDataFromJson(Map<String, dynamic> json) => VoteData(
  answerText: json['answer_text'] as String?,
  optionId: json['option_id'] as String?,
);

Map<String, dynamic> _$VoteDataToJson(VoteData instance) => <String, dynamic>{
  'answer_text': instance.answerText,
  'option_id': instance.optionId,
};
