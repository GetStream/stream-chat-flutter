// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChannelModel _$ChannelModelFromJson(Map json) {
  return ChannelModel(
    id: json['id'] as String?,
    type: json['type'] as String?,
    cid: json['cid'] as String,
    config: ChannelConfig.fromJson(
        Map<String, dynamic>.from(json['config'] as Map)),
    createdBy: json['created_by'] == null
        ? null
        : User.fromJson((json['created_by'] as Map?)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    frozen: json['frozen'] as bool,
    lastMessageAt: json['last_message_at'] == null
        ? null
        : DateTime.parse(json['last_message_at'] as String),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
    deletedAt: json['deleted_at'] == null
        ? null
        : DateTime.parse(json['deleted_at'] as String),
    memberCount: json['member_count'] as int,
    extraData: (json['extra_data'] as Map?)?.map(
      (k, e) => MapEntry(k as String, e),
    ),
    team: json['team'] as String?,
  );
}

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
  writeNotNull('config', readonly(instance.config));
  writeNotNull('created_by', readonly(instance.createdBy));
  val['frozen'] = instance.frozen;
  writeNotNull('last_message_at', readonly(instance.lastMessageAt));
  writeNotNull('created_at', readonly(instance.createdAt));
  writeNotNull('updated_at', readonly(instance.updatedAt));
  writeNotNull('deleted_at', readonly(instance.deletedAt));
  writeNotNull('member_count', readonly(instance.memberCount));
  writeNotNull('extra_data', instance.extraData);
  writeNotNull('team', readonly(instance.team));
  return val;
}
