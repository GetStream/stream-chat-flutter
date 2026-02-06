// ignore_for_file: lines_longer_than_80_chars

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
  group('StreamChatCore.of()', () {
    testWidgets(
      'should return StreamChatCoreState when StreamChatCore is found in widget tree',
      (tester) async {
        final mockClient = MockClient();
        StreamChatCoreState? chatCoreState;

        final testWidget = StreamChatCore(
          client: mockClient,
          child: Builder(
            builder: (context) {
              chatCoreState = StreamChatCore.of(context);
              return const Text('Child Widget');
            },
          ),
        );

        await tester.pumpWidget(MaterialApp(home: testWidget));

        expect(chatCoreState, isNotNull);
        expect(chatCoreState?.client, equals(mockClient));
      },
    );

    testWidgets(
      'should throw FlutterError when StreamChatCore is not found in widget tree',
      (tester) async {
        Object? caughtError;

        final testWidget = MaterialApp(
          home: Builder(
            builder: (context) {
              try {
                StreamChatCore.of(context);
              } catch (error) {
                caughtError = error;
              }
              return const Text('Child Widget');
            },
          ),
        );

        await tester.pumpWidget(testWidget);

        expect(caughtError, isA<FlutterError>());
      },
    );
  });

  group('StreamChatCore.maybeOf()', () {
    testWidgets(
      'should return StreamChatCoreState when StreamChatCore is found in widget tree',
      (tester) async {
        final mockClient = MockClient();
        StreamChatCoreState? chatCoreState;

        final testWidget = StreamChatCore(
          client: mockClient,
          child: Builder(
            builder: (context) {
              chatCoreState = StreamChatCore.maybeOf(context);
              return const Text('Child Widget');
            },
          ),
        );

        await tester.pumpWidget(MaterialApp(home: testWidget));

        expect(chatCoreState, isNotNull);
        expect(chatCoreState?.client, equals(mockClient));
      },
    );

    testWidgets(
      'should return null when StreamChatCore is not found in widget tree',
      (tester) async {
        StreamChatCoreState? chatCoreState;

        final testWidget = MaterialApp(
          home: Builder(
            builder: (context) {
              chatCoreState = StreamChatCore.maybeOf(context);
              return const Text('Child Widget');
            },
          ),
        );

        await tester.pumpWidget(testWidget);

        expect(chatCoreState, isNull);
      },
    );
  });

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

  group('StreamChatCore lifecycle behavior', () {
    late MockClient mockClient;
    late MockOnBackgroundEventReceived mockOnBackgroundEventReceived;
    late BehaviorSubject<List<ConnectivityResult>> connectivityController;

    setUp(() {
      mockClient = MockClient();
      mockOnBackgroundEventReceived = MockOnBackgroundEventReceived();
      connectivityController = BehaviorSubject.seeded(
        [ConnectivityResult.mobile],
      );

      // Setup the mock client
      when(mockClient.closeConnection).thenAnswer((_) async {});
      when(
        mockClient.openConnection,
      ).thenAnswer((_) async => OwnUser(id: 'test-user'));
      when(() => mockClient.wsConnectionStatus).thenReturn(ConnectionStatus.connected);
    });

    tearDown(() {
      connectivityController.close();
    });

    Future<void> pumpStreamChatCore(
      WidgetTester tester, {
      void Function(Event)? onBackgroundEventReceived,
      Duration backgroundKeepAlive = const Duration(minutes: 1),
    }) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatCore(
            client: mockClient,
            backgroundKeepAlive: backgroundKeepAlive,
            onBackgroundEventReceived: onBackgroundEventReceived,
            connectivityStream: connectivityController.stream,
            child: const SizedBox(),
          ),
        ),
      );
    }

    testWidgets(
      'should close connection when app goes to background without handler',
      (tester) async {
        // Arrange
        await pumpStreamChatCore(tester);

        // Act
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pumpAndSettle();

        // Assert
        verify(mockClient.closeConnection).called(1);
      },
    );

    testWidgets(
      'should open connection when app comes to foreground',
      (tester) async {
        // Arrange
        await pumpStreamChatCore(tester);

        // Put app in background
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pumpAndSettle();

        // Reset connection status to disconnected
        when(
          () => mockClient.wsConnectionStatus,
        ).thenReturn(ConnectionStatus.disconnected);

        // Act - bring app to foreground
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
        await tester.pumpAndSettle();

        // Assert
        verify(mockClient.openConnection).called(1);
      },
    );

    testWidgets(
      'should listen for events when app goes to background with handler',
      (tester) async {
        // Arrange
        final event = Event(type: EventType.any);
        when(mockClient.on).thenAnswer((_) => Stream.value(event));

        await pumpStreamChatCore(
          tester,
          onBackgroundEventReceived: mockOnBackgroundEventReceived,
        );

        // Act
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pumpAndSettle();

        // Wait for event to be processed
        await tester.pump(const Duration(milliseconds: 100));

        // Assert
        verify(() => mockOnBackgroundEventReceived.call(event)).called(1);
        verifyNever(mockClient.closeConnection);
      },
    );

    testWidgets(
      'should close connection after background timer expires',
      (tester) async {
        await tester.runAsync(() async {
          // Arrange
          final event = Event(type: EventType.any);
          when(mockClient.on).thenAnswer((_) => Stream.value(event));

          await pumpStreamChatCore(
            tester,
            onBackgroundEventReceived: mockOnBackgroundEventReceived,
            backgroundKeepAlive: const Duration(milliseconds: 100),
          );

          // Act
          tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
          await tester.pumpAndSettle();

          // Wait for timer to expire
          await Future.delayed(const Duration(milliseconds: 200));

          // Assert
          verify(() => mockOnBackgroundEventReceived.call(event)).called(1);
          verify(mockClient.closeConnection).called(1);
        });
      },
    );

    testWidgets(
      'should open connection when connectivity is restored',
      (tester) async {
        // Arrange
        await pumpStreamChatCore(tester);

        // Set connection status to disconnected
        when(
          () => mockClient.wsConnectionStatus,
        ).thenReturn(ConnectionStatus.disconnected);

        // Act - restore connectivity
        connectivityController.add([ConnectivityResult.mobile]);
        await tester.pumpAndSettle();

        // Assert
        verify(mockClient.openConnection).called(1);
      },
    );

    testWidgets(
      'should close connection when connectivity is lost',
      (tester) async {
        // Arrange
        await pumpStreamChatCore(tester);

        // Set connection status to connected
        when(
          () => mockClient.wsConnectionStatus,
        ).thenReturn(ConnectionStatus.connected);

        // Act - lose connectivity
        connectivityController.add([ConnectivityResult.none]);
        await tester.pumpAndSettle();

        // Assert
        verify(mockClient.closeConnection).called(1);
      },
    );

    testWidgets(
      'should ignore connectivity changes when app is in background',
      (tester) async {
        // Arrange
        await pumpStreamChatCore(tester);

        // Put app in background
        tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
        await tester.pumpAndSettle();

        // Reset the mock to clear previous calls
        clearInteractions(mockClient);

        // Act - connectivity changes while in background
        connectivityController.add([ConnectivityResult.mobile]);
        await tester.pumpAndSettle();

        // Assert
        verifyNever(mockClient.openConnection);
        verifyNever(mockClient.closeConnection);
      },
    );

    testWidgets(
      'should skip initial connectivity event to avoid race with connectUser',
      (tester) async {
        // Create a connectivity stream that will emit immediately on subscription
        final testConnectivityController = BehaviorSubject.seeded(
          [ConnectivityResult.mobile],
        );

        // Set up for reconnection scenario
        when(
          () => mockClient.wsConnectionStatus,
        ).thenReturn(ConnectionStatus.disconnected);

        // Clear any previous calls
        clearInteractions(mockClient);

        // Arrange - pump widget with connectivity stream
        // The BehaviorSubject will emit [mobile] immediately on subscription
        // which should be skipped by skip(1)
        await tester.pumpWidget(
          MaterialApp(
            home: StreamChatCore(
              client: mockClient,
              connectivityStream: testConnectivityController.stream,
              child: const SizedBox(),
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert - the initial event from BehaviorSubject should be skipped
        verifyNever(mockClient.closeConnection);
        verifyNever(mockClient.openConnection);

        // Now emit a connectivity change (this is the 2nd event, won't be skipped)
        testConnectivityController.add([ConnectivityResult.wifi]);
        await tester.pumpAndSettle();

        // Assert - second event should trigger reconnection
        verify(mockClient.closeConnection).called(1);
        verify(mockClient.openConnection).called(1);

        testConnectivityController.close();
      },
    );
  });
}
