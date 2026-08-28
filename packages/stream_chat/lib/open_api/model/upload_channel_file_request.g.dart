// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_channel_file_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadChannelFileRequest _$UploadChannelFileRequestFromJson(
  Map<String, dynamic> json,
) => UploadChannelFileRequest(
  file: json['file'] as String?,
  user: json['user'] == null
      ? null
      : OnlyUserID.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UploadChannelFileRequestToJson(
  UploadChannelFileRequest instance,
) => <String, dynamic>{'file': instance.file, 'user': instance.user?.toJson()};
