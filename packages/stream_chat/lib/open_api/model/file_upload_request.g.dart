// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_upload_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileUploadRequest _$FileUploadRequestFromJson(Map<String, dynamic> json) =>
    FileUploadRequest(
      file: json['file'] as String?,
      user: json['user'] == null
          ? null
          : OnlyUserID.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FileUploadRequestToJson(FileUploadRequest instance) =>
    <String, dynamic>{'file': instance.file, 'user': instance.user?.toJson()};
