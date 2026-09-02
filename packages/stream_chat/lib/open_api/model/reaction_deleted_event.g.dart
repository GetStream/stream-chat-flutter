// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reaction_deleted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReactionDeletedEvent _$ReactionDeletedEventFromJson(
  Map<String, dynamic> json,
) => ReactionDeletedEvent(
  channel: ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  channelCustom: json['channel_custom'] as Map<String, dynamic>?,
  channelId: json['channel_id'] as String?,
  channelMemberCount: (json['channel_member_count'] as num?)?.toInt(),
  channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String?,
  reaction: json['reaction'] == null ? null : ReactionResponse.fromJson(json['reaction'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  threadParticipants: (json['thread_participants'] as List<dynamic>?)
      ?.map((e) => UserResponseCommonFields.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReactionDeletedEventToJson(
  ReactionDeletedEvent instance,
) => <String, dynamic>{
  'channel': instance.channel.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message': instance.message?.toJson(),
  'message_id': instance.messageId,
  'reaction': instance.reaction?.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'thread_participants': instance.threadParticipants?.map((e) => e.toJson()).toList(),
  'type': instance.type,
  'user': instance.user?.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
