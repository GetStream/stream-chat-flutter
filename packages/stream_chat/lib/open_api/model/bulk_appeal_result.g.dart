// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_appeal_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkAppealResult _$BulkAppealResultFromJson(Map<String, dynamic> json) =>
    BulkAppealResult(
      appealId: json['appeal_id'] as String,
      appealItem: json['appeal_item'] == null
          ? null
          : AppealItemResponse.fromJson(
              json['appeal_item'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$BulkAppealResultToJson(BulkAppealResult instance) =>
    <String, dynamic>{
      'appeal_id': instance.appealId,
      'appeal_item': instance.appealItem?.toJson(),
    };
