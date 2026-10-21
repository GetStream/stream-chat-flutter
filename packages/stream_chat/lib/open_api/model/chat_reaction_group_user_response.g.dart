// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_reaction_group_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatReactionGroupUserResponse _$ChatReactionGroupUserResponseFromJson(
  Map<String, dynamic> json,
) => ChatReactionGroupUserResponse(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  user: json['user'] == null ? null : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ChatReactionGroupUserResponseToJson(
  ChatReactionGroupUserResponse instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'user': instance.user?.toJson(),
  'user_id': instance.userId,
};
