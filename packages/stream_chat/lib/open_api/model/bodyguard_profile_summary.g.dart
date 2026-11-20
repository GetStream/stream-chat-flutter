// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bodyguard_profile_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BodyguardProfileSummary _$BodyguardProfileSummaryFromJson(
  Map<String, dynamic> json,
) => BodyguardProfileSummary(
  displayName: json['display_name'] as String?,
  name: json['name'] as String,
  textType: json['text_type'] as String?,
);

Map<String, dynamic> _$BodyguardProfileSummaryToJson(
  BodyguardProfileSummary instance,
) => <String, dynamic>{
  'display_name': instance.displayName,
  'name': instance.name,
  'text_type': instance.textType,
};
