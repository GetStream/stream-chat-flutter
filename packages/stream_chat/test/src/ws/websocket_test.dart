import 'dart:async';
import 'dart:convert';

import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/ws/websocket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../fakes.dart';
import '../mocks.dart';

void main() {
  late TokenManager tokenManager;
  late WebSocketChannel webSocketChannel;
  late WebSocketSink webSocketSink;
  late WebSocket webSocket;

  setUp(() {
    tokenManager = FakeTokenManager();
    webSocketChannel = MockWebSocketChannel();

    WebSocketChannel channelProvider(
      Uri uri, {
      Iterable<String>? protocols,
    }) =>
        webSocketChannel;

    webSocket = WebSocket(
      apiKey: 'api-key',
      baseUrl: 'base-url',
      tokenManager: tokenManager,
      webSocketChannelProvider: channelProvider,
    );

    webSocketSink = MockWebSocketSink();
    when(() => webSocketChannel.sink).thenReturn(webSocketSink);

    var webSocketController = StreamController<String>.broadcast();
    when(() => webSocketChannel.stream).thenAnswer(
      (_) => webSocketController.stream,
    );
    when(() => webSocketSink.add(any())).thenAnswer((invocation) {
      webSocketController.add(invocation.positionalArguments.first);
    });
    when(() => webSocketSink.close(any(), any())).thenAnswer(
      (_) {
        final res = webSocketController.close();
        // re-initializing for future events
        webSocketController = StreamController<String>.broadcast();
        return res;
      },
    );
  });

  tearDown(() {
    tokenManager.reset();
    webSocket.disconnect();
  });

  test('`connect` successfully with the provided user', () async {
    final user = OwnUser(id: 'test-user');
    const connectionId = 'test-connection-id';
    // Sends connect event to web-socket stream
    final timer = Timer(const Duration(milliseconds: 300), () {
      final event = Event(
        type: EventType.healthCheck,
        connectionId: connectionId,
        me: user,
      );
      webSocketSink.add(json.encode(event));
    });

    expectLater(
      webSocket.connectionStatusStream,
      emitsInOrder([
        ConnectionStatus.disconnected,
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
      ]),
    );

    final event = await webSocket.connect(user);

    expect(event.type, EventType.healthCheck);
    expect(event.connectionId, connectionId);
    expect(event.me, isNotNull);
    expect(event.me!.id, user.id);

    addTearDown(timer.cancel);
  });

  test('`connect` should throw if already in connection attempt', () async {
    final user = OwnUser(id: 'test-user');
    webSocket.connect(user);
    try {
      // calling again before previous attempt finishes
      await webSocket.connect(user);
    } catch (e) {
      expect(e, isA<StreamWebSocketError>());
    }
  });

  test('`connect` should throw if `onMessage` contains error', () async {
    final user = OwnUser(id: 'test-user');
    final error = ErrorResponse()
      ..code = 333
      ..message = 'Invalid request';
    // Sends error event to web-socket stream
    final timer = Timer(const Duration(milliseconds: 300), () {
      webSocketSink.add(json.encode({'error': error}));
    });

    expectLater(
      webSocket.connectionStatusStream,
      emitsInOrder([
        ConnectionStatus.disconnected,
        ConnectionStatus.connecting,
        ConnectionStatus.disconnected,
      ]),
    );

    try {
      await webSocket.connect(user);
    } catch (e) {
      expect(e, isA<StreamWebSocketError>());
      final err = e as StreamWebSocketError;
      expect(err.code, error.code);
      expect(err.message, error.message);
    }

    addTearDown(timer.cancel);
  });

  test(
    'should `reconnect` automatically '
    'if `onMessage` throws error after getting connected',
    () async {
      final user = OwnUser(id: 'test-user');
      const connectionId = 'test-connection-id';
      // Sends connect event to web-socket stream
      final timer = Timer(const Duration(milliseconds: 300), () {
        final event = Event(
          type: EventType.healthCheck,
          connectionId: connectionId,
          me: user,
        );
        webSocketSink.add(json.encode(event));
      });

      expectLater(
        webSocket.connectionStatusStream,
        emitsInOrder([
          ConnectionStatus.disconnected,
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
          // starts reconnecting
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      await webSocket.connect(user);

      final error = ErrorResponse()
        ..code = 333
        ..message = 'Invalid request';
      // Sends error event to web-socket stream
      webSocketSink.add(json.encode({'error': error}));

      final reconnectTimer = Timer(const Duration(seconds: 3), () {
        final event = Event(
          type: EventType.healthCheck,
          connectionId: connectionId,
          me: user,
        );
        webSocketSink.add(json.encode(event));
      });

      expect(webSocket.connectionId, connectionId);

      addTearDown(() {
        timer.cancel();
        reconnectTimer.cancel();
      });
    },
  );

  test(
    '`onMessage` should handle `health.check` event if `me` is null',
    () async {
      final user = OwnUser(id: 'test-user');
      const connectionId = 'test-connection-id';
      // Sends connect event to web-socket stream
      final timer = Timer(const Duration(milliseconds: 300), () {
        final event = Event(
          type: EventType.healthCheck,
          connectionId: connectionId,
          me: user,
        );
        webSocketSink.add(json.encode(event));
      });

      expectLater(
        webSocket.connectionStatusStream,
        emitsInOrder([
          ConnectionStatus.disconnected,
          ConnectionStatus.connecting,
          ConnectionStatus.connected,
        ]),
      );

      final event = await webSocket.connect(user);

      expect(event.type, EventType.healthCheck);
      expect(event.connectionId, connectionId);
      expect(event.me, isNotNull);
      expect(event.me!.id, user.id);

      const newConnectionId = 'new-connection-id';
      final healthCheckEvent = Event(
        type: EventType.healthCheck,
        connectionId: newConnectionId,
      );
      webSocketSink.add(json.encode(healthCheckEvent));

      await Future.delayed(const Duration(milliseconds: 300));

      expectLater(webSocket.connectionId, newConnectionId);

      addTearDown(timer.cancel);
    },
  );

  test('should call `onConnectionError` if web-socket stream throws', () async {
    final user = OwnUser(id: 'test-user');
    // Sends connect event to web-socket stream
    final timer = Timer(const Duration(milliseconds: 300), () {
      const error = StreamWebSocketError('test-error');
      webSocketSink.addError(error);
    });

    expectLater(
      webSocket.connectionStatusStream,
      emitsInOrder([
        ConnectionStatus.disconnected,
        ConnectionStatus.connecting,
        // throws error, reconnects
        ConnectionStatus.connected,
      ]),
    );

    webSocket.connect(user);

    // Assuming web-socket stream will add error
    // and web-socket now trying to reconnect
    await Future.delayed(const Duration(seconds: 3));

    const connectionId = 'test-connection-id';
    // Sends connect event to web-socket stream
    final event = Event(
      type: EventType.healthCheck,
      connectionId: connectionId,
      me: user,
    );
    webSocketSink.add(json.encode(event));

    addTearDown(timer.cancel);
  });

  test(
    'should call `onConnectionClosed` if web-socket stream throws',
    () async {
      final user = OwnUser(id: 'test-user');
      // Sends connect event to web-socket stream
      final timer = Timer(const Duration(milliseconds: 300), () {
        webSocketSink.close();
      });

      expectLater(
        webSocket.connectionStatusStream,
        emitsInOrder([
          ConnectionStatus.disconnected,
          ConnectionStatus.connecting,
          // throws error, reconnects
          ConnectionStatus.connected,
        ]),
      );

      webSocket.connect(user);

      // Assuming web-socket stream will add error
      // and web-socket now trying to reconnect
      await Future.delayed(const Duration(seconds: 3));

      const connectionId = 'test-connection-id';
      // Sends connect event to web-socket stream
      final event = Event(
        type: EventType.healthCheck,
        connectionId: connectionId,
        me: user,
      );
      webSocketSink.add(json.encode(event));

      addTearDown(timer.cancel);
    },
  );

  test('`disconnect` successfully disconnects the current user', () async {
    final user = OwnUser(id: 'test-user');
    const connectionId = 'test-connection-id';
    // Sends connect event to web-socket stream
    final timer = Timer(const Duration(milliseconds: 300), () {
      final event = Event(
        type: EventType.healthCheck,
        connectionId: connectionId,
        me: user,
      );
      webSocketSink.add(json.encode(event));
    });

    expectLater(
      webSocket.connectionStatusStream,
      emitsInOrder([
        ConnectionStatus.disconnected,
        ConnectionStatus.connecting,
        ConnectionStatus.connected,
        // after disconnect
        ConnectionStatus.disconnected,
      ]),
    );

    final event = await webSocket.connect(user);

    expect(event.type, EventType.healthCheck);
    expect(event.connectionId, connectionId);
    expect(event.me?.id, user.id);

    webSocket.disconnect();

    addTearDown(timer.cancel);
  });
}
