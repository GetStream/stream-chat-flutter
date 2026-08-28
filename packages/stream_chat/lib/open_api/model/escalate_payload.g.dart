// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'escalate_payload.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EscalatePayload _$EscalatePayloadFromJson(Map<String, dynamic> json) =>
    EscalatePayload(
      notes: json['notes'] as String?,
      priority: json['priority'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$EscalatePayloadToJson(EscalatePayload instance) =>
    <String, dynamic>{
      'notes': instance.notes,
      'priority': instance.priority,
      'reason': instance.reason,
    };
