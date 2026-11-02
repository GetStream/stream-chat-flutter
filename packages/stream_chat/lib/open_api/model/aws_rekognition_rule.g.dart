// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aws_rekognition_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AWSRekognitionRule _$AWSRekognitionRuleFromJson(Map<String, dynamic> json) => AWSRekognitionRule(
  action: json['action'] as ModerationAction,
  label: json['label'] as String,
  minConfidence: (json['min_confidence'] as num).toDouble(),
  subclassifications: json['subclassifications'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$AWSRekognitionRuleToJson(AWSRekognitionRule instance) => <String, dynamic>{
  'action': instance.action,
  'label': instance.label,
  'min_confidence': instance.minConfidence,
  'subclassifications': instance.subclassifications,
};
