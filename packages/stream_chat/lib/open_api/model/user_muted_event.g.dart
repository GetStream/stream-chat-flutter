// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_muted_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserMutedEvent _$UserMutedEventFromJson(
  Map<String, dynamic> json,
) => UserMutedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  targetUser: json['target_user'] == null
      ? null
      : UserResponseCommonFields.fromJson(
          json['target_user'] as Map<String, dynamic>,
        ),
  targetUsers: (json['target_users'] as List<dynamic>?)
      ?.map((e) => UserResponseCommonFields.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserMutedEventToJson(UserMutedEvent instance) =>
    <String, dynamic>{
      'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
      'custom': instance.custom,
      'received_at': _$JsonConverterToJson<Object, DateTime>(
        instance.receivedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'target_user': instance.targetUser?.toJson(),
      'target_users': instance.targetUsers?.map((e) => e.toJson()).toList(),
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
