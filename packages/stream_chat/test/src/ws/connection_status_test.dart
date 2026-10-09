import 'package:stream_chat/stream_chat.dart';
import 'package:stream_core/stream_core.dart'
    show
        Authenticating,
        Connected,
        Connecting,
        Disconnected,
        Disconnecting,
        Initialized,
        ServerInitiated,
        UserInitiated;
import 'package:test/test.dart';

void main() {
  test('ConnectionStatus reports an open connection as connected', () {
    const state = Connected(healthCheck: HealthCheckInfo(connectionId: 'test-connection-id'));

    expect(ConnectionStatus.fromState(state, isRecovering: false), ConnectionStatus.connected);
  });

  test('ConnectionStatus reports every step of an attempt as connecting', () {
    expect(ConnectionStatus.fromState(const Connecting(), isRecovering: false), ConnectionStatus.connecting);
    expect(ConnectionStatus.fromState(const Authenticating(), isRecovering: false), ConnectionStatus.connecting);
  });

  test('ConnectionStatus reports a connection nothing will reopen as disconnected', () {
    // Including one that was never opened: neither carries events.
    expect(ConnectionStatus.fromState(const Initialized(), isRecovering: false), ConnectionStatus.disconnected);
    expect(
      ConnectionStatus.fromState(const Disconnecting(source: UserInitiated()), isRecovering: false),
      ConnectionStatus.disconnected,
    );
    expect(
      ConnectionStatus.fromState(const Disconnected(source: UserInitiated()), isRecovering: false),
      ConnectionStatus.disconnected,
    );
  });

  test('ConnectionStatus reports a connection waiting to be reopened as connecting', () {
    // The socket sits here for the whole delay it retries with, which is most of an outage.
    expect(
      ConnectionStatus.fromState(const Disconnected(source: ServerInitiated()), isRecovering: true),
      ConnectionStatus.connecting,
    );
    expect(
      ConnectionStatus.fromState(const Disconnecting(source: ServerInitiated()), isRecovering: true),
      ConnectionStatus.connecting,
    );
  });

  test('ConnectionStatus reports a connection closed for a reason worth retrying as disconnected '
      'when nothing is retrying it', () {
    // A first attempt that failed, or one dropped while reconnection is paused. Reading the
    // source alone would report it as connecting, with nothing to move it off that.
    expect(
      ConnectionStatus.fromState(const Disconnected(source: ServerInitiated()), isRecovering: false),
      ConnectionStatus.disconnected,
    );
  });
}
