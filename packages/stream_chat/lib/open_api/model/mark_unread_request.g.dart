// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mark_unread_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarkUnreadRequest _$MarkUnreadRequestFromJson(Map<String, dynamic> json) => MarkUnreadRequest(
  messageId: json['message_id'] as String?,
  messageTimestamp: _$JsonConverterFromJson<Object, DateTime>(
    json['message_timestamp'],
    const StreamDateTimeConverter().fromJson,
  ),
  threadId: json['thread_id'] as String?,
);

Map<String, dynamic> _$MarkUnreadRequestToJson(MarkUnreadRequest instance) => <String, dynamic>{
  'message_id': instance.messageId,
  'message_timestamp': _$JsonConverterToJson<Object, DateTime>(
    instance.messageTimestamp,
    const StreamDateTimeConverter().toJson,
  ),
  'thread_id': instance.threadId,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
