import 'package:meta/meta.dart';
import 'package:stream_core/stream_core.dart';

/// The connection a client works over.
enum ConnectionStatus {
  /// The connection is open and events are arriving.
  connected,

  /// A connection is being opened, either the first or one replacing a connection that dropped.
  connecting,

  /// No connection is open, and none is being opened.
  disconnected;

  /// The status a connection in [state] presents as.
  ///
  /// [isRecovering] is whether one that dropped is on its way back, which [state] does not say:
  /// one waiting to be reopened and one nothing will reopen read the same.
  ///
  /// A connection that has yet to be opened reads as [disconnected], the same as one that closed:
  /// neither carries events.
  @internal
  static ConnectionStatus fromState(
    WebSocketConnectionState state, {
    required bool isRecovering,
  }) => switch (state) {
    Connected() => connected,
    Connecting() || Authenticating() => connecting,
    Disconnecting() || Disconnected() when isRecovering => connecting,
    Initialized() || Disconnecting() || Disconnected() => disconnected,
  };
}
