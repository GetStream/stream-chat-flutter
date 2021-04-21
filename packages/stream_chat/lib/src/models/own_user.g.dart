// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'own_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OwnUser _$OwnUserFromJson(Map<String, dynamic> json) {
  return OwnUser(
    devices: (json['devices'] as List<dynamic>?)
            ?.map((e) => Device.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    mutes: (json['mutes'] as List<dynamic>?)
            ?.map((e) => Mute.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    totalUnreadCount: json['total_unread_count'] as int? ?? 0,
    unreadChannels: json['unread_channels'] as int?,
    channelMutes: (json['channel_mutes'] as List<dynamic>?)
            ?.map((e) => Mute.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
    id: json['id'] as String,
    role: json['role'] as String?,
    createdAt: json['created_at'] == null
        ? null
        : DateTime.parse(json['created_at'] as String),
    updatedAt: json['updated_at'] == null
        ? null
        : DateTime.parse(json['updated_at'] as String),
    lastActive: json['last_active'] == null
        ? null
        : DateTime.parse(json['last_active'] as String),
    online: json['online'] as bool? ?? false,
    extraData: (json['extra_data'] as Map<String, dynamic>).map(
      (k, e) => MapEntry(k, e as Object),
    ),
    banned: json['banned'] as bool? ?? false,
  );
}

Map<String, dynamic> _$OwnUserToJson(OwnUser instance) {
  final val = <String, dynamic>{
    'id': instance.id,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('role', readonly(instance.role));
  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('updated_at', readonly(instance.updatedAt));
  writeNotNull('last_active', readonly(instance.lastActive));
  writeNotNull('online', readonly(instance.online));
  writeNotNull('banned', readonly(instance.banned));
  val['extra_data'] = instance.extraData;
  writeNotNull('devices', readonly(instance.devices));
  writeNotNull('mutes', readonly(instance.mutes));
  writeNotNull('channel_mutes', readonly(instance.channelMutes));
  writeNotNull('total_unread_count', readonly(instance.totalUnreadCount));
  writeNotNull('unread_channels', readonly(instance.unreadChannels));
  return val;
}
