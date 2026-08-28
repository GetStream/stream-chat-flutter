// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flag_feedback_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FlagFeedbackResponse _$FlagFeedbackResponseFromJson(
  Map<String, dynamic> json,
) => FlagFeedbackResponse(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  labels: (json['labels'] as List<dynamic>)
      .map((e) => LabelResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  messageId: json['message_id'] as String,
);

Map<String, dynamic> _$FlagFeedbackResponseToJson(
  FlagFeedbackResponse instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'labels': instance.labels.map((e) => e.toJson()).toList(),
  'message_id': instance.messageId,
};
