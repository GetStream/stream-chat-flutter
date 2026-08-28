// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageRequest _$MessageRequestFromJson(Map<String, dynamic> json) =>
    MessageRequest(
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => Attachment.fromJson(e as Map<String, dynamic>))
          .toList(),
      custom: json['custom'] as Map<String, dynamic>?,
      id: json['id'] as String?,
      mentionedChannel: json['mentioned_channel'] as bool?,
      mentionedGroupIds: (json['mentioned_group_ids'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mentionedHere: json['mentioned_here'] as bool?,
      mentionedRoles: (json['mentioned_roles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mentionedUsers: (json['mentioned_users'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      mml: json['mml'] as String?,
      parentId: json['parent_id'] as String?,
      pinExpires: _$JsonConverterFromJson<Object, DateTime>(
        json['pin_expires'],
        const StreamDateTimeConverter().fromJson,
      ),
      pinned: json['pinned'] as bool?,
      pinnedAt: _$JsonConverterFromJson<Object, DateTime>(
        json['pinned_at'],
        const StreamDateTimeConverter().fromJson,
      ),
      pollId: json['poll_id'] as String?,
      quotedMessageId: json['quoted_message_id'] as String?,
      restrictedVisibility: (json['restricted_visibility'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      sharedLocation: json['shared_location'] == null
          ? null
          : SharedLocation.fromJson(
              json['shared_location'] as Map<String, dynamic>,
            ),
      showInChannel: json['show_in_channel'] as bool?,
      silent: json['silent'] as bool?,
      text: json['text'] as String?,
      type: json['type'] == null
          ? null
          : MessageRequestType.fromJson(json['type'] as String),
    );

Map<String, dynamic> _$MessageRequestToJson(MessageRequest instance) =>
    <String, dynamic>{
      'attachments': instance.attachments?.map((e) => e.toJson()).toList(),
      'custom': instance.custom,
      'id': instance.id,
      'mentioned_channel': instance.mentionedChannel,
      'mentioned_group_ids': instance.mentionedGroupIds,
      'mentioned_here': instance.mentionedHere,
      'mentioned_roles': instance.mentionedRoles,
      'mentioned_users': instance.mentionedUsers,
      'mml': instance.mml,
      'parent_id': instance.parentId,
      'pin_expires': _$JsonConverterToJson<Object, DateTime>(
        instance.pinExpires,
        const StreamDateTimeConverter().toJson,
      ),
      'pinned': instance.pinned,
      'pinned_at': _$JsonConverterToJson<Object, DateTime>(
        instance.pinnedAt,
        const StreamDateTimeConverter().toJson,
      ),
      'poll_id': instance.pollId,
      'quoted_message_id': instance.quotedMessageId,
      'restricted_visibility': instance.restrictedVisibility,
      'shared_location': instance.sharedLocation?.toJson(),
      'show_in_channel': instance.showInChannel,
      'silent': instance.silent,
      'text': instance.text,
      'type': instance.type?.toJson(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
