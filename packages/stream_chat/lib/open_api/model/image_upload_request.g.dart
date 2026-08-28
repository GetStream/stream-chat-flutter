// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadRequest _$ImageUploadRequestFromJson(Map<String, dynamic> json) =>
    ImageUploadRequest(
      file: json['file'] as String?,
      uploadSizes: (json['upload_sizes'] as List<dynamic>?)
          ?.map((e) => ImageSize.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : OnlyUserID.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImageUploadRequestToJson(ImageUploadRequest instance) =>
    <String, dynamic>{
      'file': instance.file,
      'upload_sizes': instance.uploadSizes?.map((e) => e.toJson()).toList(),
      'user': instance.user?.toJson(),
    };
