// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_content_parameters.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoContentParameters _$VideoContentParametersFromJson(
  Map<String, dynamic> json,
) => VideoContentParameters(
  harmLabels: (json['harm_labels'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  labelOperator: json['label_operator'] as String?,
);

Map<String, dynamic> _$VideoContentParametersToJson(
  VideoContentParameters instance,
) => <String, dynamic>{
  'harm_labels': instance.harmLabels,
  'label_operator': instance.labelOperator,
};
