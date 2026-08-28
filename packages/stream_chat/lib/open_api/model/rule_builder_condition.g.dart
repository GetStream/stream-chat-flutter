// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rule_builder_condition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RuleBuilderCondition _$RuleBuilderConditionFromJson(
  Map<String, dynamic> json,
) => RuleBuilderCondition(
  callCustomPropertyParams: json['call_custom_property_params'] == null
      ? null
      : CallCustomPropertyParameters.fromJson(
          json['call_custom_property_params'] as Map<String, dynamic>,
        ),
  callTypeRuleParams: json['call_type_rule_params'] == null
      ? null
      : CallTypeRuleParameters.fromJson(
          json['call_type_rule_params'] as Map<String, dynamic>,
        ),
  callViolationCountParams: json['call_violation_count_params'] == null
      ? null
      : CallViolationCountParameters.fromJson(
          json['call_violation_count_params'] as Map<String, dynamic>,
        ),
  channelMessageCountRuleParams:
      json['channel_message_count_rule_params'] == null
      ? null
      : ChannelMessageCountRuleParameters.fromJson(
          json['channel_message_count_rule_params'] as Map<String, dynamic>,
        ),
  closedCaptionRuleParams: json['closed_caption_rule_params'] == null
      ? null
      : ClosedCaptionRuleParameters.fromJson(
          json['closed_caption_rule_params'] as Map<String, dynamic>,
        ),
  confidence: (json['confidence'] as num?)?.toDouble(),
  contentCountRuleParams: json['content_count_rule_params'] == null
      ? null
      : ContentCountRuleParameters.fromJson(
          json['content_count_rule_params'] as Map<String, dynamic>,
        ),
  contentCustomPropertyCountParams:
      json['content_custom_property_count_params'] == null
      ? null
      : ContentCustomPropertyCountParameters.fromJson(
          json['content_custom_property_count_params'] as Map<String, dynamic>,
        ),
  contentCustomPropertyParams: json['content_custom_property_params'] == null
      ? null
      : ContentCustomPropertyParameters.fromJson(
          json['content_custom_property_params'] as Map<String, dynamic>,
        ),
  contentFlagCountRuleParams: json['content_flag_count_rule_params'] == null
      ? null
      : FlagCountRuleParameters.fromJson(
          json['content_flag_count_rule_params'] as Map<String, dynamic>,
        ),
  floodIdenticalParams: json['flood_identical_params'] == null
      ? null
      : FloodIdenticalRuleParameters.fromJson(
          json['flood_identical_params'] as Map<String, dynamic>,
        ),
  floodSimilarParams: json['flood_similar_params'] == null
      ? null
      : FloodSimilarRuleParameters.fromJson(
          json['flood_similar_params'] as Map<String, dynamic>,
        ),
  imageContentParams: json['image_content_params'] == null
      ? null
      : ImageContentParameters.fromJson(
          json['image_content_params'] as Map<String, dynamic>,
        ),
  imageRuleParams: json['image_rule_params'] == null
      ? null
      : ImageRuleParameters.fromJson(
          json['image_rule_params'] as Map<String, dynamic>,
        ),
  ipContentCountRuleParams: json['ip_content_count_rule_params'] == null
      ? null
      : IPContentCountRuleParameters.fromJson(
          json['ip_content_count_rule_params'] as Map<String, dynamic>,
        ),
  ipFlagCountRuleParams: json['ip_flag_count_rule_params'] == null
      ? null
      : IPFlagCountRuleParameters.fromJson(
          json['ip_flag_count_rule_params'] as Map<String, dynamic>,
        ),
  keyframeOcrRuleParams: json['keyframe_ocr_rule_params'] == null
      ? null
      : KeyframeOCRRuleParameters.fromJson(
          json['keyframe_ocr_rule_params'] as Map<String, dynamic>,
        ),
  keyframeRuleParams: json['keyframe_rule_params'] == null
      ? null
      : KeyframeRuleParameters.fromJson(
          json['keyframe_rule_params'] as Map<String, dynamic>,
        ),
  ocrContentParams: json['ocr_content_params'] == null
      ? null
      : OCRContentParameters.fromJson(
          json['ocr_content_params'] as Map<String, dynamic>,
        ),
  textContentParams: json['text_content_params'] == null
      ? null
      : TextContentParameters.fromJson(
          json['text_content_params'] as Map<String, dynamic>,
        ),
  textRuleParams: json['text_rule_params'] == null
      ? null
      : TextRuleParameters.fromJson(
          json['text_rule_params'] as Map<String, dynamic>,
        ),
  type: json['type'] as String?,
  userCreatedWithinParams: json['user_created_within_params'] == null
      ? null
      : UserCreatedWithinParameters.fromJson(
          json['user_created_within_params'] as Map<String, dynamic>,
        ),
  userCustomPropertyParams: json['user_custom_property_params'] == null
      ? null
      : UserCustomPropertyParameters.fromJson(
          json['user_custom_property_params'] as Map<String, dynamic>,
        ),
  userFlagCountRuleParams: json['user_flag_count_rule_params'] == null
      ? null
      : FlagCountRuleParameters.fromJson(
          json['user_flag_count_rule_params'] as Map<String, dynamic>,
        ),
  userIdenticalContentCountParams:
      json['user_identical_content_count_params'] == null
      ? null
      : UserIdenticalContentCountParameters.fromJson(
          json['user_identical_content_count_params'] as Map<String, dynamic>,
        ),
  userRoleParams: json['user_role_params'] == null
      ? null
      : UserRoleParameters.fromJson(
          json['user_role_params'] as Map<String, dynamic>,
        ),
  userRuleParams: json['user_rule_params'] == null
      ? null
      : UserRuleParameters.fromJson(
          json['user_rule_params'] as Map<String, dynamic>,
        ),
  videoContentParams: json['video_content_params'] == null
      ? null
      : VideoContentParameters.fromJson(
          json['video_content_params'] as Map<String, dynamic>,
        ),
  videoRuleParams: json['video_rule_params'] == null
      ? null
      : VideoRuleParameters.fromJson(
          json['video_rule_params'] as Map<String, dynamic>,
        ),
);

