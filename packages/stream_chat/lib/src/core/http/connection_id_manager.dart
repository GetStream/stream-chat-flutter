// ignore_for_file: use_setters_to_change_properties

/// Handles the connection id of the websocket connection
class ConnectionIdManager {
  /// Initialize a new connection id manager
  ConnectionIdManager({
    String? connectionId,
  }) : _connectionId = connectionId;

  String? _connectionId;

  /// Get the current connection id
  String? get connectionId => _connectionId;

  /// True if there is a connection id
  bool get hasConnectionId => _connectionId != null;

  /// Set the connection id
  void setConnectionId(String connectionId) {
    _connectionId = connectionId;
  }

  /// Clear the connection id
  void reset() {
    _connectionId = null;
  }
}
