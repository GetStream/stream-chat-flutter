// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentFile _$AttachmentFileFromJson(Map json) {
  return AttachmentFile(
    path: json['path'] as String,
    name: json['name'] as String,
    bytes: _fromString(json['bytes'] as String),
    size: json['size'] as int,
  );
}

Map<String, dynamic> _$AttachmentFileToJson(AttachmentFile instance) =>
    <String, dynamic>{
      'path': instance.path,
      'name': instance.name,
      'bytes': _toString(instance.bytes),
      'size': instance.size,
    };

_$InProgress _$_$InProgressFromJson(Map json) {
  return _$InProgress(
    uploaded: json['uploaded'] as int,
    total: json['total'] as int,
  );
}

Map<String, dynamic> _$_$InProgressToJson(_$InProgress instance) =>
    <String, dynamic>{
      'uploaded': instance.uploaded,
      'total': instance.total,
    };

_$Success _$_$SuccessFromJson(Map json) {
  return _$Success();
}

Map<String, dynamic> _$_$SuccessToJson(_$Success instance) =>
    <String, dynamic>{};

_$Failed _$_$FailedFromJson(Map json) {
  return _$Failed(
    error: json['error'] as String,
  );
}

Map<String, dynamic> _$_$FailedToJson(_$Failed instance) => <String, dynamic>{
      'error': instance.error,
    };
