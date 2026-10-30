// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIIndicatorClearEvent _$AIIndicatorClearEventFromJson(
  Map<String, dynamic> json,
) => AIIndicatorClearEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AIIndicatorClearEventToJson(
  AIIndicatorClearEvent instance,
) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
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

AIIndicatorStopEvent _$AIIndicatorStopEventFromJson(
  Map<String, dynamic> json,
) => AIIndicatorStopEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AIIndicatorStopEventToJson(
  AIIndicatorStopEvent instance,
) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user?.toJson(),
};

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
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
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
  'user': instance.user?.toJson(),
};

AppUpdatedEvent _$AppUpdatedEventFromJson(Map<String, dynamic> json) => AppUpdatedEvent(
  app: AppEventResponse.fromJson(json['app'] as Map<String, dynamic>),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$AppUpdatedEventToJson(AppUpdatedEvent instance) => <String, dynamic>{
  'app': instance.app.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

ChannelCreatedEvent _$ChannelCreatedEventFromJson(
  Map<String, dynamic> json,
) => ChannelCreatedEvent(
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
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelCreatedEventToJson(
  ChannelCreatedEvent instance,
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
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

ChannelDeletedEvent _$ChannelDeletedEventFromJson(
  Map<String, dynamic> json,
) => ChannelDeletedEvent(
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
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelDeletedEventToJson(
  ChannelDeletedEvent instance,
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
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

ChannelForkedEvent _$ChannelForkedEventFromJson(
  Map<String, dynamic> json,
) => ChannelForkedEvent(
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
  fork: ChannelForkSummary.fromJson(json['fork'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelForkedEventToJson(ChannelForkedEvent instance) => <String, dynamic>{
  'channel': instance.channel.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'fork': instance.fork.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

ChannelFrozenEvent _$ChannelFrozenEventFromJson(Map<String, dynamic> json) => ChannelFrozenEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ChannelFrozenEventToJson(ChannelFrozenEvent instance) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

ChannelHiddenEvent _$ChannelHiddenEventFromJson(
  Map<String, dynamic> json,
) => ChannelHiddenEvent(
  channel: ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  channelCustom: json['channel_custom'] as Map<String, dynamic>?,
  channelId: json['channel_id'] as String?,
  channelMemberCount: (json['channel_member_count'] as num?)?.toInt(),
  channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  clearHistory: json['clear_history'] as bool,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelHiddenEventToJson(ChannelHiddenEvent instance) => <String, dynamic>{
  'channel': instance.channel.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'clear_history': instance.clearHistory,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

ChannelKickedEvent _$ChannelKickedEventFromJson(Map<String, dynamic> json) => ChannelKickedEvent(
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
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
);

Map<String, dynamic> _$ChannelKickedEventToJson(ChannelKickedEvent instance) => <String, dynamic>{
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
};

ChannelRewoundEvent _$ChannelRewoundEventFromJson(
  Map<String, dynamic> json,
) => ChannelRewoundEvent(
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
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  rewind: ChannelRewindResponse.fromJson(
    json['rewind'] as Map<String, dynamic>,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelRewoundEventToJson(
  ChannelRewoundEvent instance,
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
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'rewind': instance.rewind.toJson(),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

ChannelTruncatedEvent _$ChannelTruncatedEventFromJson(
  Map<String, dynamic> json,
) => ChannelTruncatedEvent(
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
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelTruncatedEventToJson(
  ChannelTruncatedEvent instance,
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
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

ChannelUnFrozenEvent _$ChannelUnFrozenEventFromJson(
  Map<String, dynamic> json,
) => ChannelUnFrozenEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ChannelUnFrozenEventToJson(
  ChannelUnFrozenEvent instance,
) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

ChannelUpdatedEvent _$ChannelUpdatedEventFromJson(
  Map<String, dynamic> json,
) => ChannelUpdatedEvent(
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
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelUpdatedEventToJson(
  ChannelUpdatedEvent instance,
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
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

ChannelVisibleEvent _$ChannelVisibleEventFromJson(
  Map<String, dynamic> json,
) => ChannelVisibleEvent(
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
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelVisibleEventToJson(
  ChannelVisibleEvent instance,
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
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

CustomEvent _$CustomEventFromJson(Map<String, dynamic> json) => CustomEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$CustomEventToJson(CustomEvent instance) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

DraftDeletedEvent _$DraftDeletedEventFromJson(Map<String, dynamic> json) => DraftDeletedEvent(
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  draft: json['draft'] == null ? null : DraftResponse.fromJson(json['draft'] as Map<String, dynamic>),
  parentId: json['parent_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$DraftDeletedEventToJson(DraftDeletedEvent instance) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'draft': instance.draft?.toJson(),
  'parent_id': instance.parentId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

DraftUpdatedEvent _$DraftUpdatedEventFromJson(Map<String, dynamic> json) => DraftUpdatedEvent(
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  draft: json['draft'] == null ? null : DraftResponse.fromJson(json['draft'] as Map<String, dynamic>),
  parentId: json['parent_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$DraftUpdatedEventToJson(DraftUpdatedEvent instance) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'draft': instance.draft?.toJson(),
  'parent_id': instance.parentId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

MaxStreakChangedEvent _$MaxStreakChangedEventFromJson(
  Map<String, dynamic> json,
) => MaxStreakChangedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$MaxStreakChangedEventToJson(
  MaxStreakChangedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

MemberAddedEvent _$MemberAddedEventFromJson(
  Map<String, dynamic> json,
) => MemberAddedEvent(
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
  member: ChannelMemberResponse.fromJson(
    json['member'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MemberAddedEventToJson(MemberAddedEvent instance) => <String, dynamic>{
  'channel': instance.channel.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'member': instance.member.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

MemberRemovedEvent _$MemberRemovedEventFromJson(
  Map<String, dynamic> json,
) => MemberRemovedEvent(
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
  member: ChannelMemberResponse.fromJson(
    json['member'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MemberRemovedEventToJson(MemberRemovedEvent instance) => <String, dynamic>{
  'channel': instance.channel.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'member': instance.member.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

MemberUpdatedEvent _$MemberUpdatedEventFromJson(
  Map<String, dynamic> json,
) => MemberUpdatedEvent(
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
  member: ChannelMemberResponse.fromJson(
    json['member'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MemberUpdatedEventToJson(MemberUpdatedEvent instance) => <String, dynamic>{
  'channel': instance.channel.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'member': instance.member.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

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
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
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

MessageDeliveredEvent _$MessageDeliveredEventFromJson(
  Map<String, dynamic> json,
) => MessageDeliveredEvent(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
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
  lastDeliveredAt: _$JsonConverterFromJson<Object, DateTime>(
    json['last_delivered_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  lastDeliveredMessageId: json['last_delivered_message_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageDeliveredEventToJson(
  MessageDeliveredEvent instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'last_delivered_at': _$JsonConverterToJson<Object, DateTime>(
    instance.lastDeliveredAt,
    const StreamDateTimeConverter().toJson,
  ),
  'last_delivered_message_id': instance.lastDeliveredMessageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

MessageNewEvent _$MessageNewEventFromJson(
  Map<String, dynamic> json,
) => MessageNewEvent(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
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
  groupedUnreadChannels: (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  parentAuthor: json['parent_author'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  threadParticipants: (json['thread_participants'] as List<dynamic>?)
      ?.map((e) => UserResponseCommonFields.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
  watcherCount: (json['watcher_count'] as num).toInt(),
);

Map<String, dynamic> _$MessageNewEventToJson(MessageNewEvent instance) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'message': instance.message.toJson(),
  'message_id': instance.messageId,
  'parent_author': instance.parentAuthor,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'thread_participants': instance.threadParticipants?.map((e) => e.toJson()).toList(),
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
  'user': instance.user?.toJson(),
  'watcher_count': instance.watcherCount,
};

MessageReadEvent _$MessageReadEventFromJson(Map<String, dynamic> json) => MessageReadEvent(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
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
  lastReadMessageId: json['last_read_message_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  thread: json['thread'] == null ? null : ThreadResponse.fromJson(json['thread'] as Map<String, dynamic>),
  type: json['type'] as String,
  user: json['user'] == null
      ? null
      : UserResponseCommonFields.fromJson(
          json['user'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$MessageReadEventToJson(MessageReadEvent instance) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'last_read_message_id': instance.lastReadMessageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'thread': instance.thread?.toJson(),
  'type': instance.type,
  'user': instance.user?.toJson(),
};

MessageUndeletedEvent _$MessageUndeletedEventFromJson(
  Map<String, dynamic> json,
) => MessageUndeletedEvent(
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
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
);

Map<String, dynamic> _$MessageUndeletedEventToJson(
  MessageUndeletedEvent instance,
) => <String, dynamic>{
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message': instance.message.toJson(),
  'message_id': instance.messageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
};

MessageUpdatedEvent _$MessageUpdatedEventFromJson(
  Map<String, dynamic> json,
) => MessageUpdatedEvent(
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
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  messageUpdate: json['message_update'] == null
      ? null
      : MessageUpdate.fromJson(json['message_update'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$MessageUpdatedEventToJson(
  MessageUpdatedEvent instance,
) => <String, dynamic>{
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message': instance.message.toJson(),
  'message_id': instance.messageId,
  'message_update': instance.messageUpdate?.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

ModerationCustomActionEvent _$ModerationCustomActionEventFromJson(
  Map<String, dynamic> json,
) => ModerationCustomActionEvent(
  actionId: json['action_id'] as String,
  actionOptions: json['action_options'] as Map<String, dynamic>?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reviewQueueItem: ReviewQueueItemResponse.fromJson(
    json['review_queue_item'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ModerationCustomActionEventToJson(
  ModerationCustomActionEvent instance,
) => <String, dynamic>{
  'action_id': instance.actionId,
  'action_options': instance.actionOptions,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message': instance.message?.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'review_queue_item': instance.reviewQueueItem.toJson(),
  'type': instance.type,
};

ModerationFlaggedEvent _$ModerationFlaggedEventFromJson(
  Map<String, dynamic> json,
) => ModerationFlaggedEvent(
  contentType: json['content_type'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  objectId: json['object_id'] as String,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ModerationFlaggedEventToJson(
  ModerationFlaggedEvent instance,
) => <String, dynamic>{
  'content_type': instance.contentType,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'object_id': instance.objectId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

ModerationMarkReviewedEvent _$ModerationMarkReviewedEventFromJson(
  Map<String, dynamic> json,
) => ModerationMarkReviewedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  item: ReviewQueueItemResponse.fromJson(json['item'] as Map<String, dynamic>),
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$ModerationMarkReviewedEventToJson(
  ModerationMarkReviewedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'item': instance.item.toJson(),
  'message': instance.message?.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

NotificationAddedToChannelEvent _$NotificationAddedToChannelEventFromJson(
  Map<String, dynamic> json,
) => NotificationAddedToChannelEvent(
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
  groupedUnreadChannels: (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  member: ChannelMemberResponse.fromJson(
    json['member'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationAddedToChannelEventToJson(
  NotificationAddedToChannelEvent instance,
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
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'member': instance.member.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
};

NotificationChannelDeletedEvent _$NotificationChannelDeletedEventFromJson(
  Map<String, dynamic> json,
) => NotificationChannelDeletedEvent(
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
  groupedUnreadChannels: (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationChannelDeletedEventToJson(
  NotificationChannelDeletedEvent instance,
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
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
};

NotificationChannelMutesUpdatedEvent _$NotificationChannelMutesUpdatedEventFromJson(Map<String, dynamic> json) =>
    NotificationChannelMutesUpdatedEvent(
      createdAt: const StreamDateTimeConverter().fromJson(
        json['created_at'] as Object,
      ),
      custom: json['custom'] as Map<String, dynamic>,
      me: OwnUserResponse.fromJson(json['me'] as Map<String, dynamic>),
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      type: json['type'] as String,
    );

Map<String, dynamic> _$NotificationChannelMutesUpdatedEventToJson(
  NotificationChannelMutesUpdatedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'me': instance.me.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

NotificationChannelPartialUpdatedEvent _$NotificationChannelPartialUpdatedEventFromJson(Map<String, dynamic> json) =>
    NotificationChannelPartialUpdatedEvent(
      channel: ChannelPartialUpdateResponse.fromJson(
        json['channel'] as Map<String, dynamic>,
      ),
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
      receivedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['received_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      team: json['team'] as String?,
      type: json['type'] as String,
    );

Map<String, dynamic> _$NotificationChannelPartialUpdatedEventToJson(
  NotificationChannelPartialUpdatedEvent instance,
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
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
};

NotificationChannelRewoundEvent _$NotificationChannelRewoundEventFromJson(
  Map<String, dynamic> json,
) => NotificationChannelRewoundEvent(
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
  groupedUnreadChannels: (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  rewind: ChannelRewindResponse.fromJson(
    json['rewind'] as Map<String, dynamic>,
  ),
  team: json['team'] as String?,
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationChannelRewoundEventToJson(
  NotificationChannelRewoundEvent instance,
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
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'rewind': instance.rewind.toJson(),
  'team': instance.team,
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
};

NotificationChannelTruncatedEvent _$NotificationChannelTruncatedEventFromJson(
  Map<String, dynamic> json,
) => NotificationChannelTruncatedEvent(
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
  groupedUnreadChannels: (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
);

Map<String, dynamic> _$NotificationChannelTruncatedEventToJson(
  NotificationChannelTruncatedEvent instance,
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
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'message': instance.message?.toJson(),
  'message_id': instance.messageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
};

NotificationInviteAcceptedEvent _$NotificationInviteAcceptedEventFromJson(
  Map<String, dynamic> json,
) => NotificationInviteAcceptedEvent(
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
  member: ChannelMemberResponse.fromJson(
    json['member'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationInviteAcceptedEventToJson(
  NotificationInviteAcceptedEvent instance,
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
  'member': instance.member.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

NotificationInviteRejectedEvent _$NotificationInviteRejectedEventFromJson(
  Map<String, dynamic> json,
) => NotificationInviteRejectedEvent(
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
  member: ChannelMemberResponse.fromJson(
    json['member'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationInviteRejectedEventToJson(
  NotificationInviteRejectedEvent instance,
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
  'member': instance.member.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

NotificationInvitedEvent _$NotificationInvitedEventFromJson(
  Map<String, dynamic> json,
) => NotificationInvitedEvent(
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
  member: ChannelMemberResponse.fromJson(
    json['member'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationInvitedEventToJson(
  NotificationInvitedEvent instance,
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
  'member': instance.member.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

NotificationMarkReadEvent _$NotificationMarkReadEventFromJson(
  Map<String, dynamic> json,
) => NotificationMarkReadEvent(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
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
  groupedUnreadChannels: (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  lastReadMessageId: json['last_read_message_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  thread: json['thread'] == null ? null : ThreadResponse.fromJson(json['thread'] as Map<String, dynamic>),
  threadId: json['thread_id'] as String?,
  totalUnreadCount: (json['total_unread_count'] as num).toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num).toInt(),
  unreadCount: (json['unread_count'] as num).toInt(),
  unreadThreadMessages: (json['unread_thread_messages'] as num?)?.toInt(),
  unreadThreads: (json['unread_threads'] as num?)?.toInt(),
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationMarkReadEventToJson(
  NotificationMarkReadEvent instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'last_read_message_id': instance.lastReadMessageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'thread': instance.thread?.toJson(),
  'thread_id': instance.threadId,
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
  'unread_thread_messages': instance.unreadThreadMessages,
  'unread_threads': instance.unreadThreads,
  'user': instance.user?.toJson(),
};

NotificationMarkUnreadEvent _$NotificationMarkUnreadEventFromJson(
  Map<String, dynamic> json,
) => NotificationMarkUnreadEvent(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
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
  firstUnreadMessageId: json['first_unread_message_id'] as String?,
  groupedUnreadChannels: (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  lastReadAt: _$JsonConverterFromJson<Object, DateTime>(
    json['last_read_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  lastReadMessageId: json['last_read_message_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  threadId: json['thread_id'] as String?,
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
  unreadMessages: (json['unread_messages'] as num?)?.toInt(),
  unreadThreadMessages: (json['unread_thread_messages'] as num?)?.toInt(),
  unreadThreads: (json['unread_threads'] as num?)?.toInt(),
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationMarkUnreadEventToJson(
  NotificationMarkUnreadEvent instance,
) => <String, dynamic>{
  'channel': instance.channel?.toJson(),
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'first_unread_message_id': instance.firstUnreadMessageId,
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'last_read_at': _$JsonConverterToJson<Object, DateTime>(
    instance.lastReadAt,
    const StreamDateTimeConverter().toJson,
  ),
  'last_read_message_id': instance.lastReadMessageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'thread_id': instance.threadId,
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
  'unread_messages': instance.unreadMessages,
  'unread_thread_messages': instance.unreadThreadMessages,
  'unread_threads': instance.unreadThreads,
  'user': instance.user?.toJson(),
};

NotificationMutesUpdatedEvent _$NotificationMutesUpdatedEventFromJson(
  Map<String, dynamic> json,
) => NotificationMutesUpdatedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  me: OwnUserResponse.fromJson(json['me'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$NotificationMutesUpdatedEventToJson(
  NotificationMutesUpdatedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'me': instance.me.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

NotificationNewMessageEvent _$NotificationNewMessageEventFromJson(
  Map<String, dynamic> json,
) => NotificationNewMessageEvent(
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
  groupedUnreadChannels: (json['grouped_unread_channels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, (e as num).toInt()),
  ),
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  parentAuthor: json['parent_author'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  threadParticipants: (json['thread_participants'] as List<dynamic>?)
      ?.map((e) => UserResponseCommonFields.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalUnreadCount: (json['total_unread_count'] as num?)?.toInt(),
  type: json['type'] as String,
  unreadChannels: (json['unread_channels'] as num?)?.toInt(),
  unreadCount: (json['unread_count'] as num?)?.toInt(),
  watcherCount: (json['watcher_count'] as num).toInt(),
);

Map<String, dynamic> _$NotificationNewMessageEventToJson(
  NotificationNewMessageEvent instance,
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
  'grouped_unread_channels': instance.groupedUnreadChannels,
  'message': instance.message.toJson(),
  'message_id': instance.messageId,
  'parent_author': instance.parentAuthor,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'thread_participants': instance.threadParticipants?.map((e) => e.toJson()).toList(),
  'total_unread_count': instance.totalUnreadCount,
  'type': instance.type,
  'unread_channels': instance.unreadChannels,
  'unread_count': instance.unreadCount,
  'watcher_count': instance.watcherCount,
};

NotificationRemovedFromChannelEvent _$NotificationRemovedFromChannelEventFromJson(
  Map<String, dynamic> json,
) => NotificationRemovedFromChannelEvent(
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
  member: ChannelMemberResponse.fromJson(
    json['member'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NotificationRemovedFromChannelEventToJson(
  NotificationRemovedFromChannelEvent instance,
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
  'member': instance.member.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

NotificationThreadMessageNewEvent _$NotificationThreadMessageNewEventFromJson(
  Map<String, dynamic> json,
) => NotificationThreadMessageNewEvent(
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
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  parentAuthor: json['parent_author'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  threadId: json['thread_id'] as String,
  threadParticipants: (json['thread_participants'] as List<dynamic>?)
      ?.map((e) => UserResponseCommonFields.fromJson(e as Map<String, dynamic>))
      .toList(),
  type: json['type'] as String,
  unreadThreadMessages: (json['unread_thread_messages'] as num?)?.toInt(),
  unreadThreads: (json['unread_threads'] as num?)?.toInt(),
  watcherCount: (json['watcher_count'] as num).toInt(),
);

Map<String, dynamic> _$NotificationThreadMessageNewEventToJson(
  NotificationThreadMessageNewEvent instance,
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
  'message': instance.message.toJson(),
  'message_id': instance.messageId,
  'parent_author': instance.parentAuthor,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'thread_id': instance.threadId,
  'thread_participants': instance.threadParticipants?.map((e) => e.toJson()).toList(),
  'type': instance.type,
  'unread_thread_messages': instance.unreadThreadMessages,
  'unread_threads': instance.unreadThreads,
  'watcher_count': instance.watcherCount,
};

PendingMessageEvent _$PendingMessageEventFromJson(Map<String, dynamic> json) => PendingMessageEvent(
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  message: json['message'] == null ? null : MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  metadata: (json['metadata'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  method: json['method'] as String,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponse.fromJson(json['user'] as Map<String, dynamic>),
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

PollClosedEvent _$PollClosedEventFromJson(Map<String, dynamic> json) => PollClosedEvent(
  activityId: json['activity_id'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String?,
  poll: PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$PollClosedEventToJson(PollClosedEvent instance) => <String, dynamic>{
  'activity_id': instance.activityId,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'poll': instance.poll.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

PollDeletedEvent _$PollDeletedEventFromJson(Map<String, dynamic> json) => PollDeletedEvent(
  activityId: json['activity_id'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String?,
  poll: PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$PollDeletedEventToJson(PollDeletedEvent instance) => <String, dynamic>{
  'activity_id': instance.activityId,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'poll': instance.poll.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

PollUpdatedEvent _$PollUpdatedEventFromJson(Map<String, dynamic> json) => PollUpdatedEvent(
  activityId: json['activity_id'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String?,
  poll: PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$PollUpdatedEventToJson(PollUpdatedEvent instance) => <String, dynamic>{
  'activity_id': instance.activityId,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'poll': instance.poll.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

PollVoteCastedEvent _$PollVoteCastedEventFromJson(Map<String, dynamic> json) => PollVoteCastedEvent(
  activityId: json['activity_id'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String?,
  poll: PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
  pollVote: PollVoteResponseData.fromJson(
    json['poll_vote'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$PollVoteCastedEventToJson(
  PollVoteCastedEvent instance,
) => <String, dynamic>{
  'activity_id': instance.activityId,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'poll': instance.poll.toJson(),
  'poll_vote': instance.pollVote.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

PollVoteChangedEvent _$PollVoteChangedEventFromJson(
  Map<String, dynamic> json,
) => PollVoteChangedEvent(
  activityId: json['activity_id'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String?,
  poll: PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
  pollVote: PollVoteResponseData.fromJson(
    json['poll_vote'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$PollVoteChangedEventToJson(
  PollVoteChangedEvent instance,
) => <String, dynamic>{
  'activity_id': instance.activityId,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'poll': instance.poll.toJson(),
  'poll_vote': instance.pollVote.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

PollVoteRemovedEvent _$PollVoteRemovedEventFromJson(
  Map<String, dynamic> json,
) => PollVoteRemovedEvent(
  activityId: json['activity_id'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String?,
  poll: PollResponseData.fromJson(json['poll'] as Map<String, dynamic>),
  pollVote: PollVoteResponseData.fromJson(
    json['poll_vote'] as Map<String, dynamic>,
  ),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
);

Map<String, dynamic> _$PollVoteRemovedEventToJson(
  PollVoteRemovedEvent instance,
) => <String, dynamic>{
  'activity_id': instance.activityId,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'poll': instance.poll.toJson(),
  'poll_vote': instance.pollVote.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
};

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

ReactionNewEvent _$ReactionNewEventFromJson(
  Map<String, dynamic> json,
) => ReactionNewEvent(
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

Map<String, dynamic> _$ReactionNewEventToJson(ReactionNewEvent instance) => <String, dynamic>{
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

ReactionUpdatedEvent _$ReactionUpdatedEventFromJson(
  Map<String, dynamic> json,
) => ReactionUpdatedEvent(
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
  message: MessageResponse.fromJson(json['message'] as Map<String, dynamic>),
  messageId: json['message_id'] as String,
  reaction: json['reaction'] == null ? null : ReactionResponse.fromJson(json['reaction'] as Map<String, dynamic>),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ReactionUpdatedEventToJson(
  ReactionUpdatedEvent instance,
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
  'message': instance.message.toJson(),
  'message_id': instance.messageId,
  'reaction': instance.reaction?.toJson(),
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user?.toJson(),
};

ReminderCreatedEvent _$ReminderCreatedEventFromJson(
  Map<String, dynamic> json,
) => ReminderCreatedEvent(
  cid: json['cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String,
  parentId: json['parent_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reminder: ReminderResponseData.fromJson(
    json['reminder'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ReminderCreatedEventToJson(
  ReminderCreatedEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'parent_id': instance.parentId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'reminder': instance.reminder.toJson(),
  'type': instance.type,
  'user_id': instance.userId,
};

ReminderDeletedEvent _$ReminderDeletedEventFromJson(
  Map<String, dynamic> json,
) => ReminderDeletedEvent(
  cid: json['cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String,
  parentId: json['parent_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reminder: ReminderResponseData.fromJson(
    json['reminder'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ReminderDeletedEventToJson(
  ReminderDeletedEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'parent_id': instance.parentId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'reminder': instance.reminder.toJson(),
  'type': instance.type,
  'user_id': instance.userId,
};

ReminderNotificationEvent _$ReminderNotificationEventFromJson(
  Map<String, dynamic> json,
) => ReminderNotificationEvent(
  cid: json['cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String,
  parentId: json['parent_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reminder: ReminderResponseData.fromJson(
    json['reminder'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ReminderNotificationEventToJson(
  ReminderNotificationEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'parent_id': instance.parentId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'reminder': instance.reminder.toJson(),
  'type': instance.type,
  'user_id': instance.userId,
};

ReminderUpdatedEvent _$ReminderUpdatedEventFromJson(
  Map<String, dynamic> json,
) => ReminderUpdatedEvent(
  cid: json['cid'] as String,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  messageId: json['message_id'] as String,
  parentId: json['parent_id'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reminder: ReminderResponseData.fromJson(
    json['reminder'] as Map<String, dynamic>,
  ),
  type: json['type'] as String,
  userId: json['user_id'] as String,
);

Map<String, dynamic> _$ReminderUpdatedEventToJson(
  ReminderUpdatedEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'parent_id': instance.parentId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'reminder': instance.reminder.toJson(),
  'type': instance.type,
  'user_id': instance.userId,
};

ScheduledMessageCreatedEvent _$ScheduledMessageCreatedEventFromJson(
  Map<String, dynamic> json,
) => ScheduledMessageCreatedEvent(
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  scheduledMessage: json['scheduled_message'] == null
      ? null
      : ScheduledMessageResponse.fromJson(
          json['scheduled_message'] as Map<String, dynamic>,
        ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduledMessageCreatedEventToJson(
  ScheduledMessageCreatedEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'scheduled_message': instance.scheduledMessage?.toJson(),
  'type': instance.type,
  'user': instance.user.toJson(),
};

ScheduledMessageDeletedEvent _$ScheduledMessageDeletedEventFromJson(
  Map<String, dynamic> json,
) => ScheduledMessageDeletedEvent(
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  scheduledMessage: json['scheduled_message'] == null
      ? null
      : ScheduledMessageResponse.fromJson(
          json['scheduled_message'] as Map<String, dynamic>,
        ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduledMessageDeletedEventToJson(
  ScheduledMessageDeletedEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'scheduled_message': instance.scheduledMessage?.toJson(),
  'type': instance.type,
  'user': instance.user.toJson(),
};

ScheduledMessageFailedEvent _$ScheduledMessageFailedEventFromJson(
  Map<String, dynamic> json,
) => ScheduledMessageFailedEvent(
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  scheduledMessage: json['scheduled_message'] == null
      ? null
      : ScheduledMessageResponse.fromJson(
          json['scheduled_message'] as Map<String, dynamic>,
        ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduledMessageFailedEventToJson(
  ScheduledMessageFailedEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'scheduled_message': instance.scheduledMessage?.toJson(),
  'type': instance.type,
  'user': instance.user.toJson(),
};

ScheduledMessageSentEvent _$ScheduledMessageSentEventFromJson(
  Map<String, dynamic> json,
) => ScheduledMessageSentEvent(
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
  scheduledMessage: json['scheduled_message'] == null
      ? null
      : ScheduledMessageResponse.fromJson(
          json['scheduled_message'] as Map<String, dynamic>,
        ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduledMessageSentEventToJson(
  ScheduledMessageSentEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'message_id': instance.messageId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'scheduled_message': instance.scheduledMessage?.toJson(),
  'type': instance.type,
  'user': instance.user.toJson(),
};

ScheduledMessageUpdatedEvent _$ScheduledMessageUpdatedEventFromJson(
  Map<String, dynamic> json,
) => ScheduledMessageUpdatedEvent(
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  scheduledMessage: json['scheduled_message'] == null
      ? null
      : ScheduledMessageResponse.fromJson(
          json['scheduled_message'] as Map<String, dynamic>,
        ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ScheduledMessageUpdatedEventToJson(
  ScheduledMessageUpdatedEvent instance,
) => <String, dynamic>{
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'scheduled_message': instance.scheduledMessage?.toJson(),
  'type': instance.type,
  'user': instance.user.toJson(),
};

ThreadUpdatedEvent _$ThreadUpdatedEventFromJson(Map<String, dynamic> json) => ThreadUpdatedEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  thread: json['thread'] == null ? null : ThreadResponse.fromJson(json['thread'] as Map<String, dynamic>),
  type: json['type'] as String,
);

Map<String, dynamic> _$ThreadUpdatedEventToJson(ThreadUpdatedEvent instance) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'thread': instance.thread?.toJson(),
  'type': instance.type,
};

TypingStartEvent _$TypingStartEventFromJson(Map<String, dynamic> json) => TypingStartEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  member: json['member'] == null
      ? null
      : ChannelMemberPartialResponse.fromJson(
          json['member'] as Map<String, dynamic>,
        ),
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

Map<String, dynamic> _$TypingStartEventToJson(TypingStartEvent instance) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'member': instance.member?.toJson(),
  'parent_id': instance.parentId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user?.toJson(),
};

TypingStopEvent _$TypingStopEventFromJson(Map<String, dynamic> json) => TypingStopEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  member: json['member'] == null
      ? null
      : ChannelMemberPartialResponse.fromJson(
          json['member'] as Map<String, dynamic>,
        ),
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

Map<String, dynamic> _$TypingStopEventToJson(TypingStopEvent instance) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'member': instance.member?.toJson(),
  'parent_id': instance.parentId,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user?.toJson(),
};

UserBannedEvent _$UserBannedEventFromJson(Map<String, dynamic> json) => UserBannedEvent(
  channelCustom: json['channel_custom'] as Map<String, dynamic>?,
  channelId: json['channel_id'] as String?,
  channelMemberCount: (json['channel_member_count'] as num?)?.toInt(),
  channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null
      ? null
      : UserResponseCommonFields.fromJson(
          json['created_by'] as Map<String, dynamic>,
        ),
  custom: json['custom'] as Map<String, dynamic>,
  expiration: _$JsonConverterFromJson<Object, DateTime>(
    json['expiration'],
    const StreamDateTimeConverter().fromJson,
  ),
  reason: json['reason'] as String?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  reviewQueueItemId: json['review_queue_item_id'] as String?,
  shadow: json['shadow'] as bool?,
  team: json['team'] as String?,
  totalBans: (json['total_bans'] as num?)?.toInt(),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(
    json['user'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserBannedEventToJson(UserBannedEvent instance) => <String, dynamic>{
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy?.toJson(),
  'custom': instance.custom,
  'expiration': _$JsonConverterToJson<Object, DateTime>(
    instance.expiration,
    const StreamDateTimeConverter().toJson,
  ),
  'reason': instance.reason,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'review_queue_item_id': instance.reviewQueueItemId,
  'shadow': instance.shadow,
  'team': instance.team,
  'total_bans': instance.totalBans,
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserClaimedEvent _$UserClaimedEventFromJson(Map<String, dynamic> json) => UserClaimedEvent(
  claimedBy: UserResponseCommonFields.fromJson(
    json['claimed_by'] as Map<String, dynamic>,
  ),
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(
    json['user'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserClaimedEventToJson(UserClaimedEvent instance) => <String, dynamic>{
  'claimed_by': instance.claimedBy.toJson(),
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserDeactivatedEvent _$UserDeactivatedEventFromJson(
  Map<String, dynamic> json,
) => UserDeactivatedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null
      ? null
      : UserResponseCommonFields.fromJson(
          json['created_by'] as Map<String, dynamic>,
        ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserDeactivatedEventToJson(
  UserDeactivatedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy?.toJson(),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserDeletedEvent _$UserDeletedEventFromJson(Map<String, dynamic> json) => UserDeletedEvent(
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

Map<String, dynamic> _$UserDeletedEventToJson(UserDeletedEvent instance) => <String, dynamic>{
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

UserGroupCreatedEvent _$UserGroupCreatedEventFromJson(
  Map<String, dynamic> json,
) => UserGroupCreatedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
  userGroup: json['user_group'] == null ? null : UserGroup.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserGroupCreatedEventToJson(
  UserGroupCreatedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user?.toJson(),
  'user_group': instance.userGroup?.toJson(),
};

UserGroupDeletedEvent _$UserGroupDeletedEventFromJson(
  Map<String, dynamic> json,
) => UserGroupDeletedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
  userGroup: json['user_group'] == null ? null : UserGroup.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserGroupDeletedEventToJson(
  UserGroupDeletedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user?.toJson(),
  'user_group': instance.userGroup?.toJson(),
};

UserGroupMemberAddedEvent _$UserGroupMemberAddedEventFromJson(
  Map<String, dynamic> json,
) => UserGroupMemberAddedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  members: (json['members'] as List<dynamic>).map((e) => e as String).toList(),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
  userGroup: json['user_group'] == null ? null : UserGroup.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserGroupMemberAddedEventToJson(
  UserGroupMemberAddedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'members': instance.members,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user?.toJson(),
  'user_group': instance.userGroup?.toJson(),
};

UserGroupMemberRemovedEvent _$UserGroupMemberRemovedEventFromJson(
  Map<String, dynamic> json,
) => UserGroupMemberRemovedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  members: (json['members'] as List<dynamic>).map((e) => e as String).toList(),
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
  userGroup: json['user_group'] == null ? null : UserGroup.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserGroupMemberRemovedEventToJson(
  UserGroupMemberRemovedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'members': instance.members,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user?.toJson(),
  'user_group': instance.userGroup?.toJson(),
};

UserGroupUpdatedEvent _$UserGroupUpdatedEventFromJson(
  Map<String, dynamic> json,
) => UserGroupUpdatedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: json['user'] == null ? null : UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
  userGroup: json['user_group'] == null ? null : UserGroup.fromJson(json['user_group'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserGroupUpdatedEventToJson(
  UserGroupUpdatedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user?.toJson(),
  'user_group': instance.userGroup?.toJson(),
};

UserMessagesDeletedEvent _$UserMessagesDeletedEventFromJson(
  Map<String, dynamic> json,
) => UserMessagesDeletedEvent(
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
  hardDelete: json['hard_delete'] as bool?,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  team: json['team'] as String?,
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserMessagesDeletedEventToJson(
  UserMessagesDeletedEvent instance,
) => <String, dynamic>{
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'hard_delete': instance.hardDelete,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'team': instance.team,
  'type': instance.type,
  'user': instance.user.toJson(),
};

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

Map<String, dynamic> _$UserMutedEventToJson(UserMutedEvent instance) => <String, dynamic>{
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

UserPresenceChangedEvent _$UserPresenceChangedEventFromJson(
  Map<String, dynamic> json,
) => UserPresenceChangedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserPresenceChangedEventToJson(
  UserPresenceChangedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserReactivatedEvent _$UserReactivatedEventFromJson(
  Map<String, dynamic> json,
) => UserReactivatedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null
      ? null
      : UserResponseCommonFields.fromJson(
          json['created_by'] as Map<String, dynamic>,
        ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserReactivatedEventToJson(
  UserReactivatedEvent instance,
) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy?.toJson(),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserUnbannedEvent _$UserUnbannedEventFromJson(Map<String, dynamic> json) => UserUnbannedEvent(
  channelCustom: json['channel_custom'] as Map<String, dynamic>?,
  channelId: json['channel_id'] as String?,
  channelMemberCount: (json['channel_member_count'] as num?)?.toInt(),
  channelMessageCount: (json['channel_message_count'] as num?)?.toInt(),
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  createdBy: json['created_by'] == null
      ? null
      : UserResponseCommonFields.fromJson(
          json['created_by'] as Map<String, dynamic>,
        ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  shadow: json['shadow'] as bool?,
  team: json['team'] as String?,
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(
    json['user'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserUnbannedEventToJson(UserUnbannedEvent instance) => <String, dynamic>{
  'channel_custom': instance.channelCustom,
  'channel_id': instance.channelId,
  'channel_member_count': instance.channelMemberCount,
  'channel_message_count': instance.channelMessageCount,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'created_by': instance.createdBy?.toJson(),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'shadow': instance.shadow,
  'team': instance.team,
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserUpdatedEvent _$UserUpdatedEventFromJson(Map<String, dynamic> json) => UserUpdatedEvent(
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponsePrivacyFields.fromJson(
    json['user'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$UserUpdatedEventToJson(UserUpdatedEvent instance) => <String, dynamic>{
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
};

UserWatchingStartEvent _$UserWatchingStartEventFromJson(
  Map<String, dynamic> json,
) => UserWatchingStartEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
  watcherCount: (json['watcher_count'] as num).toInt(),
);

Map<String, dynamic> _$UserWatchingStartEventToJson(
  UserWatchingStartEvent instance,
) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
  'watcher_count': instance.watcherCount,
};

UserWatchingStopEvent _$UserWatchingStopEventFromJson(
  Map<String, dynamic> json,
) => UserWatchingStopEvent(
  channelId: json['channel_id'] as String?,
  channelType: json['channel_type'] as String?,
  cid: json['cid'] as String?,
  createdAt: const StreamDateTimeConverter().fromJson(
    json['created_at'] as Object,
  ),
  custom: json['custom'] as Map<String, dynamic>,
  receivedAt: _$JsonConverterFromJson<Object, DateTime>(
    json['received_at'],
    const StreamDateTimeConverter().fromJson,
  ),
  type: json['type'] as String,
  user: UserResponseCommonFields.fromJson(json['user'] as Map<String, dynamic>),
  watcherCount: (json['watcher_count'] as num).toInt(),
);

Map<String, dynamic> _$UserWatchingStopEventToJson(
  UserWatchingStopEvent instance,
) => <String, dynamic>{
  'channel_id': instance.channelId,
  'channel_type': instance.channelType,
  'cid': instance.cid,
  'created_at': const StreamDateTimeConverter().toJson(instance.createdAt),
  'custom': instance.custom,
  'received_at': _$JsonConverterToJson<Object, DateTime>(
    instance.receivedAt,
    const StreamDateTimeConverter().toJson,
  ),
  'type': instance.type,
  'user': instance.user.toJson(),
  'watcher_count': instance.watcherCount,
};
