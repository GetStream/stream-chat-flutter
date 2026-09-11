// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_upsert_action_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkUpsertActionConfigRequest _$BulkUpsertActionConfigRequestFromJson(
  Map<String, dynamic> json,
) => BulkUpsertActionConfigRequest(
  actionConfigs: (json['action_configs'] as List<dynamic>)
      .map((e) => UpsertActionConfigItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$BulkUpsertActionConfigRequestToJson(
  BulkUpsertActionConfigRequest instance,
) => <String, dynamic>{
  'action_configs': instance.actionConfigs.map((e) => e.toJson()).toList(),
};
