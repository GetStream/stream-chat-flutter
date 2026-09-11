// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_indicator_update_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIIndicatorUpdateEvent _$AIIndicatorUpdateEventFromJson(
  Map<String, dynamic> json,
) => AIIndicatorUpdateEvent(
  aiMessage: json['ai_message'] as String?,
  aiState: json['ai_state'] as String,
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$AIIndicatorUpdateEventToJson(
  AIIndicatorUpdateEvent instance,
) => <String, dynamic>{
  'ai_message': instance.aiMessage,
  'ai_state': instance.aiState,
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
