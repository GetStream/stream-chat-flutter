// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_state_response_fields.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelStateResponseFields _$ChannelStateResponseFieldsFromJson(
  Map<String, dynamic> json,
) => ChannelStateResponseFields(
  activeLiveLocations: (json['active_live_locations'] as List<dynamic>?)
      ?.map(
        (e) => SharedLocationResponseData.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  channel: json['channel'] == null ? null : ChannelResponse.fromJson(json['channel'] as Map<String, dynamic>),
  draft: json['draft'] == null ? null : DraftResponse.fromJson(json['draft'] as Map<String, dynamic>),
  hidden: json['hidden'] as bool?,
  hideMessagesBefore: _$JsonConverterFromJson<Object, DateTime>(
    json['hide_messages_before'],
    const StreamDateTimeConverter().fromJson,
  ),
  members: (json['members'] as List<dynamic>)
      .map((e) => ChannelMemberResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  membership: json['membership'] == null
      ? null
      : ChannelMemberResponse.fromJson(
          json['membership'] as Map<String, dynamic>,
        ),
  messages: (json['messages'] as List<dynamic>)
      .map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  pendingMessages: (json['pending_messages'] as List<dynamic>?)
      ?.map((e) => PendingMessageResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  pinnedMessages: (json['pinned_messages'] as List<dynamic>)
      .map((e) => MessageResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  pushPreferences: json['push_preferences'] == null
      ? null
      : ChannelPushPreferencesResponse.fromJson(
          json['push_preferences'] as Map<String, dynamic>,
        ),
  read: (json['read'] as List<dynamic>?)?.map((e) => ReadStateResponse.fromJson(e as Map<String, dynamic>)).toList(),
  threads: (json['threads'] as List<dynamic>)
      .map((e) => ThreadStateResponse.fromJson(e as Map<String, dynamic>))
      .toList(),
  watcherCount: (json['watcher_count'] as num?)?.toInt(),
  watchers: (json['watchers'] as List<dynamic>?)?.map((e) => UserResponse.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$ChannelStateResponseFieldsToJson(
  ChannelStateResponseFields instance,
) => <String, dynamic>{
  'active_live_locations': instance.activeLiveLocations?.map((e) => e.toJson()).toList(),
  'channel': instance.channel?.toJson(),
  'draft': instance.draft?.toJson(),
  'hidden': instance.hidden,
  'hide_messages_before': _$JsonConverterToJson<Object, DateTime>(
    instance.hideMessagesBefore,
    const StreamDateTimeConverter().toJson,
  ),
  'members': instance.members.map((e) => e.toJson()).toList(),
  'membership': instance.membership?.toJson(),
  'messages': instance.messages.map((e) => e.toJson()).toList(),
  'pending_messages': instance.pendingMessages?.map((e) => e.toJson()).toList(),
  'pinned_messages': instance.pinnedMessages.map((e) => e.toJson()).toList(),
  'push_preferences': instance.pushPreferences?.toJson(),
  'read': instance.read?.map((e) => e.toJson()).toList(),
  'threads': instance.threads.map((e) => e.toJson()).toList(),
  'watcher_count': instance.watcherCount,
  'watchers': instance.watchers?.map((e) => e.toJson()).toList(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
