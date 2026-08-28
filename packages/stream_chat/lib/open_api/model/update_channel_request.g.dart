// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateChannelRequest _$UpdateChannelRequestFromJson(
  Map<String, dynamic> json,
) => UpdateChannelRequest(
  acceptInvite: json['accept_invite'] as bool?,
  addFilterTags: (json['add_filter_tags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  addMembers: (json['add_members'] as List<dynamic>?)
      ?.map((e) => ChannelMemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  cooldown: (json['cooldown'] as num?)?.toInt(),
  data: json['data'] == null
      ? null
      : ChannelInputRequest.fromJson(json['data'] as Map<String, dynamic>),
  hideHistory: json['hide_history'] as bool?,
  hideHistoryBefore: _$JsonConverterFromJson<Object, DateTime>(
    json['hide_history_before'],
    const StreamDateTimeConverter().fromJson,
  ),
  invites: (json['invites'] as List<dynamic>?)
      ?.map((e) => ChannelMemberRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  message: json['message'] == null
      ? null
      : MessageRequest.fromJson(json['message'] as Map<String, dynamic>),
  rejectInvite: json['reject_invite'] as bool?,
  removeFilterTags: (json['remove_filter_tags'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  removeMembers: (json['remove_members'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  skipPush: json['skip_push'] as bool?,
);

Map<String, dynamic> _$UpdateChannelRequestToJson(
  UpdateChannelRequest instance,
) => <String, dynamic>{
  'accept_invite': instance.acceptInvite,
  'add_filter_tags': instance.addFilterTags,
  'add_members': instance.addMembers?.map((e) => e.toJson()).toList(),
  'cooldown': instance.cooldown,
  'data': instance.data?.toJson(),
  'hide_history': instance.hideHistory,
  'hide_history_before': _$JsonConverterToJson<Object, DateTime>(
    instance.hideHistoryBefore,
    const StreamDateTimeConverter().toJson,
  ),
  'invites': instance.invites?.map((e) => e.toJson()).toList(),
  'message': instance.message?.toJson(),
  'reject_invite': instance.rejectInvite,
  'remove_filter_tags': instance.removeFilterTags,
  'remove_members': instance.removeMembers,
  'skip_push': instance.skipPush,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
