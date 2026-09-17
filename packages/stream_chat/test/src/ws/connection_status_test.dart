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

    expect(ConnectionStatus.fromState(state), ConnectionStatus.connected);
  });

  test('ConnectionStatus reports every step of an attempt as connecting', () {
    expect(ConnectionStatus.fromState(const Connecting()), ConnectionStatus.connecting);
    expect(ConnectionStatus.fromState(const Authenticating()), ConnectionStatus.connecting);
  });

  test('ConnectionStatus reports a connection that is not open as disconnected', () {
    // Including one that was never opened: neither carries events.
    expect(ConnectionStatus.fromState(const Initialized()), ConnectionStatus.disconnected);
    expect(
      ConnectionStatus.fromState(const Disconnecting(source: UserInitiated())),
      ConnectionStatus.disconnected,
    );
    expect(
      ConnectionStatus.fromState(const Disconnected(source: ServerInitiated())),
      ConnectionStatus.disconnected,
    );
  });
}
