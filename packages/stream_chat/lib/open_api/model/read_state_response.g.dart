// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'read_state_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReadStateResponse _$ReadStateResponseFromJson(Map<String, dynamic> json) => ReadStateResponse(
  lastDeliveredAt: _$JsonConverterFromJson<Object, DateTime>(
    json['last_delivered_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  lastDeliveredMessageId: json['last_delivered_message_id'] as String?,
  lastRead: const StreamDateTimeConverter().fromJson(
    json['last_read'] as Object,
  ),
  lastReadMessageId: json['last_read_message_id'] as String?,
  unreadMessages: (json['unread_messages'] as num).toInt(),
  user: UserResponse.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReadStateResponseToJson(ReadStateResponse instance) => <String, dynamic>{
  'last_delivered_at': _$JsonConverterToJson<Object, DateTime>(
    instance.lastDeliveredAt,
    const StreamDateTimeConverter().toJson,
  ),
  'last_delivered_message_id': instance.lastDeliveredMessageId,
  'last_read': const StreamDateTimeConverter().toJson(instance.lastRead),
  'last_read_message_id': instance.lastReadMessageId,
  'unread_messages': instance.unreadMessages,
  'user': instance.user.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
