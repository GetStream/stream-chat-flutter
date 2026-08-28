// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_action_config_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetActionConfigResponse _$GetActionConfigResponseFromJson(
  Map<String, dynamic> json,
) => GetActionConfigResponse(
  actionConfig: (json['action_config'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map(
            (e) => ModerationActionConfigResponse.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList(),
    ),
  ),
  duration: json['duration'] as String,
);

Map<String, dynamic> _$GetActionConfigResponseToJson(
  GetActionConfigResponse instance,
) => <String, dynamic>{
  'action_config': instance.actionConfig.map(
    (k, e) => MapEntry(k, e.map((e) => e.toJson()).toList()),
  ),
  'duration': instance.duration,
};
