import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

class MockOnBackgroundEventReceived extends Mock {
  void call(Event event);
}

void main() {
  test(
    'should throw assertion error in case client is null',
    () {
      final streamChatCore = () => StreamChatCore(
            client: null,
            child: Offstage(),
          );
      expect(streamChatCore, throwsA(isA<AssertionError>()));
    },
  );

  test(
    'should throw assertion error in case child is null',
    () {
      final mockClient = MockClient();
      final streamChatCore = () => StreamChatCore(
            client: mockClient,
            child: null,
          );
      expect(streamChatCore, throwsA(isA<AssertionError>()));
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
        child: Offstage(key: childKey),
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
        child: Offstage(key: childKey),
      );

      await tester.pumpWidget(streamChatCore);

      expect(find.byKey(streamChatCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);
    },
  );

  testWidgets(
    'didChangeAppLifecycleState should call client.disconnect() and return '
    'if onBackgroundEventReceived is null and the widget lifestyle changes to '
    'AppLifecycleState.paused',
    (tester) async {
      final mockClient = MockClient();
      const streamChatCoreKey = Key('streamChatCore');
      const childKey = Key('child');
      final streamChatCore = StreamChatCore(
        key: streamChatCoreKey,
        client: mockClient,
        child: Offstage(key: childKey),
      );

      await tester.pumpWidget(streamChatCore);

      expect(find.byKey(streamChatCoreKey), findsOneWidget);
      expect(find.byKey(childKey), findsOneWidget);

      when(mockClient.disconnect()).thenAnswer((_) async {
        return;
      });

      final streamChatCoreState = tester.state<StreamChatCoreState>(
        find.byKey(streamChatCoreKey),
      );

      streamChatCoreState.didChangeAppLifecycleState(AppLifecycleState.paused);

      verify(mockClient.disconnect()).called(1);
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
        const backgroundKeepAlive = const Duration(seconds: 3);
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          child: Offstage(key: childKey),
          onBackgroundEventReceived: mockOnBackgroundEventReceived,
          backgroundKeepAlive: backgroundKeepAlive,
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final event = Event();
        when(mockClient.on()).thenAnswer((_) => Stream.value(event));
        when(mockClient.disconnect()).thenAnswer((_) async {
          return;
        });

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await untilCalled(mockOnBackgroundEventReceived.call(event));

        verify(mockOnBackgroundEventReceived.call(event)).called(1);

        await Future.delayed(backgroundKeepAlive);

        verify(mockClient.disconnect()).called(1);
        verifyNever(mockOnBackgroundEventReceived.call(event));
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
        const backgroundKeepAlive = const Duration(seconds: 3);
        const streamChatCoreKey = Key('streamChatCore');
        const childKey = Key('child');
        final streamChatCore = StreamChatCore(
          key: streamChatCoreKey,
          client: mockClient,
          child: Offstage(key: childKey),
          onBackgroundEventReceived: mockOnBackgroundEventReceived,
          backgroundKeepAlive: backgroundKeepAlive,
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final event = Event();
        when(mockClient.on()).thenAnswer((_) => Stream.value(event));

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await untilCalled(mockOnBackgroundEventReceived.call(event));

        verify(mockOnBackgroundEventReceived.call(event)).called(1);

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.resumed);

        verifyNever(mockOnBackgroundEventReceived.call(event));
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
          child: Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        final event = Event();
        when(mockClient.on()).thenAnswer((_) => Stream.value(event));
        when(mockClient.connect()).thenAnswer((_) async => event);
        when(mockClient.wsConnectionStatus)
            .thenReturn(ConnectionStatus.disconnected);

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.paused);

        await Future.delayed(const Duration(seconds: 1));

        streamChatCoreState
            .didChangeAppLifecycleState(AppLifecycleState.resumed);

        verify(mockClient.connect()).called(1);
      });
    },
  );

  testWidgets(
    'streamChatCoreState.userStream should emit all the user events '
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
          child: Offstage(key: childKey),
        );

        await tester.pumpWidget(streamChatCore);

        expect(find.byKey(streamChatCoreKey), findsOneWidget);
        expect(find.byKey(childKey), findsOneWidget);

        when(mockClient.state.userStream)
            .thenAnswer((_) => userController.stream);

        final streamChatCoreState = tester.state<StreamChatCoreState>(
          find.byKey(streamChatCoreKey),
        );

        final ownUser = OwnUser(id: 'testUserId');
        userController.add(ownUser);

        await expectLater(
          streamChatCoreState.userStream,
          emits(ownUser),
        );

        addTearDown(() {
          userController.close();
        });
      });
    },
  );
}
