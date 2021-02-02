/// Used to notify the WS connection status
enum ConnectionStatus {
  /// WS is connected and everything is good
  connected,

  /// WS is connecting (usually reconnecting)
  connecting,

  /// WS is disconnected and it's not reconnecting
  disconnected,
}
