// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_deleted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDeletedEvent _$UserDeletedEventFromJson(Map<String, dynamic> json) =>
    UserDeletedEvent(
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      deleteConversation: json['delete_conversation'] as String,
      deleteConversationChannels: json['delete_conversation_channels'] as bool,
      deleteMessages: json['delete_messages'] as String,
      deleteUser: json['delete_user'] as String,
      hardDelete: json['hard_delete'] as bool,
      markMessagesDeleted: json['mark_messages_deleted'] as bool,
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      type: json['type'] as String,
      user: UserResponseCommonFields.fromJson(
        json['user'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$UserDeletedEventToJson(UserDeletedEvent instance) =>
    <String, dynamic>{
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'delete_conversation': instance.deleteConversation,
      'delete_conversation_channels': instance.deleteConversationChannels,
      'delete_messages': instance.deleteMessages,
      'delete_user': instance.deleteUser,
      'hard_delete': instance.hardDelete,
      'mark_messages_deleted': instance.markMessagesDeleted,
      'received_at': _$JsonConverterToJson<Object, DateTime>(
        instance.receivedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'type': instance.type,
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
