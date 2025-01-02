// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Thread _$ThreadFromJson(Map<String, dynamic> json) => Thread(
      activeParticipantCount:
          (json['active_participant_count'] as num?)?.toInt(),
      channel: json['channel'] == null
          ? null
          : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
      channelCid: json['channel_cid'] as String,
      parentMessageId: json['parent_message_id'] as String,
      parentMessage: json['parent_message'] == null
          ? null
          : Message.fromJson(json['parent_message'] as Map<String, dynamic>),
      createdByUserId: json['created_by_user_id'] as String,
      createdBy: json['created_by'] == null
          ? null
          : User.fromJson(json['created_by'] as Map<String, dynamic>),
      replyCount: (json['reply_count'] as num).toInt(),
      participantCount: (json['participant_count'] as num).toInt(),
      threadParticipants: (json['thread_participants'] as List<dynamic>?)
              ?.map(
                  (e) => ThreadParticipant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lastMessageAt: json['last_message_at'] == null
          ? null
          : DateTime.parse(json['last_message_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] == null
          ? null
          : DateTime.parse(json['deleted_at'] as String),
      title: json['title'] as String?,
      latestReplies: (json['latest_replies'] as List<dynamic>?)
              ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      read: (json['read'] as List<dynamic>?)
              ?.map((e) => Read.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ThreadToJson(Thread instance) => <String, dynamic>{
      'active_participant_count': instance.activeParticipantCount,
      'channel_cid': instance.channelCid,
      'channel': instance.channel?.toJson(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'deleted_at': instance.deletedAt?.toIso8601String(),
      'created_by_user_id': instance.createdByUserId,
      'created_by': instance.createdBy?.toJson(),
      'title': instance.title,
      'parent_message_id': instance.parentMessageId,
      'parent_message': instance.parentMessage?.toJson(),
      'reply_count': instance.replyCount,
      'participant_count': instance.participantCount,
      'thread_participants':
          instance.threadParticipants.map((e) => e.toJson()).toList(),
      'last_message_at': instance.lastMessageAt?.toIso8601String(),
      'latest_replies': instance.latestReplies.map((e) => e.toJson()).toList(),
      'read': instance.read?.map((e) => e.toJson()).toList(),
      'extra_data': instance.extraData,
    };
