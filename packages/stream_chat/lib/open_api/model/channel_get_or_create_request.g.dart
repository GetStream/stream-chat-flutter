// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_get_or_create_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelGetOrCreateRequest _$ChannelGetOrCreateRequestFromJson(
  Map<String, dynamic> json,
) => ChannelGetOrCreateRequest(
  data: json['data'] == null ? null : ChannelInput.fromJson(json['data'] as Map<String, dynamic>),
  hideForCreator: json['hide_for_creator'] as bool?,
  memberCustomInclude: (json['member_custom_include'] as List<dynamic>?)?.map((e) => e as String).toList(),
  members: json['members'] == null ? null : PaginationParams.fromJson(json['members'] as Map<String, dynamic>),
  messages: json['messages'] == null
      ? null
      : MessagePaginationParams.fromJson(
          json['messages'] as Map<String, dynamic>,
        ),
  presence: json['presence'] as bool?,
  state: json['state'] as bool?,
  threadUnreadCounts: json['thread_unread_counts'] as bool?,
  watch: json['watch'] as bool?,
  watchers: json['watchers'] == null ? null : PaginationParams.fromJson(json['watchers'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChannelGetOrCreateRequestToJson(
  ChannelGetOrCreateRequest instance,
) => <String, dynamic>{
  'data': instance.data?.toJson(),
  'hide_for_creator': instance.hideForCreator,
  'member_custom_include': instance.memberCustomInclude,
  'members': instance.members?.toJson(),
  'messages': instance.messages?.toJson(),
  'presence': instance.presence,
  'state': instance.state,
  'thread_unread_counts': instance.threadUnreadCounts,
  'watch': instance.watch,
  'watchers': instance.watchers?.toJson(),
};
