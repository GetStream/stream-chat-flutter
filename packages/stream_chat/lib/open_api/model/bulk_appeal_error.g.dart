// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_appeal_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkAppealError _$BulkAppealErrorFromJson(Map<String, dynamic> json) =>
    BulkAppealError(
      appealId: json['appeal_id'] as String,
      error: json['error'] as String,
    );

Map<String, dynamic> _$BulkAppealErrorToJson(BulkAppealError instance) =>
    <String, dynamic>{'appeal_id': instance.appealId, 'error': instance.error};
