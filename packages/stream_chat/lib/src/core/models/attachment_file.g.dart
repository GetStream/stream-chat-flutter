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

Preparing _$PreparingFromJson(Map<String, dynamic> json) => Preparing(
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$PreparingToJson(Preparing instance) => <String, dynamic>{
  'runtimeType': instance.$type,
};

InProgress _$InProgressFromJson(Map<String, dynamic> json) => InProgress(
  uploaded: (json['uploaded'] as num).toInt(),
  total: (json['total'] as num).toInt(),
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$InProgressToJson(InProgress instance) => <String, dynamic>{
  'uploaded': instance.uploaded,
  'total': instance.total,
  'runtimeType': instance.$type,
};

Success _$SuccessFromJson(Map<String, dynamic> json) => Success(
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$SuccessToJson(Success instance) => <String, dynamic>{
  'runtimeType': instance.$type,
};

Failed _$FailedFromJson(Map<String, dynamic> json) => Failed(
  error: json['error'] as String,
  $type: json['runtimeType'] as String?,
);

Map<String, dynamic> _$FailedToJson(Failed instance) => <String, dynamic>{
  'error': instance.error,
  'runtimeType': instance.$type,
};
