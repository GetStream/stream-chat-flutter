// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_image_label_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AIImageLabelDefinition _$AIImageLabelDefinitionFromJson(
  Map<String, dynamic> json,
) => AIImageLabelDefinition(
  description: json['description'] as String,
  group: json['group'] as String,
  key: json['key'] as String,
  label: json['label'] as String,
);

Map<String, dynamic> _$AIImageLabelDefinitionToJson(
  AIImageLabelDefinition instance,
) => <String, dynamic>{
  'description': instance.description,
  'group': instance.group,
  'key': instance.key,
  'label': instance.label,
};
