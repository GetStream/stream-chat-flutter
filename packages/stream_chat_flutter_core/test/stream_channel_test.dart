// ignore_for_file: lines_longer_than_80_chars

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
      when(() => mockChannel.state.isUpToDate).thenReturn(true);

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
      when(() => mockChannel1.state.isUpToDate).thenReturn(true);

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

  group('getFirstUnreadMessage', () {
    final mockChannel = MockChannel();
    tearDownAll(mockChannel.dispose);

    setUp(() {
      when(() => mockChannel.cid).thenReturn('test:channel1');

      when(
        () => mockChannel.query(
          preferOffline: any(named: 'preferOffline'),
          messagesPagination: any(named: 'messagesPagination'),
        ),
      ).thenAnswer((_) async => ChannelState());
    });

    tearDown(() => reset(mockChannel));

    Future<StreamChannelState> _pumpStreamChannel(WidgetTester tester) async {
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
                return const Text('Channel Content');
              },
            ),
          ),
        ),
      );

      await tester.pumpWidget(testWidget);
      await tester.pumpAndSettle();

      // Verify we can access the channel state
      expect(channelState, isNotNull);

      return channelState!;
    }

    testWidgets(
      'Returns null when messages list is empty',
      (tester) async {
        when(() => mockChannel.state.messages).thenReturn([]);
        when(() => mockChannel.state.unreadCount).thenReturn(0);
        when(() => mockChannel.state.isUpToDate).thenReturn(true);

        final streamChannel = await _pumpStreamChannel(tester);

        expect(streamChannel.getFirstUnreadMessage(), isNull);
      },
    );

    testWidgets(
      'Returns null when there are no unread messages',
      (tester) async {
        final mockRead = Read(
          user: User(id: 'testUserId'),
          lastRead: DateTime.now(),
          unreadMessages: 0,
          lastReadMessageId: 'message1',
        );

        final messages = [
          Message(
            id: 'message1',
            createdAt: DateTime.now(),
            user: User(id: 'testUserId'),
          ),
        ];

        when(() => mockChannel.state.unreadCount).thenReturn(0);
        when(() => mockChannel.state.messages).thenReturn(messages);
        when(() => mockChannel.state.currentUserRead).thenReturn(mockRead);
        when(() => mockChannel.state.isUpToDate).thenReturn(true);

        final streamChannel = await _pumpStreamChannel(tester);

        expect(streamChannel.getFirstUnreadMessage(mockRead), isNull);
      },
    );

    testWidgets(
      'Returns null when last read message is the last message',
      (tester) async {
        final lastMessage = Message(
          id: 'message2',
          createdAt: DateTime.now(),
          user: User(id: 'otherUserId'),
        );

        final mockRead = Read(
          user: User(id: 'testUserId'),
          lastRead: DateTime.now(),
          unreadMessages: 1,
          lastReadMessageId: lastMessage.id,
        );

        final messages = [
          Message(
            id: 'message1',
            createdAt: DateTime.now(),
            user: User(id: 'otherUserId'),
          ),
          lastMessage,
        ];

        when(() => mockChannel.state.unreadCount).thenReturn(1);
        when(() => mockChannel.state.messages).thenReturn(messages);
        when(() => mockChannel.state.currentUserRead).thenReturn(mockRead);

        final streamChannel = await _pumpStreamChannel(tester);

        expect(streamChannel.getFirstUnreadMessage(), isNull);
      },
    );

    testWidgets(
      'Returns first unread message after last read',
      (tester) async {
        final unreadMessage = Message(
          id: 'message3',
          createdAt: DateTime.now(),
          user: User(id: 'otherUserId'),
        );

        final mockRead = Read(
          user: User(id: 'testUserId'),
          lastRead: DateTime.now().subtract(const Duration(hours: 1)),
          unreadMessages: 1,
          lastReadMessageId: 'message1',
        );

        final messages = [
          Message(
            id: 'message1',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            user: User(id: 'otherUserId'),
          ),
          Message(
            id: 'message2',
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
            // This is from current user, should skip
            user: User(id: 'testUserId'),
          ),
          unreadMessage,
        ];

        when(() => mockChannel.state.unreadCount).thenReturn(1);
        when(() => mockChannel.state.messages).thenReturn(messages);
        when(() => mockChannel.state.currentUserRead).thenReturn(mockRead);

        final streamChannel = await _pumpStreamChannel(tester);

        expect(streamChannel.getFirstUnreadMessage(), equals(unreadMessage));
      },
    );

    testWidgets(
      'Skips deleted messages',
      (tester) async {
        final regularUnreadMessage = Message(
          id: 'message4',
          createdAt: DateTime.now(),
          user: User(id: 'otherUserId'),
        );

        final mockRead = Read(
          user: User(id: 'testUserId'),
          lastRead: DateTime.now().subtract(const Duration(hours: 1)),
          unreadMessages: 2,
          lastReadMessageId: 'message1',
        );

        final messages = [
          Message(
            id: 'message1',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            user: User(id: 'otherUserId'),
          ),
          Message(
            id: 'message2',
            createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
            type: MessageType.deleted, // Deleted message, should skip
            user: User(id: 'otherUserId'),
            deletedAt: DateTime.now(),
          ),
          Message(
            id: 'message3',
            createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
            type: MessageType.deleted, // Deleted message, should skip
            user: User(id: 'otherUserId'),
          ),
          regularUnreadMessage,
        ];

        when(() => mockChannel.state.unreadCount).thenReturn(2);
        when(() => mockChannel.state.messages).thenReturn(messages);
        when(() => mockChannel.state.currentUserRead).thenReturn(mockRead);

        final streamChannel = await _pumpStreamChannel(tester);

        expect(
          streamChannel.getFirstUnreadMessage(),
          equals(regularUnreadMessage),
        );
      },
    );

    testWidgets(
      'Can accept custom read object parameter',
      (tester) async {
        final unreadMessage = Message(
          id: 'message2',
          createdAt: DateTime.now(),
          user: User(id: 'otherUserId'),
        );

        // Default read in channel state (no unread)
        final defaultRead = Read(
          user: User(id: 'testUserId'),
          lastRead: DateTime.now(),
          unreadMessages: 0,
          lastReadMessageId: 'message2',
        );

        // Custom read to pass to the method (has unread)
        final customRead = Read(
          user: User(id: 'testUserId'),
          lastRead: DateTime.now().subtract(const Duration(hours: 1)),
          unreadMessages: 1,
          lastReadMessageId: 'message1',
        );

        final messages = [
          Message(
            id: 'message1',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
            user: User(id: 'otherUserId'),
          ),
          unreadMessage,
        ];

        when(() => mockChannel.state.unreadCount).thenReturn(0);
        when(() => mockChannel.state.messages).thenReturn(messages);
        when(() => mockChannel.state.currentUserRead).thenReturn(defaultRead);

        final streamChannel = await _pumpStreamChannel(tester);

        // With default read - should return null
        expect(streamChannel.getFirstUnreadMessage(), isNull);

        // With custom read - should return unreadMessage
        expect(
          streamChannel.getFirstUnreadMessage(customRead),
          equals(unreadMessage),
        );
      },
    );
  });
}
