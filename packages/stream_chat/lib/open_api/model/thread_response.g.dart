// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thread_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThreadResponse _$ThreadResponseFromJson(Map<String, dynamic> json) =>
    ThreadResponse(
      activeParticipantCount: (json['active_participant_count'] as num).toInt(),
      channel: json['channel'] == null
          ? null
          : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
      channelCid: json['channel_cid'] as String,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      createdBy: json['created_by'] == null
          ? null
          : UserResponse.fromJson(json['created_by'] as Map<String, dynamic>),
      createdByUserId: json['created_by_user_id'] as String,
      custom: json['custom'] as Map<String, dynamic>,
      deletedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['deleted_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      lastMessageAt: _$JsonConverterFromJson<Object, DateTime>(
        json['last_message_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      parentMessage: json['parent_message'] == null
          ? null
          : MessageResponse.fromJson(
              json['parent_message'] as Map<String, dynamic>,
            ),
      parentMessageId: json['parent_message_id'] as String,
      participantCount: (json['participant_count'] as num).toInt(),
      replyCount: (json['reply_count'] as num).toInt(),
      threadParticipants: (json['thread_participants'] as List<dynamic>?)
          ?.map((e) => ThreadParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
      title: json['title'] as String,
      updatedAt: const StreamDateTimeConverter().fromJson(
        json['updated_at'] as Object,
      ),
    );

Map<String, dynamic> _$ThreadResponseToJson(ThreadResponse instance) =>
    <String, dynamic>{
      'active_participant_count': instance.activeParticipantCount,
      'channel': instance.channel?.toJson(),
      'channel_cid': instance.channelCid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'created_by': instance.createdBy?.toJson(),
      'created_by_user_id': instance.createdByUserId,
      'custom': instance.custom,
      'deleted_at': _$JsonConverterToJson<Object, DateTime>(
        instance.deletedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'last_message_at': _$JsonConverterToJson<Object, DateTime>(
        instance.lastMessageAt,
        const StreamDateTimeConverter().toJson,
      ),
      'parent_message': instance.parentMessage?.toJson(),
      'parent_message_id': instance.parentMessageId,
      'participant_count': instance.participantCount,
      'reply_count': instance.replyCount,
      'thread_participants': instance.threadParticipants
          ?.map((e) => e.toJson())
          .toList(),
      'title': instance.title,
      'updated_at': const StreamDateTimeConverter().toJson(instance.updatedAt),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
