// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map json) {
  return Event(
    type: json['type'] as String,
    cid: json['cid'] as String,
    connectionId: json['connection_id'] as String,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    me: json['me'] == null
        ? null
        : OwnUser.fromJson((json['me'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    user: json['user'] == null
        ? null
        : User.fromJson((json['user'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    message: json['message'] == null
        ? null
        : Message.fromJson((json['message'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    totalUnreadCount: json['total_unread_count'] as int,
    unreadChannels: json['unread_channels'] as int,
    reaction: json['reaction'] == null
        ? null
        : Reaction.fromJson((json['reaction'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    online: json['online'] as bool,
    channel: json['channel'] == null
        ? null
        : EventChannel.fromJson((json['channel'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    member: json['member'] == null
        ? null
        : Member.fromJson((json['member'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    channelId: json['channel_id'] as String,
    channelType: json['channel_type'] as String,
    parentId: json['parent_id'] as String,
    extraData: (json['extra_data'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
  )..isLocal = json['is_local'] as bool;
}

Map<String, dynamic> _$EventToJson(Event instance) {
  final val = <String, dynamic>{
    'type': instance.type,
    'cid': instance.cid,
    'channel_id': instance.channelId,
    'channel_type': instance.channelType,
    'connection_id': instance.connectionId,
    'created_at': instance.createdAt?.toIso8601String(),
    'me': instance.me?.toJson(),
    'user': instance.user?.toJson(),
    'message': instance.message?.toJson(),
    'channel': instance.channel?.toJson(),
    'member': instance.member?.toJson(),
    'reaction': instance.reaction?.toJson(),
    'total_unread_count': instance.totalUnreadCount,
    'unread_channels': instance.unreadChannels,
    'online': instance.online,
    'parent_id': instance.parentId,
    'is_local': instance.isLocal,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('extra_data', instance.extraData);
  return val;
}

EventChannel _$EventChannelFromJson(Map json) {
  return EventChannel(
    members: (json['members'] as List)
        ?.map((e) => e == null
            ? null
            : Member.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    id: json['id'] as String,
    type: json['type'] as String,
    cid: json['cid'] as String,
    config: json['config'] == null
        ? null
        : ChannelConfig.fromJson((json['config'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    createdBy: json['created_by'] == null
        ? null
        : User.fromJson((json['created_by'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    frozen: json['frozen'] as bool,
    lastMessageAt: json['last_message_at'] == null
        ? null
        : DateTime.parse(json['last_message_at'] as String),
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    deletedAt: json['deleted_at'] == null
        ? null
        : DateTime.parse(json['deleted_at'] as String),
    memberCount: json['member_count'] as int,
    extraData: (json['extra_data'] as Map)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
  );
}

Map<String, dynamic> _$EventChannelToJson(EventChannel instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'type': instance.type,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('cid', readonly(instance.cid));
  writeNotNull('config', readonly(instance.config));
  writeNotNull('created_by', readonly(instance.createdBy));
  writeNotNull('frozen', instance.frozen);
  writeNotNull('last_message_at', readonly(instance.lastMessageAt));
  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('updated_at', readonly(instance.updatedAt));
  writeNotNull('deleted_at', readonly(instance.deletedAt));
  writeNotNull('member_count', readonly(instance.memberCount));
  writeNotNull('extra_data', instance.extraData);
  val['members'] = instance.members?.map((e) => e?.toJson())?.toList();
  return val;
}
