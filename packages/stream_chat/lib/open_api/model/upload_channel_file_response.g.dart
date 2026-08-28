// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_channel_file_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadChannelFileResponse _$UploadChannelFileResponseFromJson(
  Map<String, dynamic> json,
) => UploadChannelFileResponse(
  duration: json['duration'] as String,
  file: json['file'] as String?,
  moderationAction: json['moderation_action'] as String?,
  thumbUrl: json['thumb_url'] as String?,
);

Map<String, dynamic> _$UploadChannelFileResponseToJson(
  UploadChannelFileResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'file': instance.file,
  'moderation_action': instance.moderationAction,
  'thumb_url': instance.thumbUrl,
};
