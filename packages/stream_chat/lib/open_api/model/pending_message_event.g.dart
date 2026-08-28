// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_message_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PendingMessageEvent _$PendingMessageEventFromJson(Map<String, dynamic> json) =>
    PendingMessageEvent(
      channel: json['channel'] == null
          ? null
          : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      message: json['message'] == null
          ? null
          : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
      metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      method: json['method'] as String,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      type: json['type'] as String,
      user: json['user'] == null
          ? null
          : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PendingMessageEventToJson(
  PendingMessageEvent instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message': instance.message?.toJson(),
  'metadata': instance.metadata,
  'method': instance.method,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
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
