// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_channel_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadChannelResponse _$UploadChannelResponseFromJson(
  Map<String, dynamic> json,
) => UploadChannelResponse(
  duration: json['duration'] as String,
  file: json['file'] as String?,
  moderationAction: json['moderation_action'] as String?,
  thumbUrl: json['thumb_url'] as String?,
  uploadSizes: (json['upload_sizes'] as List<dynamic>?)
      ?.map((e) => ImageSize.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$UploadChannelResponseToJson(
  UploadChannelResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'file': instance.file,
  'moderation_action': instance.moderationAction,
  'thumb_url': instance.thumbUrl,
  'upload_sizes': instance.uploadSizes?.map((e) => e.toJson()).toList(),
};
