import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart';

/// The connection, at the level a caller acts on.
///
/// The three states this package reports. The WebSocket's own state says more — which step an
/// attempt is on, and why one closed — and stays inside the SDK.
enum ConnectionStatus {
  /// The connection is open and events are arriving.
  connected,

  /// A connection is being opened, either the first or one replacing a connection that dropped.
  connecting,

  /// No connection is open, and none is being opened.
  disconnected;

  /// The status [state] presents as.
  ///
  /// A connection that has yet to be opened reads as [disconnected], the same as one that closed:
  /// neither carries events.
  @internal
  static ConnectionStatus fromState(
    WebSocketConnectionState state,
  ) => switch (state) {
    Connected() => connected,
    Connecting() || Authenticating() => connecting,
    Initialized() || Disconnecting() || Disconnected() => disconnected,
  };
}

/// Reads the state a connection reports as the [ConnectionStatus] it presents as.
@internal
extension ConnectionStatusEmitterReads on ConnectionStateEmitter {
  /// The status the connection is in.
  ConnectionStatus get status => ConnectionStatus.fromState(value);

  /// [status] on listen, and again on each change.
  ///
  /// Reports once per change in status, so the steps a connection passes through on its way to
  /// being open do not each report one.
  Stream<ConnectionStatus> get statusStream => map(ConnectionStatus.fromState).distinct();
}
