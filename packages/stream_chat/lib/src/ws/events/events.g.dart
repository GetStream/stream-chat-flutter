// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'events.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HealthCheckEvent _$HealthCheckEventFromJson(Map<String, dynamic> json) => HealthCheckEvent(
  connectionId: json['connection_id'] as String,
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
  me: json['me'] == null ? null : OwnUser.fromJson(json['me'] as Map<String, dynamic>),
  type: json['type'] as String? ?? EventType.healthCheck,
);

ConnectionErrorEvent _$ConnectionErrorEventFromJson(
  Map<String, dynamic> json,
) => ConnectionErrorEvent(
  error: StreamApiError.fromJson(json['error'] as Map<String, dynamic>),
  createdAt: json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
  type: json['type'] as String? ?? EventType.connectionError,
);
