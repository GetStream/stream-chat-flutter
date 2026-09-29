// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_file.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttachmentFile _$AttachmentFileFromJson(Map<String, dynamic> json) => AttachmentFile(
  size: (json['size'] as num?)?.toInt(),
  path: json['path'] as String?,
  name: json['name'] as String?,
);

Map<String, dynamic> _$AttachmentFileToJson(AttachmentFile instance) => <String, dynamic>{
  'path': instance.path,
  'name': instance.name,
  'size': instance.size,
};

UploadStatePreparing _$UploadStatePreparingFromJson(
  Map<String, dynamic> json,
) => UploadStatePreparing($type: json['runtimeType'] as String?);

Map<String, dynamic> _$UploadStatePreparingToJson(
  UploadStatePreparing instance,
) => <String, dynamic>{'runtimeType': instance.$type};

UploadStateInProgress _$UploadStateInProgressFromJson(
  Map<String, dynamic> json,
) => UploadStateInProgress(
  uploaded: (json['uploaded'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$UploadStateInProgressToJson(
  UploadStateInProgress instance,
) => <String, dynamic>{
  'uploaded': instance.uploaded,
  'total': instance.total,
  'runtimeType': instance.$type,
};

UploadStateSuccess _$UploadStateSuccessFromJson(Map<String, dynamic> json) =>
    UploadStateSuccess($type: json['runtimeType'] as String?);

Map<String, dynamic> _$UploadStateSuccessToJson(UploadStateSuccess instance) => <String, dynamic>{
  'runtimeType': instance.$type,
};

UploadStateFailed _$UploadStateFailedFromJson(Map<String, dynamic> json) => UploadStateFailed(
  error: json['error'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$UploadStateFailedToJson(UploadStateFailed instance) => <String, dynamic>{
  'error': instance.error,
  'runtimeType': instance.$type,
};
