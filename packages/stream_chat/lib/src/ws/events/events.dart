import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:stream_core/stream_core.dart';

import '../../core/models/own_user.dart';
import '../../event_type.dart';
import 'event.dart';

part 'events.freezed.dart';
part 'events.g.dart';

/// A WebSocket health check event for monitoring connection status.
///
/// Represents periodic health check messages sent by the Stream Chat WebSocket service to verify
/// connection stability and provide real-time connection monitoring. Contains connection metadata
/// and, on the message that opens the session, the signed-in user.
///
/// **Note:** This event is not specified in the OpenAPI spec, so we define it manually.
@Freezed(copyWith: false)
@JsonSerializable(createToJson: false)
class HealthCheckEvent extends Event with _$HealthCheckEvent {
  /// Creates a new [HealthCheckEvent] instance.
  HealthCheckEvent({
    required this.connectionId,
    super.createdAt,
    super.me,
    super.type = EventType.healthCheck,
  }) : super(connectionId: connectionId, isLocal: false);

  /// Creates a [HealthCheckEvent] from JSON data.
  factory HealthCheckEvent.fromJson(Map<String, dynamic> json) => _$HealthCheckEventFromJson(json);

  /// The unique identifier for this WebSocket connection.
  @override
  final String connectionId;

  /// Health check information for this connection.
  @override
  HealthCheckInfo get healthCheckInfo => HealthCheckInfo(connectionId: connectionId);
}

/// A WebSocket event sent when there is an error in the connection.
///
/// Represents connection errors and failures that occur during WebSocket communication with the
/// Stream Chat service. Contains the error describing why the connection could not be served.
///
/// **Note:** This event is not specified in the OpenAPI spec, so we define it manually.
@Freezed(copyWith: false)
@JsonSerializable(createToJson: false)
class ConnectionErrorEvent extends Event with _$ConnectionErrorEvent {
  /// Creates a new [ConnectionErrorEvent] instance.
  ConnectionErrorEvent({
    required this.error,
    super.createdAt,
    super.type = EventType.connectionError,
  }) : super(isLocal: false);

  /// Creates a [ConnectionErrorEvent] from JSON data.
  factory ConnectionErrorEvent.fromJson(Map<String, dynamic> json) => _$ConnectionErrorEventFromJson(json);

  /// The error information describing what went wrong.
  @override
  final StreamApiError error;
}
