// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map<String, dynamic> json) => Reaction(
      messageId: json['message_id'] as String?,
      type: json['type'] as String,
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      userId: json['user_id'] as String?,
      score: (json['score'] as num?)?.toInt() ?? 1,
      emojiCode: json['emoji_code'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ReactionToJson(Reaction instance) => <String, dynamic>{
      'type': instance.type,
      'score': instance.score,
      if (instance.emojiCode case final value?) 'emoji_code': value,
      'extra_data': instance.extraData,
    };
