// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_image_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIImageConfig _$AIImageConfigFromJson(Map<String, dynamic> json) =>
    AIImageConfig(
      async: json['async'] as bool?,
      enabled: json['enabled'] as bool,
      ocrRules: (json['ocr_rules'] as List<dynamic>)
          .map((e) => OCRRule.fromJson(e as Map<String, dynamic>))
          .toList(),
      rules: (json['rules'] as List<dynamic>)
          .map((e) => AWSRekognitionRule.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AIImageConfigToJson(AIImageConfig instance) =>
    <String, dynamic>{
      'async': instance.async,
      'enabled': instance.enabled,
      'ocr_rules': instance.ocrRules.map((e) => e.toJson()).toList(),
      'rules': instance.rules.map((e) => e.toJson()).toList(),
    };
