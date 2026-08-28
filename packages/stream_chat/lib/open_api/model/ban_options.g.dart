// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ban_options.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BanOptions _$BanOptionsFromJson(Map<String, dynamic> json) => BanOptions(
  deleteMessages: json['delete_messages'] == null
      ? null
      : BanOptionsDeleteMessages.fromJson(json['delete_messages'] as String),
  duration: (json['duration'] as num?)?.toInt(),
  ipBan: json['ip_ban'] as bool?,
  reason: json['reason'] as String?,
  shadowBan: json['shadow_ban'] as bool?,
);

Map<String, dynamic> _$BanOptionsToJson(BanOptions instance) =>
    <String, dynamic>{
      'delete_messages': instance.deleteMessages?.toJson(),
      'duration': instance.duration,
      'ip_ban': instance.ipBan,
      'reason': instance.reason,
      'shadow_ban': instance.shadowBan,
    };
