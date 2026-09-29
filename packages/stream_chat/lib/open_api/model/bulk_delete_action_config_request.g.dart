// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bulk_delete_action_config_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BulkDeleteActionConfigRequest _$BulkDeleteActionConfigRequestFromJson(
  Map<String, dynamic> json,
) => BulkDeleteActionConfigRequest(
  ids: (json['ids'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$BulkDeleteActionConfigRequestToJson(
  BulkDeleteActionConfigRequest instance,
) => <String, dynamic>{'ids': instance.ids};
