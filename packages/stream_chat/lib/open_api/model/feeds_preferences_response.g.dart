// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_preferences_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsPreferencesResponse _$FeedsPreferencesResponseFromJson(
  Map<String, dynamic> json,
) => FeedsPreferencesResponse(
  comment: json['comment'] as String?,
  commentMention: json['comment_mention'] as String?,
  commentReaction: json['comment_reaction'] as String?,
  commentReply: json['comment_reply'] as String?,
  customActivityTypes: (json['custom_activity_types'] as Map<String, dynamic>?)
      ?.map((k, e) => MapEntry(k, e as String)),
  follow: json['follow'] as String?,
  mention: json['mention'] as String?,
  reaction: json['reaction'] as String?,
);

Map<String, dynamic> _$FeedsPreferencesResponseToJson(
  FeedsPreferencesResponse instance,
) => <String, dynamic>{
  'comment': instance.comment,
  'comment_mention': instance.commentMention,
  'comment_reaction': instance.commentReaction,
  'comment_reply': instance.commentReply,
  'custom_activity_types': instance.customActivityTypes,
  'follow': instance.follow,
  'mention': instance.mention,
  'reaction': instance.reaction,
};
