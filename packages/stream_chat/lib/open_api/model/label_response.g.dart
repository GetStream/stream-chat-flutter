// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'label_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabelResponse _$LabelResponseFromJson(Map<String, dynamic> json) =>
    LabelResponse(
      harmLabels: (json['harm_labels'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      name: json['name'] as String,
      phraseListIds: (json['phrase_list_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$LabelResponseToJson(LabelResponse instance) =>
    <String, dynamic>{
      'harm_labels': instance.harmLabels,
      'name': instance.name,
      'phrase_list_ids': instance.phraseListIds,
    };
