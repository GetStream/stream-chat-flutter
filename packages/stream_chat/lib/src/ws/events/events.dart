import 'package:stream_core/stream_core.dart';

import '../../../open_api/models.dart' as api;
import '../../core/models/own_user.dart';
import '../../repository/mapper/event_users_mapper.dart';

/// A frame that keeps a connection alive, and the one that opens it.
///
/// The frame that opens a connection names the signed-in user in [me]; the
/// periodic ones that keep it alive name nobody.
class HealthCheckFrame extends WsEvent {
  /// Creates a [HealthCheckFrame] for the connection [connectionId].
  const HealthCheckFrame({required this.connectionId, this.createdAt, this.me});

  /// Creates a [HealthCheckFrame] from a frame received on the connection.
  ///
  /// Reads only what it needs, so a frame that lacks a value nothing reads
  /// still keeps the connection alive.
  factory HealthCheckFrame.fromJson(Map<String, Object?> json) {
    return HealthCheckFrame(
      connectionId: json['connection_id']! as String,
      createdAt: switch (json['created_at']) {
        final Object createdAt => const StreamDateTimeConverter().fromJson(createdAt),
        null => null,
      },
      me: _meFromJson(json['me']),
    );
  }

  // The signed-in user the frame names, or null when it names none that can
  // be read, so the connection still opens.
  static OwnUser? _meFromJson(Object? json) {
    if (json is! Map<String, Object?>) return null;
    try {
      return api.OwnUserResponse.fromJson(json).toModel();
    } on Object {
      return null;
    }
  }

  /// The id the connection is identified by while it stays open.
  final String connectionId;

  /// When the frame was sent.
  final DateTime? createdAt;

  /// The signed-in user, on the frame that opens the connection.
  final OwnUser? me;

  @override
  HealthCheckInfo get healthCheckInfo => HealthCheckInfo(connectionId: connectionId);
}

/// A frame refusing or closing a connection with an error.
class ConnectionErrorFrame extends WsEvent {
  /// Creates a [ConnectionErrorFrame] reporting [error].
  const ConnectionErrorFrame({required this.error});

  /// Creates a [ConnectionErrorFrame] from a frame received on the connection.
  factory ConnectionErrorFrame.fromJson(Map<String, Object?> json) {
    return ConnectionErrorFrame(
      error: StreamApiError.fromJson(json['error']! as Map<String, Object?>),
    );
  }

  /// Why the connection was refused or closed.
  @override
  final StreamApiError error;
}
