// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typing_stop_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypingStopEvent _$TypingStopEventFromJson(Map<String, dynamic> json) =>
    TypingStopEvent(
      channelId: json['channel_id'] as String?,
      channelType: json['channel_type'] as String?,
      cid: json['cid'] as String?,
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      parentId: json['parent_id'] as String?,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      type: json['type'] as String,
      user: json['user'] == null
          ? null
          : UserResponseCommonFields.fromJson(
              json['user'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$TypingStopEventToJson(TypingStopEvent instance) =>
    <String, dynamic>{
      'channel_id': instance.channelId,
      'channel_type': instance.channelType,
      'cid': instance.cid,
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'parent_id': instance.parentId,
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
