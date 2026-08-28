// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUploadResponse _$FileUploadResponseFromJson(Map<String, dynamic> json) =>
    FileUploadResponse(
      duration: json['duration'] as String,
      file: json['file'] as String?,
      thumbUrl: json['thumb_url'] as String?,
    );

Map<String, dynamic> _$FileUploadResponseToJson(FileUploadResponse instance) =>
    <String, dynamic>{
      'duration': instance.duration,
      'file': instance.file,
      'thumb_url': instance.thumbUrl,
    };
