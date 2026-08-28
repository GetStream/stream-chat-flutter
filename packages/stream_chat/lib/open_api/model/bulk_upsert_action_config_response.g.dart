// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_upsert_action_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkUpsertActionConfigResponse _$BulkUpsertActionConfigResponseFromJson(
  Map<String, dynamic> json,
) => BulkUpsertActionConfigResponse(
  actionConfigs: (json['action_configs'] as List<dynamic>)
      .map(
        (e) =>
            ModerationActionConfigResponse.fromJson(e as Map<String, dynamic>),
      )
      .toList(),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$BulkUpsertActionConfigResponseToJson(
  BulkUpsertActionConfigResponse instance,
) => <String, dynamic>{
  'action_configs': instance.actionConfigs.map((e) => e.toJson()).toList(),
  'duration': instance.duration,
};
