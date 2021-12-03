// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentFile _$AttachmentFileFromJson(Map<String, dynamic> json) =>
    AttachmentFile(
      size: json['size'] as int?,
      path: json['path'] as String?,
      name: json['name'] as String?,
      bytes: _fromString(json['bytes'] as String?),
    );

Map<String, dynamic> _$AttachmentFileToJson(AttachmentFile instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'bytes': _toString(instance.bytes),
      'size': instance.size,
    };

_$Preparing _$$PreparingFromJson(Map<String, dynamic> json) => _$Preparing(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$PreparingToJson(_$Preparing instance) =>
    <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$InProgress _$$InProgressFromJson(Map<String, dynamic> json) => _$InProgress(
      uploaded: json['uploaded'] as int,
      total: json['total'] as int,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$InProgressToJson(_$InProgress instance) =>
    <String, dynamic>{
      'uploaded': instance.uploaded,
      'total': instance.total,
      'runtimeType': instance.$type,
    };

_$Success _$$SuccessFromJson(Map<String, dynamic> json) => _$Success(
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$SuccessToJson(_$Success instance) => <String, dynamic>{
      'runtimeType': instance.$type,
    };

_$Failed _$$FailedFromJson(Map<String, dynamic> json) => _$Failed(
      error: json['error'] as String,
      $type: json['runtimeType'] as String?,
    );

Map<String, dynamic> _$$FailedToJson(_$Failed instance) => <String, dynamic>{
      'error': instance.error,
      'runtimeType': instance.$type,
    };
