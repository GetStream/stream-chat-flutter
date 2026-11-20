// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ocr_content_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OCRContentParameters _$OCRContentParametersFromJson(
  Map<String, dynamic> json,
) => OCRContentParameters(
  harmLabels: (json['harm_labels'] as List<dynamic>?)?.map((e) => e as String).toList(),
  labelOperator: json['label_operator'] as String?,
  severity: json['severity'] as String?,
);

Map<String, dynamic> _$OCRContentParametersToJson(
  OCRContentParameters instance,
) => <String, dynamic>{
  'harm_labels': instance.harmLabels,
  'label_operator': instance.labelOperator,
  'severity': instance.severity,
};
