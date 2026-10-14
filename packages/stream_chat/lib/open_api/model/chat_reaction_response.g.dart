// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_reaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatReactionResponse _$ChatReactionResponseFromJson(
  Map<String, dynamic> json,
) => ChatReactionResponse(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String,
  score: (json['score'] as num).toInt(),
  type: json['type'] as String,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ChatReactionResponseToJson(
  ChatReactionResponse instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'score': instance.score,
  'type': instance.type,
  'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
  'user': instance.user.toJson(),
  'user_id': instance.userId,
};
