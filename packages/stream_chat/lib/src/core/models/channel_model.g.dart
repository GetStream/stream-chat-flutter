// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map<String, dynamic> json) => ChannelModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      cid: json['cid'] as String?,
      ownCapabilities: ChannelModel._ownCapabilitiesFromJson(
          json['own_capabilities'] as List<String>?),
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
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      members: (json['members'] as List<dynamic>?)
          ?.map((e) => Member.fromJson(e as Map<String, dynamic>))
          .toList(),
      extraData: json['extra_data'] as Map<String, dynamic>? ?? const {},
      team: json['team'] as String?,
      cooldown: (json['cooldown'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ChannelModelToJson(ChannelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'frozen': instance.frozen,
      'cooldown': instance.cooldown,
      'extra_data': instance.extraData,
    };
