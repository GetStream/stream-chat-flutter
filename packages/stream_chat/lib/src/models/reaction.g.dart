// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reaction _$ReactionFromJson(Map json) {
  return Reaction(
    messageId: json['message_id'] as String?,
    createdAt: DateTime.parse(json['created_at'] as String),
    type: json['type'] as String,
    user: User.fromJson((json['user'] as Map?)?.map(
      (k, e) => MapEntry(k as String, e),
    )),
    userId: json['user_id'] as String?,
    score: json['score'] as int,
    extraData: (json['extra_data'] as Map?)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
  );
}

Map<String, dynamic> _$ReactionToJson(Reaction instance) {
  final val = <String, dynamic>{
    'message_id': instance.messageId,
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('user', readonly(instance.user));
  val['score'] = instance.score;
  writeNotNull('user_id', readonly(instance.userId));
  writeNotNull('extra_data', instance.extraData);
  return val;
}
