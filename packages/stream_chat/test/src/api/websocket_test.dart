import 'dart:async';

import 'package:logging/logging.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/src/api/connection_status.dart';
import 'package:stream_chat/src/api/websocket.dart';
import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/user.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Functions {
  WebSocketChannel connectFunc(
    String? url, {
    Iterable<String>? protocols,
  }) =>
      WebSocketChannel.connect(Uri());

  void handleFunc(Event event) {}
}

class MockFunctions extends Mock implements Functions {}

class MockWSChannel extends Mock implements WebSocketChannel {}

class MockWSSink extends Mock implements WebSocketSink {}

class FakeEvent extends Fake implements Event {}

void main() {
  group('src/api/websocket', () {
    setUpAll(() {
      registerFallbackValue<Event>(FakeEvent());
    });

    test('should connect with correct parameters', () async {
      final connectFunc = MockFunctions().connectFunc;
      final ws = WebSocket(
        baseUrl: 'baseurl',
        user: User(id: 'testid'),
        logger: Logger('ws'),
        connectParams: {'test': 'true'},
        connectPayload: {'payload': 'test'},
        handler: print,
        connectFunc: connectFunc,
      );
      final mockWSChannel = MockWSChannel();
      final streamController = StreamController<String>.broadcast();
      const computedUrl =
          'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

      when(() => connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
      when(() => mockWSChannel.sink).thenAnswer((_) => MockWSSink());
      when(() => mockWSChannel.stream).thenAnswer(
        (_) => streamController.stream,
      );

      final timer = Timer.periodic(
        const Duration(milliseconds: 100),
        (_) => streamController.sink.add('{}'),
      );

      await ws.connect();

      verify(() => connectFunc(computedUrl)).called(1);
      expect(ws.connectionStatus, ConnectionStatus.connected);

      await streamController.close();
      timer.cancel();
    });
  });

  test('should connect with correct parameters and handle events', () async {
    final handleFunc = MockFunctions().handleFunc;
    final connectFunc = MockFunctions().connectFunc;
    final ws = WebSocket(
      baseUrl: 'baseurl',
      user: User(id: 'testid'),
      logger: Logger('ws'),
      connectParams: {'test': 'true'},
      connectPayload: {'payload': 'test'},
      handler: handleFunc,
      connectFunc: connectFunc,
    );
    final mockWSChannel = MockWSChannel();
    final streamController = StreamController<String>.broadcast();
    const computedUrl =
        'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

    when(() => connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
    when(() => mockWSChannel.sink).thenAnswer((_) => MockWSSink());
    when(() => mockWSChannel.stream).thenAnswer((_) => streamController.stream);

    final connect = ws.connect().then((_) {
      streamController.sink.add('{}');
      return Future.delayed(const Duration(milliseconds: 200));
    }).then((value) {
      verify(() => connectFunc(computedUrl)).called(1);
      verify(() => handleFunc(any())).called(greaterThan(0));

      return streamController.close();
    });

    streamController.sink.add('{}');

    return connect;
  });

  test('should close correctly the controller', () async {
    final handleFunc = MockFunctions().handleFunc;
    final connectFunc = MockFunctions().connectFunc;
    final ws = WebSocket(
      baseUrl: 'baseurl',
      user: User(id: 'testid'),
      logger: Logger('ws'),
      connectParams: {'test': 'true'},
      connectPayload: {'payload': 'test'},
      handler: handleFunc,
      connectFunc: connectFunc,
    );
    final mockWSChannel = MockWSChannel();
    final streamController = StreamController<String>.broadcast();
    const computedUrl =
        'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

    when(() => connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
    when(() => mockWSChannel.sink).thenAnswer((_) => MockWSSink());
    when(() => mockWSChannel.stream).thenAnswer((_) => streamController.stream);

    final connect = ws.connect().then((_) {
      streamController.sink.add('{}');
      return Future.delayed(const Duration(milliseconds: 200));
    }).then((value) {
      verify(() => connectFunc(computedUrl)).called(1);
      verify(() => handleFunc(any())).called(greaterThan(0));

      return streamController.close();
    });

    streamController.sink.add('{}');

    return connect;
  });

  test('should close correctly the controller while connecting', () async {
    final handleFunc = MockFunctions().handleFunc;

    final connectFunc = MockFunctions().connectFunc;

    final ws = WebSocket(
      baseUrl: 'baseurl',
      user: User(id: 'testid'),
      logger: Logger('ws'),
      connectParams: {'test': 'true'},
      connectPayload: {'payload': 'test'},
      handler: handleFunc,
      connectFunc: connectFunc,
    );

    final mockWSChannel = MockWSChannel();

    final streamController = StreamController<String>.broadcast();

    const computedUrl =
        'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

    when(() => connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
    when(() => mockWSChannel.sink).thenAnswer((_) => MockWSSink());
    when(() => mockWSChannel.stream).thenAnswer((_) => streamController.stream);

    ws.connect();
    await ws.disconnect();
    streamController.add('{}');

    verify(() => connectFunc(computedUrl)).called(1);
    verifyNever(() => handleFunc(any()));

    addTearDown(streamController.close);
  });

  test('should run correctly health check', () async {
    final handleFunc = MockFunctions().handleFunc;
    final connectFunc = MockFunctions().connectFunc;
    final ws = WebSocket(
      baseUrl: 'baseurl',
      user: User(id: 'testid'),
      logger: Logger('ws'),
      connectParams: {'test': 'true'},
      connectPayload: {'payload': 'test'},
      handler: handleFunc,
      connectFunc: connectFunc,
    );
    final mockWSChannel = MockWSChannel();
    final mockWSSink = MockWSSink();
    final streamController = StreamController<String>.broadcast();
    const computedUrl =
        'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

    when(() => connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
    when(() => mockWSChannel.stream).thenAnswer((_) => streamController.stream);
    when(() => mockWSChannel.sink).thenReturn(mockWSSink);

    final timer = Timer.periodic(
      const Duration(milliseconds: 1000),
      (_) => streamController.sink.add('{}'),
    );

    final connect = ws.connect().then((_) {
      streamController.sink.add('{}');
      return Future.delayed(const Duration(milliseconds: 200));
    }).then((value) async {
      verify(() => mockWSSink.add("{'type': 'health.check'}"))
          .called(greaterThan(0));

      timer.cancel();
      await streamController.close();
      return mockWSSink.close();
    });

    streamController.sink.add('{}');

    return connect;
  });

  test('should run correctly reconnection check', () async {
    final handleFunc = MockFunctions().handleFunc;
    final connectFunc = MockFunctions().connectFunc;
    Logger.root.level = Level.ALL;
    final ws = WebSocket(
      baseUrl: 'baseurl',
      user: User(id: 'testid'),
      logger: Logger('ws'),
      connectParams: {'test': 'true'},
      connectPayload: {'payload': 'test'},
      handler: handleFunc,
      connectFunc: connectFunc,
      reconnectionMonitorTimeout: 1,
    );
    final mockWSChannel = MockWSChannel();
    final mockWSSink = MockWSSink();
    var streamController = StreamController<String>.broadcast();
    const computedUrl =
        'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

    when(() => connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
    when(() => mockWSChannel.stream).thenAnswer((_) => streamController.stream);
    when(() => mockWSChannel.sink).thenReturn(mockWSSink);

    final connect = ws.connect().then((_) {
      streamController.sink.add('{}');
      streamController.close();
      streamController = StreamController<String>.broadcast();
      streamController.sink.add('{}');
      return Future.delayed(const Duration(milliseconds: 200));
    }).then((value) async {
      verify(() => mockWSSink.add("{'type': 'health.check'}"))
          .called(greaterThan(0));

      verify(() => connectFunc(computedUrl)).called(2);

      await streamController.close();
      return mockWSSink.close();
    });

    streamController.sink.add('{}');

    return connect;
  });

  test('should close correctly the controller', () async {
    final handleFunc = MockFunctions().handleFunc;
    final connectFunc = MockFunctions().connectFunc;
    final ws = WebSocket(
      baseUrl: 'baseurl',
      user: User(id: 'testid'),
      logger: Logger('ws'),
      connectParams: {'test': 'true'},
      connectPayload: {'payload': 'test'},
      handler: handleFunc,
      connectFunc: connectFunc,
    );
    final mockWSChannel = MockWSChannel();
    final mockWSSink = MockWSSink();
    final streamController = StreamController<String>.broadcast();
    const computedUrl =
        'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

    when(() => connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
    when(() => mockWSChannel.stream).thenAnswer((_) => streamController.stream);
    when(() => mockWSChannel.sink).thenReturn(mockWSSink);

    final connect = ws.connect().then((_) {
      streamController.sink.add('{}');
      return Future.delayed(const Duration(milliseconds: 200));
    }).then((value) async {
      await ws.disconnect();
      verify(mockWSSink.close).called(greaterThan(0));

      await streamController.close();
      await mockWSSink.close();
    });

    streamController.sink.add('{}');

    return connect;
  });

  test('should throw an error', () async {
    final connectFunc = MockFunctions().connectFunc;
    final ws = WebSocket(
      baseUrl: 'baseurl',
      user: User(id: 'testid'),
      logger: Logger('ws'),
      connectParams: {'test': 'true'},
      connectPayload: {'payload': 'test'},
      handler: print,
      connectFunc: connectFunc,
    );
    final mockWSChannel = MockWSChannel();
    final streamController = StreamController<String>.broadcast();
    const computedUrl =
        'wss://baseurl/connect?test=true&json=%7B%22payload%22%3A%22test%22%2C%22user_details%22%3A%7B%22id%22%3A%22testid%22%7D%7D';

    when(() => connectFunc(computedUrl)).thenAnswer((_) => mockWSChannel);
    when(() => mockWSChannel.sink).thenAnswer((_) => MockWSSink());
    when(() => mockWSChannel.stream).thenAnswer((_) => streamController.stream);

    Future.delayed(
      const Duration(milliseconds: 1000),
      () => streamController.sink.addError('test error'),
    );

    try {
      expect(await ws.connect(), throwsA(isA<String>()));
    } catch (e) {
      verify(() => connectFunc(computedUrl)).called(greaterThanOrEqualTo(1));
      streamController.close();
    }
  });
}
