// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map<String, dynamic> json) => Reaction(
      messageId: json['message_id'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      type: json['type'] as String,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      userId: json['user_id'] as String?,
      score: json['score'] as int? ?? 0,
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ReactionToJson(Reaction instance) => <String, dynamic>{
      'message_id': instance.messageId,
      'type': instance.type,
      'score': instance.score,
      'extra_data': instance.extraData,
    };
