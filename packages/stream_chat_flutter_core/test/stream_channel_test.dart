import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'should expose channel state through StreamChannel.of() context method',
    (tester) async {
      final mockChannel = MockChannel();
      StreamChannelState? channelState;

      // Build a widget that accesses the channel state
      final testWidget = MaterialApp(
        home: Scaffold(
          body: StreamChannel(
            channel: mockChannel,
            child: Builder(
              builder: (context) {
                // Access the channel state
                channelState = StreamChannel.of(context);
                return const Text('Child Widget');
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Verify we can access the channel state
      expect(channelState, isNotNull);
      expect(channelState?.channel, equals(mockChannel));
    },
  );

  testWidgets(
    'should render child widget when channel has no CID (locally created)',
    (tester) async {
      final nonInitializedMockChannel = NonInitializedMockChannel();
      when(() => nonInitializedMockChannel.cid).thenReturn(null);

      // A simple widget that provides StreamChannel
      final testWidget = MaterialApp(
        home: Scaffold(
          body: StreamChannel(
            channel: nonInitializedMockChannel,
            child: const Text('Child Widget'),
          ),
        ),
      );

      // Pump the widget
      await tester.pumpWidget(testWidget);

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Child Widget'), findsNothing);

      // Wait for initialization to complete
      await tester.pumpAndSettle();

      // Now should show the child
      expect(find.text('Child Widget'), findsOneWidget);
    },
  );

  testWidgets(
    'should display loading indicator then render child for initialized channel',
    (tester) async {
      final mockChannel = MockChannel();
      when(() => mockChannel.cid).thenReturn('test:channel');
      when(() => mockChannel.state.unreadCount).thenReturn(0);

      // A simple widget that provides StreamChannel
      final testWidget = MaterialApp(
        home: Scaffold(
          body: StreamChannel(
            channel: mockChannel,
            child: const Text('Child Widget'),
          ),
        ),
      );

      // Pump the widget
      await tester.pumpWidget(testWidget);

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Child Widget'), findsNothing);

      // Wait for initialization to complete
      await tester.pumpAndSettle();

      // Now should show the child
      expect(find.text('Child Widget'), findsOneWidget);
    },
  );

  testWidgets(
    'should call watch() to initialize channel with valid CID before rendering child',
    (tester) async {
      final nonInitializedMockChannel = NonInitializedMockChannel();
      when(() => nonInitializedMockChannel.cid).thenReturn('test:channel');
      when(nonInitializedMockChannel.watch).thenAnswer(
        (_) async => ChannelState(),
      );

      // A simple widget that provides StreamChannel
      final testWidget = MaterialApp(
        home: Scaffold(
          body: StreamChannel(
            channel: nonInitializedMockChannel,
            child: const Text('Child Widget'),
          ),
        ),
      );

      // Pump the widget
      await tester.pumpWidget(testWidget);

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Child Widget'), findsNothing);

      // Wait for initialization to complete
      await tester.pumpAndSettle();

      // Now should show the child
      expect(find.text('Child Widget'), findsOneWidget);

      // Verify watch was called
      verify(nonInitializedMockChannel.watch).called(1);
    },
  );

  testWidgets(
    'should immediately show child and skip loading when showLoading is false',
    (tester) async {
      final nonInitializedMockChannel = NonInitializedMockChannel();
      when(() => nonInitializedMockChannel.cid).thenReturn('test:channel');
      when(nonInitializedMockChannel.watch).thenAnswer(
        (_) async => ChannelState(),
      );

      // A simple widget that provides StreamChannel
      final testWidget = MaterialApp(
        home: Scaffold(
          body: StreamChannel(
            channel: nonInitializedMockChannel,
            showLoading: false,
            child: const Text('Child Widget'),
          ),
        ),
      );

      // Pump the widget
      await tester.pumpWidget(testWidget);

      // Should show the child directly
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Child Widget'), findsOneWidget);

      // Wait for initialization to complete
      await tester.pumpAndSettle();

      // Should still show the child
      expect(find.text('Child Widget'), findsOneWidget);
    },
  );

  testWidgets(
    'should use provided loadingBuilder for custom loading indicator',
    (tester) async {
      final nonInitializedMockChannel = NonInitializedMockChannel();
      when(() => nonInitializedMockChannel.cid).thenReturn('test:channel');
      when(nonInitializedMockChannel.watch).thenAnswer(
        (_) => Future.microtask(ChannelState.new),
      );

      // A widget with custom loading indicator
      final testWidget = MaterialApp(
        home: Scaffold(
          body: StreamChannel(
            channel: nonInitializedMockChannel,
            loadingBuilder: (_) => const Text('Custom Loading'),
            child: const Text('Child Widget'),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);

      // Should show custom loading widget
      expect(find.text('Custom Loading'), findsOneWidget);
      expect(find.text('Child Widget'), findsNothing);

      // Wait for initialization to complete
      await tester.pumpAndSettle();

      // Now should show the child
      expect(find.text('Child Widget'), findsOneWidget);
      expect(find.text('Custom Loading'), findsNothing);
    },
  );

  testWidgets(
    'should display default error widget when channel initialization fails',
    (tester) async {
      final nonInitializedMockChannel = NonInitializedMockChannel();
      when(() => nonInitializedMockChannel.cid).thenReturn('test:channel');
      // Important: Making initialization fail with a direct error
      when(nonInitializedMockChannel.watch).thenThrow('Failed to connect');

      // A widget with custom error handler
      final testWidget = MaterialApp(
        home: Scaffold(
          body: StreamChannel(
            channel: nonInitializedMockChannel,
            // The default error builder will show the error message
            child: const Text('Child Widget'),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for error to occur
      await tester.pumpAndSettle();

      // Should show error widget with the error message
      expect(find.text('Failed to connect'), findsOneWidget);
      expect(find.text('Child Widget'), findsNothing);
    },
  );

  testWidgets(
    'should use provided errorBuilder when channel initialization fails',
    (tester) async {
      final nonInitializedMockChannel = NonInitializedMockChannel();
      when(() => nonInitializedMockChannel.cid).thenReturn('test:channel');
      // Important: Making initialization fail with a direct error
      when(nonInitializedMockChannel.watch).thenThrow('Failed to connect');

      // A widget with custom error handler
      final testWidget = MaterialApp(
        home: Scaffold(
          body: StreamChannel(
            channel: nonInitializedMockChannel,
            errorBuilder: (_, error, stk) => const Text('Custom Error'),
            child: const Text('Child Widget'),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for error to occur
      await tester.pumpAndSettle();

      // Should show error widget with the error message
      expect(find.text('Custom Error'), findsOneWidget);
      expect(find.text('Child Widget'), findsNothing);
    },
  );

  testWidgets(
    'should query channel at specific message when initialMessageId is provided',
    (tester) async {
      final mockChannel = MockChannel();
      when(() => mockChannel.cid).thenReturn('test:channel');

      when(
        () => mockChannel.query(
          messagesPagination: any(named: 'messagesPagination'),
          preferOffline: any(named: 'preferOffline'),
        ),
      ).thenAnswer((_) async => ChannelState());

      // Build a widget with initialMessageId
      final testWidget = MaterialApp(
        home: Scaffold(
          body: StreamChannel(
            channel: mockChannel,
            initialMessageId: 'test-message-id',
            child: const Text('Child Widget'),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Verify query was called to load the channel at the initial message
      verify(
        () => mockChannel.query(
          messagesPagination: any(named: 'messagesPagination'),
          preferOffline: any(named: 'preferOffline'),
        ),
      ).called(1);
    },
  );

  testWidgets(
    'should reinitialize and call watch() when channel CID changes',
    (tester) async {
      // First channel
      final mockChannel1 = MockChannel();
      when(() => mockChannel1.cid).thenReturn('test:channel1');
      when(() => mockChannel1.state.unreadCount).thenReturn(0);

      // Build with first channel
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChannel(
            channel: mockChannel1,
            child: const Text('Channel Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Second channel
      final mockChannel2 = NonInitializedMockChannel();
      when(() => mockChannel2.cid).thenReturn('test:channel2');
      when(mockChannel2.watch).thenAnswer((_) async => ChannelState());

      // Update widget with second channel
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChannel(
            channel: mockChannel2,
            child: const Text('Channel Content'),
          ),
        ),
      );

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for channel initialization
      await tester.pumpAndSettle();

      // Verify watch was called on the second channel
      verify(mockChannel2.watch).called(1);

      // Verify the content is displayed
      expect(find.text('Channel Content'), findsOneWidget);
    },
  );

  testWidgets(
    'should reinitialize and query again when initialMessageId changes',
    (tester) async {
      final mockChannel = MockChannel();
      when(() => mockChannel.cid).thenReturn('test:channel1');

      when(
        () => mockChannel.query(
          messagesPagination: any(named: 'messagesPagination'),
          preferOffline: any(named: 'preferOffline'),
        ),
      ).thenAnswer((_) async => ChannelState());

      // First initial message ID
      const initialMessageId1 = 'test-message-id-1';

      // Build with first channel
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChannel(
            channel: mockChannel,
            initialMessageId: initialMessageId1,
            child: const Text('Channel Content'),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Second initial message ID
      const initialMessageId2 = 'test-message-id-2';

      // Update widget with second channel
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChannel(
            channel: mockChannel,
            initialMessageId: initialMessageId2,
            child: const Text('Channel Content'),
          ),
        ),
      );

      // Initially should show loading
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Wait for channel initialization
      await tester.pumpAndSettle();

      // Verify watch was called twice with different initial message IDs
      verify(
        () => mockChannel.query(
          messagesPagination: any(named: 'messagesPagination'),
          preferOffline: any(named: 'preferOffline'),
        ),
      ).called(2);

      // Verify the content is displayed
      expect(find.text('Channel Content'), findsOneWidget);
    },
  );
}
