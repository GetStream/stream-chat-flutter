// ignore_for_file: use_setters_to_change_properties

///
class ConnectionIdManager {
  ///
  ConnectionIdManager({
    String? connectionId,
  }) : _connectionId = connectionId;

  String? _connectionId;

  ///
  String? get connectionId => _connectionId;

  ///
  bool get hasConnectionId => _connectionId != null;

  ///
  void setConnectionId(String connectionId) {
    _connectionId = connectionId;
  }

  ///
  void reset() {
    _connectionId = null;
  }
}
