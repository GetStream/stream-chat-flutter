// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeds_preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedsPreferences _$FeedsPreferencesFromJson(
  Map<String, dynamic> json,
) => FeedsPreferences(
  comment: json['comment'] == null ? null : FeedsPreferencesComment.fromJson(json['comment'] as String),
  commentMention: json['comment_mention'] == null
      ? null
      : FeedsPreferencesCommentMention.fromJson(
          json['comment_mention'] as String,
        ),
  commentReaction: json['comment_reaction'] == null
      ? null
      : FeedsPreferencesCommentReaction.fromJson(
          json['comment_reaction'] as String,
        ),
  commentReply: json['comment_reply'] == null
      ? null
      : FeedsPreferencesCommentReply.fromJson(json['comment_reply'] as String),
  customActivityTypes: (json['custom_activity_types'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  follow: json['follow'] == null ? null : FeedsPreferencesFollow.fromJson(json['follow'] as String),
  mention: json['mention'] == null ? null : FeedsPreferencesMention.fromJson(json['mention'] as String),
  reaction: json['reaction'] == null ? null : FeedsPreferencesReaction.fromJson(json['reaction'] as String),
);

Map<String, dynamic> _$FeedsPreferencesToJson(FeedsPreferences instance) => <String, dynamic>{
  'comment': instance.comment?.toJson(),
  'comment_mention': instance.commentMention?.toJson(),
  'comment_reaction': instance.commentReaction?.toJson(),
  'comment_reply': instance.commentReply?.toJson(),
  'custom_activity_types': instance.customActivityTypes,
  'follow': instance.follow?.toJson(),
  'mention': instance.mention?.toJson(),
  'reaction': instance.reaction?.toJson(),
};
