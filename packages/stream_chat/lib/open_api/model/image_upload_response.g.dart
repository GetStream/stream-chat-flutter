// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ImageUploadResponse _$ImageUploadResponseFromJson(Map<String, dynamic> json) =>
    ImageUploadResponse(
      duration: json['duration'] as String,
      file: json['file'] as String?,
      thumbUrl: json['thumb_url'] as String?,
      uploadSizes: (json['upload_sizes'] as List<dynamic>?)
          ?.map((e) => ImageSize.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ImageUploadResponseToJson(
  ImageUploadResponse instance,
) => <String, dynamic>{
  'duration': instance.duration,
  'file': instance.file,
  'thumb_url': instance.thumbUrl,
  'upload_sizes': instance.uploadSizes?.map((e) => e.toJson()).toList(),
};
