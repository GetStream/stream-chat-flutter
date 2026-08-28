// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OCRRule _$OCRRuleFromJson(Map<String, dynamic> json) => OCRRule(
  action: OCRRuleAction.fromJson(json['action'] as String),
  label: json['label'] as String,
);

Map<String, dynamic> _$OCRRuleToJson(OCRRule instance) => <String, dynamic>{
  'action': instance.action.toJson(),
  'label': instance.label,
};
