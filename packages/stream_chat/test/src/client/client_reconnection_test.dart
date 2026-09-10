// LEGACY CARVE-OUT: these tests intentionally stay on a hand-rolled fake
// WebSocket instead of the `stream_chat_test` BDD harness:
//
// - The `.connectAnonymousUser` tests: the anonymous token's user id cannot
//   pass the fake server's connect-URI validation without a TokenManager seam.
// - The reconnect-recovery tests: the harness exposes no seam to drop and
//   restore the underlying connection mid-test.
//
// Revisit once the TokenManager seam lands in the harness.

import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/ws/websocket.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_test/stream_chat_test.dart';

void main() {
  group('Fake web-socket connection functions', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(_FakeUser());
    });

    setUp(() {
      final ws = _FakeWebSocket();
      client = StreamChatClient(apiKey, ws: ws, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    test('`.connectAnonymousUser` should work fine', () async {
      expectLater(
        // skipping first seed status -> ConnectionStatus.disconnected
        client.wsConnectionStatusStream.skip(1),
        emitsInOrder([
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final res = await client.connectAnonymousUser();
      expect(res, isNotNull);
    });
  });

  group('Fake web-socket connection functions failure', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(_FakeUser());
    });

    setUp(() {
      final ws = _FakeWebSocketWithConnectionError();
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
    });

    tearDown(() {
      client.dispose();
    });

    test(
      '`.connectAnonymousUser` should throw if `ws.connect` fails',
      () async {
        try {
          await client.connectAnonymousUser();
        } catch (e) {
          expect(e, isA<StreamWebSocketError>());
        }
      },
    );
  });

  group('Connect user calls with `connectWebSocket`: false', () {
    const apiKey = 'test-api-key';
    late final api = FakeChatApi();

    late StreamChatClient client;

    setUpAll(() {
      // fallback values
      registerFallbackValue(_FakeUser());
    });

    setUp(() {
      client = StreamChatClient(apiKey, chatApi: api);
    });

    tearDown(() {
      client.dispose();
    });

    test(
      '`.connectAnonymousUser` should succeed without connecting',
      () async {
        final res = await client.connectAnonymousUser(
          connectWebSocket: false,
        );

        expect(res, isNotNull);
        expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
      },
    );
  });

  group('recoverStateOnReconnect', () {
    const apiKey = 'test-api-key';
    final user = User(id: 'test-user-id');
    final token = Token.development(user.id).rawValue;

    late FakeChatApi api;
    late _FakeWebSocket ws;
    late StreamChatClient client;

    setUpAll(() {
      registerFallbackValue(const PaginationParams());
      registerFallbackValue(Filter.equal('cid', ''));
    });

    setUp(() {
      api = FakeChatApi();
      ws = _FakeWebSocket();

      // Stub queryChannels for every test — it's the API the recovery path
      // calls when enabled, and a missing stub would surface as an unhandled
      // async error inside the connection-status listener.
      when(
        () => api.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((_) async => QueryChannelsResponse()..channels = []);
    });

    tearDown(() async {
      await client.dispose();
    });

    // Drives the _FakeWebSocket through a connected → disconnected → connected
    // transition so the client's pairwise listener fires the recovery path.
    Future<void> simulateReconnect() async {
      ws.connectionStatus = ConnectionStatus.disconnected;
      await delay(100);
      ws.connectionStatus = ConnectionStatus.connected;
      await delay(300);
    }

    test('should re-query active channels on reconnect when enabled (default)', () async {
      // Setup: connect with default flag, register two channels.
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      await client.connectUser(user, token);
      await delay(300);

      final channel1 = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      final channel2 = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c2')));
      client.state.addChannels({'messaging:c1': channel1, 'messaging:c2': channel2});

      // Drop interactions from the initial connect's (empty-channel) recovery
      // so we only count the reconnect call.
      clearInteractions(api.channel);

      await simulateReconnect();

      verify(
        () => api.channel.queryChannels(
          filter: Filter.in_('cid', const ['messaging:c1', 'messaging:c2']),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: const PaginationParams(limit: 30),
        ),
      ).called(1);
    });

    test('should skip the re-query on reconnect when disabled', () async {
      client = StreamChatClient(apiKey, chatApi: api, ws: ws, recoverStateOnReconnect: false);
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});
      clearInteractions(api.channel);

      await simulateReconnect();

      verifyNever(
        () => api.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      );
    });

    test('should still emit `connectionRecovered` when disabled', () async {
      client = StreamChatClient(apiKey, chatApi: api, ws: ws, recoverStateOnReconnect: false);
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});

      // Subscribe AFTER the initial connect so the captured event is the
      // one fired by the manual reconnect.
      final recoveredEvents = <Event>[];
      final sub = client.on(EventType.connectionRecovered).listen(recoveredEvents.add);

      await simulateReconnect();
      await sub.cancel();

      expect(recoveredEvents, hasLength(1));
    });

    // Recovery runs inside the client's own connection-status listener, so a
    // failure there has no future for the app to catch. It must be swallowed,
    // and must not stop `connectionRecovered` from firing.
    test('should not surface an error when the re-query fails', () async {
      when(
        () => api.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenThrow(const StreamChatError('You cannot use queryChannels without an active connection.'));

      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});

      // Subscribe AFTER the initial connect so the captured event is the
      // one fired by the manual reconnect.
      final recoveredEvents = <Event>[];
      final sub = client.on(EventType.connectionRecovered).listen(recoveredEvents.add);

      await simulateReconnect();
      await sub.cancel();

      expect(recoveredEvents, hasLength(1));
    });

    test('should skip the re-query when no active channels are tracked', () async {
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      await client.connectUser(user, token);
      await delay(300);

      // No channels added — the cids.isNotEmpty guard should short-circuit.
      clearInteractions(api.channel);

      await simulateReconnect();

      verifyNever(
        () => api.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      );
    });

    test('should respect runtime toggling via the setter', () async {
      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      await client.connectUser(user, token);
      await delay(300);

      final channel = Channel.fromState(client, ChannelState(channel: ChannelModel(cid: 'messaging:c1')));
      client.state.addChannels({'messaging:c1': channel});
      clearInteractions(api.channel);

      // Disable mid-flight → no re-query on reconnect.
      client.recoverStateOnReconnect = false;
      await simulateReconnect();
      verifyNever(
        () => api.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      );

      // Re-enable → re-query on the next reconnect.
      client.recoverStateOnReconnect = true;
      await simulateReconnect();
      verify(
        () => api.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).called(1);
    });
  });

  group('dispose during reconnect recovery', () {
    const apiKey = 'test-api-key';
    final user = User(id: 'test-user-id');
    final token = Token.development(user.id).rawValue;

    late FakeChatApi api;
    late _FakeWebSocket ws;
    late StreamChatClient client;
    var disposed = false;

    setUpAll(() {
      registerFallbackValue(const PaginationParams());
      registerFallbackValue(Filter.equal('cid', ''));
    });

    setUp(() {
      api = FakeChatApi();
      ws = _FakeWebSocket();
      disposed = false;
    });

    // The test disposes the client itself; avoid disposing it a second time.
    tearDown(() async {
      if (!disposed) await client.dispose();
    });

    // Disposing the client while a reconnect is still recovering must complete
    // cleanly: recovery work that finishes after disposal is discarded, never
    // surfacing as an error.
    test('disposing mid-recovery does not surface a late recovery event', () async {
      // Keep the recovery's channel query pending so the client is still
      // mid-recovery at the moment it is disposed.
      final pendingQuery = Completer<QueryChannelsResponse>();
      when(
        () => api.channel.queryChannels(
          filter: any(named: 'filter'),
          sort: any(named: 'sort'),
          state: any(named: 'state'),
          watch: any(named: 'watch'),
          presence: any(named: 'presence'),
          memberLimit: any(named: 'memberLimit'),
          messageLimit: any(named: 'messageLimit'),
          paginationParams: any(named: 'paginationParams'),
        ),
      ).thenAnswer((_) => pendingQuery.future);

      client = StreamChatClient(apiKey, chatApi: api, ws: ws);
      await client.connectUser(user, token);
      await delay(300);

      // Track a channel so reconnecting triggers channel recovery, which then
      // blocks on the pending query above.
      final channel = Channel.fromState(
        client,
        ChannelState(channel: ChannelModel(cid: 'messaging:c1')),
      );
      client.state.addChannels({'messaging:c1': channel});

      // Drop then restore the connection to start a reconnect recovery.
      ws.connectionStatus = ConnectionStatus.disconnected;
      await delay(100);
      ws.connectionStatus = ConnectionStatus.connected;
      await delay(100);

      // Dispose while the recovery is still in flight.
      await client.dispose();
      disposed = true;

      // Let the now-orphaned recovery finish. Its trailing work must be
      // discarded silently instead of thrown as an unhandled async error.
      pendingQuery.complete(QueryChannelsResponse()..channels = []);
      await delay(300);

      expect(client.wsConnectionStatus, ConnectionStatus.disconnected);
    });
  });
}

