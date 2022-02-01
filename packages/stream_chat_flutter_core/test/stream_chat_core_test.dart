import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

class MockOnBackgroundEventReceived extends Mock {
  void call(Event event);
}

void main() {
  testWidgets(
    'should render StreamChatCore if both client and child is provided',
    (tester) async {
      final mockClient = MockClient();
      const streamChatCoreKey = Key('streamChatCore');
      const childKey = Key('child');
      final streamChatCore = StreamChatCore(
        key: streamChatCoreKey,
        client: mockClient,
        child: const Offstage(key: childKey),
      );

      await tester.pumpWidget(streamChatCore);

      expect(find.byKey(streamChatCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
    },
  );

  testWidgets(
    'should render StreamChatCore if both client and child is provided',
    (tester) async {
      final mockClient = MockClient();
      const streamChatCoreKey = Key('streamChatCore');
      const childKey = Key('child');
      final streamChatCore = StreamChatCore(
        key: streamChatCoreKey,
        client: mockClient,
        child: const Offstage(key: childKey),
      );

      await tester.pumpWidget(streamChatCore);

      expect(find.byKey(streamChatCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
    },
  );

  testWidgets(
    'didChangeAppLifecycleState should call client.closeConnection and return '
    'if onBackgroundEventReceived is null and the widget lifestyle changes to '
    'AppLifecycleState.paused',
    (tester) async {
      final mockClient = MockClient();
      const streamChatCoreKey = Key('streamChatCore');
      const childKey = Key('child');
      final streamChatCore = StreamChatCore(
        key: streamChatCoreKey,
        client: mockClient,
        child: const Offstage(key: childKey),
      );

      await tester.pumpWidget(streamChatCore);

      expect(find.byKey(streamChatCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);

      // ignore: prefer_expression_function_bodies
      when(mockClient.closeConnection).thenAnswer((_) async {
        return;
      });

      final streamChatCoreState = tester.state<StreamChatCoreState>(
        find.byKey(streamChatCoreKey),
      );

      // ignore: cascade_invocations
      streamChatCoreState.didChangeAppLifecycleState(AppLifecycleState.paused);

      verify(mockClient.closeConnection).called(1);
    },
  );

  testWidgets(
    'didChangeAppLifecycleState should subscribe to client events for '
    'backgroundKeepAlive duration if onBackgroundEventReceived is provided '
    'and the widget lifestyle changes to AppLifecycleState.paused',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        final mockOnBackgroundEventReceived = MockOnBackgroundEventReceived();
        const backgroundKeepAlive = Duration(seconds: 3);
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          onBackgroundEventReceived: mockOnBackgroundEventReceived,
          backgroundKeepAlive: backgroundKeepAlive,
          connectivityStream: Stream.value(ConnectivityResult.mobile),
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final event = Event(type: EventType.any);
        when(mockClient.on).thenAnswer((_) => Stream.value(event));
        // ignore: prefer_expression_function_bodies
        when(mockClient.closeConnection).thenAnswer((_) async {
          return;
        });

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        // ignore: cascade_invocations
        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await untilCalled(() => mockOnBackgroundEventReceived.call(event));

        verify(() => mockOnBackgroundEventReceived.call(event)).called(1);

        await Future.delayed(backgroundKeepAlive);

        verify(mockClient.closeConnection).called(1);
        verifyNever(() => mockOnBackgroundEventReceived.call(event));
      });
    },
  );

  testWidgets(
    'didChangeAppLifecycleState should cancel the backgroundKeepAlive timer '
    'if it is currently running in case the widget lifestyle changes to '
    'AppLifecycleState.resume',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        final mockOnBackgroundEventReceived = MockOnBackgroundEventReceived();
        const backgroundKeepAlive = Duration(seconds: 3);
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          onBackgroundEventReceived: mockOnBackgroundEventReceived,
          backgroundKeepAlive: backgroundKeepAlive,
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final event = Event(type: EventType.any);
        when(mockClient.on).thenAnswer((_) => Stream.value(event));

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        // ignore: cascade_invocations
        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await untilCalled(() => mockOnBackgroundEventReceived.call(event));

        verify(() => mockOnBackgroundEventReceived.call(event)).called(1);

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.resumed);

        verifyNever(() => mockOnBackgroundEventReceived.call(event));
      });
    },
  );

  testWidgets(
    'didChangeAppLifecycleState should call client.connect() '
    'if the connectionStatus is ConnectionStatus.disconnected in case the '
    'widget lifestyle changes to AppLifecycleState.resume',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          connectivityStream: Stream.value(ConnectivityResult.mobile),
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final event = Event(type: EventType.any);
        when(mockClient.on).thenAnswer((_) => Stream.value(event));
        when(mockClient.openConnection)
            .thenAnswer((_) async => OwnUser(id: 'test'));

        // ignore: prefer_expression_function_bodies
        when(mockClient.closeConnection).thenAnswer((_) async {
          return;
        });
        when(() => mockClient.wsConnectionStatus)
            .thenReturn(ConnectionStatus.disconnected);

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        // ignore: cascade_invocations
        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await Future.delayed(const Duration(seconds: 1));

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.resumed);

        verify(mockClient.openConnection).called(1);
      });
    },
  );

  testWidgets(
    'didChangeAppLifecycleState should not call client.openConnection() '
    'if connection is not available in case the '
    'widget lifestyle changes to AppLifecycleState.resume',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');

        final event = Event();
        when(mockClient.on).thenAnswer((_) => Stream.value(event));
        when(mockClient.openConnection)
            .thenAnswer((_) async => OwnUser(id: 'test'));

        // ignore: prefer_expression_function_bodies
        when(mockClient.closeConnection).thenAnswer((_) async {
          return;
        });
        when(() => mockClient.wsConnectionStatus)
            .thenReturn(ConnectionStatus.disconnected);

        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          connectivityStream: Stream.value(ConnectivityResult.none),
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        // ignore: cascade_invocations
        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await Future.delayed(const Duration(seconds: 1));

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.resumed);

        verifyNever(mockClient.openConnection);
      });
    },
  );
  testWidgets(
    'didChangeAppLifecycleState should cancel the backgroundKeepAlive timer '
    'if it is currently running in case the widget lifestyle changes to '
    'AppLifecycleState.inactive',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        final mockOnBackgroundEventReceived = MockOnBackgroundEventReceived();
        const backgroundKeepAlive = Duration(seconds: 3);
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          onBackgroundEventReceived: mockOnBackgroundEventReceived,
          backgroundKeepAlive: backgroundKeepAlive,
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final event = Event(type: EventType.any);
        when(mockClient.on).thenAnswer((_) => Stream.value(event));

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        // ignore: cascade_invocations
        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await untilCalled(() => mockOnBackgroundEventReceived.call(event));

        verify(() => mockOnBackgroundEventReceived.call(event)).called(1);

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.inactive);

        verifyNever(() => mockOnBackgroundEventReceived.call(event));
      });
    },
  );

  testWidgets(
    'didChangeAppLifecycleState should call client.connect() '
    'if the connectionStatus is ConnectionStatus.disconnected in case the '
    'widget lifestyle changes to AppLifecycleState.inactive',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          connectivityStream: Stream.value(ConnectivityResult.mobile),
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final event = Event(type: EventType.any);
        when(mockClient.on).thenAnswer((_) => Stream.value(event));
        when(mockClient.openConnection)
            .thenAnswer((_) async => OwnUser(id: 'test'));
        when(mockClient.closeConnection).thenAnswer((_) async {});
        when(() => mockClient.wsConnectionStatus)
            .thenReturn(ConnectionStatus.disconnected);

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        // ignore: cascade_invocations
        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await Future.delayed(const Duration(seconds: 1));

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.inactive);

        verify(mockClient.openConnection).called(1);
      });
    },
  );

  testWidgets(
    'didChangeAppLifecycleState should not call client.openConnection() '
    'if connection is not available in case the '
    'widget lifestyle changes to AppLifecycleState.inactive',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');

        final event = Event();
        when(mockClient.on).thenAnswer((_) => Stream.value(event));
        when(mockClient.openConnection)
            .thenAnswer((_) async => OwnUser(id: 'test'));
        when(mockClient.closeConnection).thenAnswer((_) async {});
        when(() => mockClient.wsConnectionStatus)
            .thenReturn(ConnectionStatus.disconnected);

        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          connectivityStream: Stream.value(ConnectivityResult.none),
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        // ignore: cascade_invocations
        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await Future.delayed(const Duration(seconds: 1));

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.inactive);

        verifyNever(mockClient.openConnection);
      });
    },
  );

  testWidgets(
    'streamChatCoreState.currentUserStream should emit all the user events '
    'provided by client',
    (tester) async {
      await tester.runAsync(() async {
        final userController = StreamController<OwnUser>();

        final mockClient = MockClient();
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        when(() => mockClient.state.currentUserStream)
            .thenAnswer((_) => userController.stream);

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        final ownUser = OwnUser(id: 'testUserId');
        userController.add(ownUser);

        await expectLater(
          streamChatCoreState.currentUserStream,
          emits(ownUser),
        );

        addTearDown(userController.close);
      });
    },
  );

  testWidgets(
    'should call connect if in foreground and connection is back',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final _connectivityController =
            BehaviorSubject.seeded(ConnectivityResult.none);

        final event = Event();
        when(mockClient.on).thenAnswer((_) => Stream.value(event));
        when(mockClient.openConnection)
            .thenAnswer((_) async => OwnUser(id: 'test'));

        // ignore: prefer_expression_function_bodies
        when(mockClient.closeConnection).thenAnswer((_) async {
          return;
        });
        when(() => mockClient.wsConnectionStatus)
            .thenReturn(ConnectionStatus.disconnected);

        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          connectivityStream: _connectivityController.stream,
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        _connectivityController.add(ConnectivityResult.mobile);

        await Future.delayed(const Duration(seconds: 1));

        verify(mockClient.openConnection).called(1);

        addTearDown(_connectivityController.close);
      });
    },
  );

  testWidgets(
    'should call disconnect if in foreground and connection goes away',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final _connectivityController =
            BehaviorSubject.seeded(ConnectivityResult.mobile);
        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          connectivityStream: _connectivityController.stream,
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final event = Event();
        when(mockClient.on).thenAnswer((_) => Stream.value(event));
        when(mockClient.openConnection)
            .thenAnswer((_) async => OwnUser(id: 'test'));

        // ignore: prefer_expression_function_bodies
        when(mockClient.closeConnection).thenAnswer((_) async {
          return;
        });
        when(() => mockClient.wsConnectionStatus)
            .thenReturn(ConnectionStatus.connected);

        _connectivityController.add(ConnectivityResult.none);

        await Future.delayed(const Duration(seconds: 1));

        verify(mockClient.closeConnection).called(1);

        addTearDown(_connectivityController.close);
      });
    },
  );

  testWidgets(
    'should ignore connectivity in background',
    (tester) async {
      await tester.runAsync(() async {
        final mockClient = MockClient();
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final _connectivityController =
            BehaviorSubject.seeded(ConnectivityResult.none);

        final event = Event();
        when(mockClient.on).thenAnswer((_) => Stream.value(event));
        when(mockClient.openConnection)
            .thenAnswer((_) async => OwnUser(id: 'test'));

        // ignore: prefer_expression_function_bodies
        when(mockClient.closeConnection).thenAnswer((_) async {
          return;
        });
        when(() => mockClient.wsConnectionStatus)
            .thenReturn(ConnectionStatus.disconnected);

        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          connectivityStream: _connectivityController.stream,
          child: const Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        // ignore: cascade_invocations
        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await Future.delayed(const Duration(seconds: 1));

        _connectivityController.add(ConnectivityResult.mobile);

        await Future.delayed(const Duration(seconds: 1));

        verifyNever(mockClient.closeConnection);

        addTearDown(_connectivityController.close);
      });
    },
  );
}
