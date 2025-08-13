// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelState _$ChannelStateFromJson(Map<String, dynamic> json) => ChannelState(
      channel: json['channel'] == null
          ? null
          : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      pinnedMessages: (json['pinned_messages'] as List<dynamic>?)
          ?.map((e) => Message.fromJson(e as Map<String, dynamic>))
          .toList(),
      watcherCount: (json['watcher_count'] as num?)?.toInt(),
      watchers: (json['watchers'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
      read: (json['read'] as List<dynamic>?)
          ?.map((e) => Read.fromJson(e as Map<String, dynamic>))
          .toList(),
      membership: json['membership'] == null
          ? null
          : Member.fromJson(json['membership'] as Map<String, dynamic>),
      draft: json['draft'] == null
          ? null
          : Draft.fromJson(json['draft'] as Map<String, dynamic>),
      pushPreferences: json['push_preferences'] == null
          ? null
          : ChannelPushPreference.fromJson(
              json['push_preferences'] as Map<String, dynamic>),
  activeLiveLocations: (json['active_live_locations'] as List<dynamic>?)
      ?.map((e) => Location.fromJson(e as Map<String, dynamic>))
      .toList(),
    );

Map<String, dynamic> _$ChannelStateToJson(ChannelState instance) =>
    <String, dynamic>{
      'channel': instance.channel?.toJson(),
      'messages': instance.messages?.map((e) => e.toJson()).toList(),
      'members': instance.members?.map((e) => e.toJson()).toList(),
      'pinned_messages':
          instance.pinnedMessages?.map((e) => e.toJson()).toList(),
      'watcher_count': instance.watcherCount,
      'watchers': instance.watchers?.map((e) => e.toJson()).toList(),
      'read': instance.read?.map((e) => e.toJson()).toList(),
      'membership': instance.membership?.toJson(),
      'draft': instance.draft?.toJson(),
      'push_preferences': instance.pushPreferences?.toJson(),
      'active_live_locations':
      instance.activeLiveLocations?.map((e) => e.toJson()).toList(),
    };
