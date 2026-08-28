// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_channel_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadChannelRequest _$UploadChannelRequestFromJson(
  Map<String, dynamic> json,
) => UploadChannelRequest(
  file: json['file'] as String?,
  uploadSizes: (json['upload_sizes'] as List<dynamic>?)
      ?.map((e) => ImageSize.fromJson(e as Map<String, dynamic>))
      .toList(),
  user: json['user'] == null
      ? null
      : OnlyUserID.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UploadChannelRequestToJson(
  UploadChannelRequest instance,
) => <String, dynamic>{
  'file': instance.file,
  'upload_sizes': instance.uploadSizes?.map((e) => e.toJson()).toList(),
  'user': instance.user?.toJson(),
};
