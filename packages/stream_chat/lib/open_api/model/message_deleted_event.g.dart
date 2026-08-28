// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_deleted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDeletedEvent _$MessageDeletedEventFromJson(
  Map<String, dynamic> json,
) => MessageDeletedEvent(
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
  deletedForMe: json['deleted_for_me'] as bool?,
  hardDelete: json['hard_delete'] as bool,
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null
      ? null
      : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageDeletedEventToJson(
  MessageDeletedEvent instance,
) => <String, dynamic>{
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'deleted_for_me': instance.deletedForMe,
  'hard_delete': instance.hardDelete,
  'message': instance.message.toJson(),
  'message_id': instance.messageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
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