class _FakeUser extends Fake implements User {}

class _FakeWebSocket extends Fake implements WebSocket {
  late final _connectionStatusController = BehaviorSubject.seeded(
    ConnectionStatus.disconnected,
  );

  set connectionStatus(ConnectionStatus value) {
    _connectionStatusController.add(value);
  }

  @override
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  @override
  Stream<ConnectionStatus> get connectionStatusStream => _connectionStatusController.stream;

  @override
  Completer<Event>? connectionCompleter;

  @override
  Future<Event> connect(
    User user, {
    bool? includeUserDetails = true,
  }) async {
    connectionStatus = ConnectionStatus.connecting;
    final event = Event(
      type: EventType.healthCheck,
      connectionId: 'fake-connection-id',
      me: OwnUser.fromUser(user),
    );
    connectionCompleter = Completer()..complete(event);
    connectionStatus = ConnectionStatus.connected;
    return connectionCompleter!.future;
  }

  @override
  void disconnect() {
    connectionStatus = ConnectionStatus.disconnected;
    connectionCompleter = null;
  }

  @override
  Future<void> dispose() async {
    await _connectionStatusController.close();
  }
}

class _FakeWebSocketWithConnectionError extends Fake implements WebSocket {
  late final _connectionStatusController = BehaviorSubject.seeded(
    ConnectionStatus.disconnected,
  );

  set connectionStatus(ConnectionStatus value) {
    _connectionStatusController.add(value);
  }

  @override
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  @override
  Stream<ConnectionStatus> get connectionStatusStream => _connectionStatusController.stream;

  @override
  Completer<Event>? connectionCompleter;

  @override
  Future<Event> connect(
    User user, {
    bool? includeUserDetails = true,
  }) async {
    connectionStatus = ConnectionStatus.connecting;
    const error = StreamWebSocketError('Error Connecting');
    connectionCompleter = Completer()..completeError(error);
    return connectionCompleter!.future;
  }

  @override
  void disconnect() {
    connectionStatus = ConnectionStatus.disconnected;
    connectionCompleter = null;
  }

  @override
  Future<void> dispose() async {
    await _connectionStatusController.close();
  }
}

// Top level util function to delay the code execution
Future delay(num milliseconds) => Future.delayed(Duration(milliseconds: milliseconds.toInt()));
