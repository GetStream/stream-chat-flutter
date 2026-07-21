import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  testWidgets(
    'it should show total unread count',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channel.extraDataStream).thenAnswer(
        (i) => Stream.value({
          'name': 'test',
        }),
      );
      when(() => channel.extraData).thenReturn({
        'name': 'test',
      });

      when(() => clientState.totalUnreadCount).thenReturn(10);
      when(() => clientState.totalUnreadCountStream).thenAnswer((i) => Stream.value(10));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: const Scaffold(
                body: StreamUnreadIndicator(),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.text('10'), findsOneWidget);
    },
  );

  testWidgets(
    'it should show nothing if no unread messages',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.channels).thenReturn({
        channel.cid!: channel,
      });
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channelState.unreadCount).thenReturn(0);
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(0));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamUnreadIndicator.channels(
                  cid: channel.cid,
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.text('0'), findsNothing);
    },
  );

  testWidgets(
    'it should show 99+ if more than 99 unreads',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.channels).thenReturn({
        channel.cid!: channel,
      });
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channelState.unreadCount).thenReturn(100);
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(100));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamUnreadIndicator.channels(
                  cid: channel.cid,
                ),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      expect(find.text('99+'), findsOneWidget);
    },
  );

  testWidgets(
    'it should exclude the given channel from the total unread count',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.channels).thenReturn({
        channel.cid!: channel,
      });
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(3));

      when(() => clientState.totalUnreadCount).thenReturn(10);
      when(() => clientState.totalUnreadCountStream).thenAnswer((i) => Stream.value(10));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamUnreadIndicator(excludeCid: channel.cid),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      // 10 total - 3 in the excluded channel = 7 unread elsewhere.
      expect(find.text('7'), findsOneWidget);
    },
  );

  testWidgets(
    'it should clamp the excluded total unread count to zero',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.channels).thenReturn({
        channel.cid!: channel,
      });
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);
      when(() => channelState.unreadCount).thenReturn(5);
      when(() => channelState.unreadCountStream).thenAnswer((i) => Stream.value(5));

      when(() => clientState.totalUnreadCount).thenReturn(3);
      when(() => clientState.totalUnreadCountStream).thenAnswer((i) => Stream.value(3));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamUnreadIndicator(excludeCid: channel.cid),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      // 3 total - 5 excluded clamps to 0, so no badge is shown.
      expect(find.byType(StreamBadgeNotification), findsNothing);
    },
  );

  testWidgets(
    'it should fall back to the raw total for an untracked excluded channel',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();
      final lastMessageAt = DateTime.parse('2020-06-22 12:00:00');

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => clientState.channels).thenReturn(const {});
      when(() => channel.lastMessageAt).thenReturn(lastMessageAt);
      when(() => channel.state).thenReturn(channelState);
      when(() => channel.client).thenReturn(client);

      when(() => clientState.totalUnreadCount).thenReturn(10);
      when(() => clientState.totalUnreadCountStream).thenAnswer((i) => Stream.value(10));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: StreamChannel(
              channel: channel,
              child: Scaffold(
                body: StreamUnreadIndicator(excludeCid: channel.cid),
              ),
            ),
          ),
        ),
      );

      // wait for the initial state to be rendered.
      await tester.pumpAndSettle();

      // The channel is absent from client state, so nothing is subtracted.
      expect(find.text('10'), findsOneWidget);
    },
  );

  // Golden safety net: locks in the current badge appearance overlaid on a
  // child, including the "99+" overflow pill.
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamUnreadIndicator on a child looks fine',
      fileName: 'stream_unread_indicator_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 120, height: 120),
      builder: () => _wrapWithMaterialApp(
        const StreamUnreadIndicator(child: Icon(Icons.chat_bubble_outline)),
        client: _clientWithTotalUnread(5),
        brightness: brightness,
      ),
    );
  }

  goldenTest(
    '[light] -> StreamUnreadIndicator shows 99+ overflow',
    fileName: 'stream_unread_indicator_overflow_light',
    constraints: const BoxConstraints.tightFor(width: 120, height: 120),
    builder: () => _wrapWithMaterialApp(
      const StreamUnreadIndicator(child: Icon(Icons.chat_bubble_outline)),
      client: _clientWithTotalUnread(100),
    ),
  );
}

StreamChatClient _clientWithTotalUnread(int count) {
  final client = MockClient();
  final clientState = MockClientState();
  when(() => client.state).thenReturn(clientState);
  when(() => clientState.totalUnreadCount).thenReturn(count);
  when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(count));
  return client;
}

Widget _wrapWithMaterialApp(
  Widget child, {
  required StreamChatClient client,
  Brightness brightness = Brightness.light,
}) {
  return MaterialAppWrapper(
    theme: ThemeData(brightness: brightness),
    home: StreamChat(
      client: client,
      connectivityStream: Stream.value(const [ConnectivityResult.mobile]),
      child: Scaffold(
        body: Center(child: child),
      ),
    ),
  );
}
