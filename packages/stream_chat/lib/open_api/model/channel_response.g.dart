// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelResponse _$ChannelResponseFromJson(
  Map<String, dynamic> json,
) => ChannelResponse(
  autoTranslationEnabled: json['auto_translation_enabled'] as bool?,
  autoTranslationLanguage: json['auto_translation_language'] as String?,
  blocked: json['blocked'] as bool?,
  cid: json['cid'] as String,
  config: json['config'] == null
      ? null
      : ChannelConfigWithInfo.fromJson(json['config'] as Map<String, dynamic>),
  cooldown: (json['cooldown'] as num?)?.toInt(),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null
      ? null
      : UserResponse.fromJson(json['created_by'] as Map<String, dynamic>),
  custom: json['custom'] as Map<String, dynamic>,
  deletedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['deleted_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  disabled: json['disabled'] as bool,
  filterTags: (json['filter_tags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  frozen: json['frozen'] as bool,
  hidden: json['hidden'] as bool?,
  hideMessagesBefore: _$JsonConverterFromJson<Object, DateTime>(
    json['hide_messages_before'],
    const StreamDateTimeConverter().fromJson,
  ),
  id: json['id'] as String,
  lastMessageAt: _$JsonConverterFromJson<Object, DateTime>(
    json['last_message_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  memberCount: (json['member_count'] as num?)?.toInt(),
  members: (json['members'] as List<dynamic>?)
      ?.map((e) => ChannelMemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  messageCount: (json['message_count'] as num?)?.toInt(),
  muteExpiresAt: _$JsonConverterFromJson<Object, DateTime>(
    json['mute_expires_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  muted: json['muted'] as bool?,
  ownCapabilities: (json['own_capabilities'] as List<dynamic>?)
      ?.map((e) => ChannelOwnCapability.fromJson(e as String))
      .toList(),
  team: json['team'] as String?,
  truncatedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['truncated_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  truncatedBy: json['truncated_by'] == null
      ? null
      : UserResponse.fromJson(json['truncated_by'] as Map<String, dynamic>),
  type: json['type'] as String,
  updatedAt: const StreamDateTimeConverter().fromJson(
    json['updated_at'] as Object,
  ),
);

Map<String, dynamic> _$ChannelResponseToJson(
  ChannelResponse instance,
) => <String, dynamic>{
  'auto_translation_enabled': instance.autoTranslationEnabled,
  'auto_translation_language': instance.autoTranslationLanguage,
  'blocked': instance.blocked,
  'cid': instance.cid,
  'config': instance.config?.toJson(),
  'cooldown': instance.cooldown,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy?.toJson(),
  'custom': instance.custom,
  'deleted_at': _$JsonConverterToJson<Object, DateTime>(
    instance.deletedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'disabled': instance.disabled,
  'filter_tags': instance.filterTags,
  'frozen': instance.frozen,
  'hidden': instance.hidden,
  'hide_messages_before': _$JsonConverterToJson<Object, DateTime>(
    instance.hideMessagesBefore,
    const StreamDateTimeConverter().toJson,
  ),
  'id': instance.id,
  'last_message_at': _$JsonConverterToJson<Object, DateTime>(
    instance.lastMessageAt,
    const StreamDateTimeConverter().toJson,
  ),
  'member_count': instance.memberCount,
  'members': instance.members?.map((e) => e.toJson()).toList(),
  'message_count': instance.messageCount,
  'mute_expires_at': _$JsonConverterToJson<Object, DateTime>(
    instance.muteExpiresAt,
    const StreamDateTimeConverter().toJson,
  ),
  'muted': instance.muted,
  'own_capabilities': instance.ownCapabilities?.map((e) => e.toJson()).toList(),
  'team': instance.team,
  'truncated_at': _$JsonConverterToJson<Object, DateTime>(
    instance.truncatedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'truncated_by': instance.truncatedBy?.toJson(),
  'type': instance.type,
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
