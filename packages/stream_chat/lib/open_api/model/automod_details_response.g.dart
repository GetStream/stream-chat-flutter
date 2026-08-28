// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'automod_details_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AutomodDetailsResponse _$AutomodDetailsResponseFromJson(
  Map<String, dynamic> json,
) => AutomodDetailsResponse(
  action: json['action'] as String?,
  imageLabels: (json['image_labels'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  messageDetails: json['message_details'] == null
      ? null
      : FlagMessageDetailsResponse.fromJson(
          json['message_details'] as Map<String, dynamic>,
        ),
  originalMessageType: json['original_message_type'] as String?,
  result: json['result'] == null
      ? null
      : MessageModerationResult.fromJson(
          json['result'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$AutomodDetailsResponseToJson(
  AutomodDetailsResponse instance,
) => <String, dynamic>{
  'action': instance.action,
  'image_labels': instance.imageLabels,
  'message_details': instance.messageDetails?.toJson(),
  'original_message_type': instance.originalMessageType,
  'result': instance.result?.toJson(),
};
