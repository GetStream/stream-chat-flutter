// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_action_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubmitActionResponse _$SubmitActionResponseFromJson(
  Map<String, dynamic> json,
) => SubmitActionResponse(
  appealItem: json['appeal_item'] == null
      ? null
      : AppealItemResponse.fromJson(
          json['appeal_item'] as Map<String, dynamic>,
        ),
  autoRestoreWarning: json['auto_restore_warning'] as String?,
  duration: json['duration'] as String,
  item: json['item'] == null
      ? null
      : ReviewQueueItemResponse.fromJson(json['item'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SubmitActionResponseToJson(
  SubmitActionResponse instance,
) => <String, dynamic>{
  'appeal_item': instance.appealItem?.toJson(),
  'auto_restore_warning': instance.autoRestoreWarning,
  'duration': instance.duration,
  'item': instance.item?.toJson(),
};
