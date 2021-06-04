import 'package:stream_chat/src/core/http/connection_id_manager.dart';
import 'package:test/test.dart';

void main() {
  late ConnectionIdManager connectionIdManager;

  setUp(() {
    connectionIdManager = ConnectionIdManager();
  });

  tearDown(() {
    connectionIdManager.reset();
  });

  test('`setConnectionId` should set connectionId', () {
    expect(connectionIdManager.connectionId, isNull);
    expect(connectionIdManager.hasConnectionId, isFalse);

    const connectionId = 'test-connection-id';
    connectionIdManager.setConnectionId(connectionId);

    expect(connectionIdManager.connectionId, connectionId);
    expect(connectionIdManager.hasConnectionId, isTrue);
  });

  test('`reset` should clear the connectionId', () {
    const connectionId = 'test-connection-id';
    connectionIdManager.setConnectionId(connectionId);

    expect(connectionIdManager.connectionId, connectionId);
    expect(connectionIdManager.hasConnectionId, isTrue);

    connectionIdManager.reset();

    expect(connectionIdManager.connectionId, isNull);
    expect(connectionIdManager.hasConnectionId, isFalse);
  });
}
