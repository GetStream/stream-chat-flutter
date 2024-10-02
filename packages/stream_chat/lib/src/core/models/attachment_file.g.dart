// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentFile _$AttachmentFileFromJson(Map<String, dynamic> json) =>
    AttachmentFile(
      size: (json['size'] as num?)?.toInt(),
      path: json['path'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$AttachmentFileToJson(AttachmentFile instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'size': instance.size,
    };

_$PreparingImpl _$$PreparingImplFromJson(Map<String, dynamic> json) =>
    _$PreparingImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PreparingImplToJson(_$PreparingImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$InProgressImpl _$$InProgressImplFromJson(Map<String, dynamic> json) =>
    _$InProgressImpl(
      uploaded: (json['uploaded'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$InProgressImplToJson(_$InProgressImpl instance) =>
    <String, dynamic>{
      'uploaded': instance.uploaded,
      'total': instance.total,
      'runtimeType': instance.$type,
    };

_$SuccessImpl _$$SuccessImplFromJson(Map<String, dynamic> json) =>
    _$SuccessImpl(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SuccessImplToJson(_$SuccessImpl instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$FailedImpl _$$FailedImplFromJson(Map<String, dynamic> json) => _$FailedImpl(
      error: json['error'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$FailedImplToJson(_$FailedImpl instance) =>
    <String, dynamic>{
      'error': instance.error,
      'runtimeType': instance.$type,
    };
