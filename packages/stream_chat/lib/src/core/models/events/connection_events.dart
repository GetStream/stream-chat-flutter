import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../stream_chat.dart';

part 'connection_events.freezed.dart';

/// An event received when a connection opens, naming the current user.
///
/// Handled by the client as the connection opens; it does not reach
/// [StreamChatClient.on].
@freezed
final class HealthCheckEvent extends ChatEvent with HasOwnUser, _$HealthCheckEvent {
  /// Creates a [HealthCheckEvent].
  HealthCheckEvent({
    required this.connectionId,
    required this.me,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.healthCheck;

  /// The id the connection is identified by while it stays open.
  @override
  final String connectionId;

  @override
  final OwnUser me;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event received when a connection is refused or closed with an error.
@freezed
final class ConnectionErrorEvent extends ChatEvent with _$ConnectionErrorEvent {
  /// Creates a [ConnectionErrorEvent].
  ConnectionErrorEvent({
    required this.error,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.connectionError;

  /// Why the connection was refused or closed.
  @override
  final StreamApiError error;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event emitted when the connection opens or closes.
@freezed
final class ConnectionChangedEvent extends ChatEvent with _$ConnectionChangedEvent {
  /// Creates a [ConnectionChangedEvent].
  ConnectionChangedEvent({
    required this.online,
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.connectionChanged;

  /// Whether the connection is open.
  @override
  final bool online;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}

/// An event emitted when a connection opens again after it dropped and missed
/// events are caught up.
@freezed
final class ConnectionRecoveredEvent extends ChatEvent with _$ConnectionRecoveredEvent {
  /// Creates a [ConnectionRecoveredEvent].
  ConnectionRecoveredEvent({
    DateTime? createdAt,
    this.custom = const {},
    this.isLocal = true,
  }) : createdAt = createdAt ?? DateTime.timestamp();

  @override
  String get type => EventType.connectionRecovered;

  @override
  final DateTime createdAt;

  @override
  final Map<String, Object?> custom;

  @override
  final bool isLocal;
}
