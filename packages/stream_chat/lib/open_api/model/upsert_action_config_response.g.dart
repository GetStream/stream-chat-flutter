// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upsert_action_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpsertActionConfigResponse _$UpsertActionConfigResponseFromJson(
  Map<String, dynamic> json,
) => UpsertActionConfigResponse(
  actionConfig: json['action_config'] == null
      ? null
      : ModerationActionConfigResponse.fromJson(
          json['action_config'] as Map<String, dynamic>,
        ),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$UpsertActionConfigResponseToJson(
  UpsertActionConfigResponse instance,
) => <String, dynamic>{
  'action_config': instance.actionConfig?.toJson(),
  'duration': instance.duration,
};