Map<String, dynamic> _$RuleBuilderConditionToJson(
  RuleBuilderCondition instance,
) => <String, dynamic>{
  'call_custom_property_params': instance.callCustomPropertyParams?.toJson(),
  'call_type_rule_params': instance.callTypeRuleParams?.toJson(),
  'call_violation_count_params': instance.callViolationCountParams?.toJson(),
  'channel_message_count_rule_params': instance.channelMessageCountRuleParams
      ?.toJson(),
  'closed_caption_rule_params': instance.closedCaptionRuleParams?.toJson(),
  'confidence': instance.confidence,
  'content_count_rule_params': instance.contentCountRuleParams?.toJson(),
  'content_custom_property_count_params': instance
      .contentCustomPropertyCountParams
      ?.toJson(),
  'content_custom_property_params': instance.contentCustomPropertyParams
      ?.toJson(),
  'content_flag_count_rule_params': instance.contentFlagCountRuleParams
      ?.toJson(),
  'flood_identical_params': instance.floodIdenticalParams?.toJson(),
  'flood_similar_params': instance.floodSimilarParams?.toJson(),
  'image_content_params': instance.imageContentParams?.toJson(),
  'image_rule_params': instance.imageRuleParams?.toJson(),
  'ip_content_count_rule_params': instance.ipContentCountRuleParams?.toJson(),
  'ip_flag_count_rule_params': instance.ipFlagCountRuleParams?.toJson(),
  'keyframe_ocr_rule_params': instance.keyframeOcrRuleParams?.toJson(),
  'keyframe_rule_params': instance.keyframeRuleParams?.toJson(),
  'ocr_content_params': instance.ocrContentParams?.toJson(),
  'text_content_params': instance.textContentParams?.toJson(),
  'text_rule_params': instance.textRuleParams?.toJson(),
  'type': instance.type,
  'user_created_within_params': instance.userCreatedWithinParams?.toJson(),
  'user_custom_property_params': instance.userCustomPropertyParams?.toJson(),
  'user_flag_count_rule_params': instance.userFlagCountRuleParams?.toJson(),
  'user_identical_content_count_params': instance
      .userIdenticalContentCountParams
      ?.toJson(),
  'user_role_params': instance.userRoleParams?.toJson(),
  'user_rule_params': instance.userRuleParams?.toJson(),
  'video_content_params': instance.videoContentParams?.toJson(),
  'video_rule_params': instance.videoRuleParams?.toJson(),
};
