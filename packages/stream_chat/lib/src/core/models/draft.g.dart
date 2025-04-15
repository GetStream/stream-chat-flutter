// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Draft _$DraftFromJson(Map<String, dynamic> json) => Draft(
      channelCid: json['channel_cid'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      message: DraftMessage.fromJson(json['message'] as Map<String, dynamic>),
      channel: json['channel'] == null
          ? null
          : ChannelModel.fromJson(json['channel'] as Map<String, dynamic>),
      parentId: json['parent_id'] as String?,
      parentMessage: json['parent_message'] == null
          ? null
          : Message.fromJson(json['parent_message'] as Map<String, dynamic>),
      quotedMessage: json['quoted_message'] == null
          ? null
          : Message.fromJson(json['quoted_message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DraftToJson(Draft instance) => <String, dynamic>{
      'channel_cid': instance.channelCid,
      'created_at': instance.createdAt.toIso8601String(),
      'message': instance.message.toJson(),
      if (instance.channel?.toJson() case final value?) 'channel': value,
      if (instance.parentId case final value?) 'parent_id': value,
      if (instance.parentMessage?.toJson() case final value?)
        'parent_message': value,
      if (instance.quotedMessage?.toJson() case final value?)
        'quoted_message': value,
    };
