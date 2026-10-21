// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_content_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextContentParameters _$TextContentParametersFromJson(
  Map<String, dynamic> json,
) => TextContentParameters(
  blocklistMatch: (json['blocklist_match'] as List<dynamic>?)?.map((e) => e as String).toList(),
  containsUrl: json['contains_url'] as bool?,
  harmLabels: (json['harm_labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
  labelOperator: json['label_operator'] as String?,
  llmHarmLabels: (json['llm_harm_labels'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  severity: json['severity'] as String?,
  textLength: (json['text_length'] as num?)?.toInt(),
  textLengthOperator: json['text_length_operator'] as String?,
);

Map<String, dynamic> _$TextContentParametersToJson(
  TextContentParameters instance,
) => <String, dynamic>{
  'blocklist_match': instance.blocklistMatch,
  'contains_url': instance.containsUrl,
  'harm_labels': instance.harmLabels,
  'label_operator': instance.labelOperator,
  'llm_harm_labels': instance.llmHarmLabels,
  'severity': instance.severity,
  'text_length': instance.textLength,
  'text_length_operator': instance.textLengthOperator,
};
