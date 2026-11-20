// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OCRRule _$OCRRuleFromJson(Map<String, dynamic> json) => OCRRule(
  action: json['action'] as ModerationAction,
  label: json['label'] as String,
);

Map<String, dynamic> _$OCRRuleToJson(OCRRule instance) => <String, dynamic>{
  'action': instance.action,
  'label': instance.label,
};
