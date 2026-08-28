// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalation_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EscalationMetadata _$EscalationMetadataFromJson(Map<String, dynamic> json) =>
    EscalationMetadata(
      notes: json['notes'] as String?,
      priority: json['priority'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$EscalationMetadataToJson(EscalationMetadata instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'priority': instance.priority,
      'reason': instance.reason,
    };
