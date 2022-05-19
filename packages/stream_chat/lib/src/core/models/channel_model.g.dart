// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) => ChannelModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      cid: json['cid'] as String?,
      ownCapabilities: (json['own_capabilities'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      config: json['config'] == null
          ? null
          : ChannelConfig.fromJson(json['config'] as Map<String, dynamic>),
      createdBy: json['created_by'] == null
          ? null
          : User.fromJson(json['created_by'] as Map<String, dynamic>),
      frozen: json['frozen'] as bool? ?? false,
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
      memberCount: json['member_count'] as int? ?? 0,
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      team: json['team'] as String?,
      cooldown: json['cooldown'] as int? ?? 0,
      membership: json['membership'] == null
          ? null
          : Member.fromJson(json['membership'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) {
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
  writeNotNull('own_capabilities', readonly(instance.ownCapabilities));
  writeNotNull('config', readonly(instance.config));
  writeNotNull('created_by', readonly(instance.createdBy));
  val['frozen'] = instance.frozen;
  writeNotNull('last_message_at', readonly(instance.lastMessageAt));
  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('updated_at', readonly(instance.updatedAt));
  writeNotNull('deleted_at', readonly(instance.deletedAt));
  writeNotNull('member_count', readonly(instance.memberCount));
  val['cooldown'] = instance.cooldown;
  val['extra_data'] = instance.extraData;
  writeNotNull('team', readonly(instance.team));
  writeNotNull('membership', instance.membership?.toJson());
  return val;
}
