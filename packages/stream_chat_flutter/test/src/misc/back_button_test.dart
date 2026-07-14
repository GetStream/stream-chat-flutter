import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'BackButton control test',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Material(child: Text('Home')),
          routes: <String, WidgetBuilder>{
            '/next': (BuildContext context) {
              return Material(
                child: Center(
                  child: StreamChatTheme(
                    data: StreamChatThemeData(),
                    child: const StreamBackButton(),
                  ),
                ),
              );
            },
          },
        ),
      );

      // ignore: unawaited_futures
      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/next');

      await tester.pumpAndSettle();

      await tester.tap(find.byType(StreamBackButton));

      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
    },
  );

  testWidgets(
    'it should not throw errors if cannot pop',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChatTheme(
                data: StreamChatThemeData(),
                child: const StreamBackButton(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.byType(StreamBackButton));

      await tester.pumpAndSettle();

      expect(find.byType(StreamBackButton), findsOneWidget);
    },
  );

  testWidgets(
    'BackButton onPressed overrides default pop behavior',
    (WidgetTester tester) async {
      var customCallbackWasCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: const Material(child: Text('Home')),
          routes: <String, WidgetBuilder>{
            '/next': (BuildContext context) {
              return Material(
                child: Center(
                  child: StreamChatTheme(
                    data: StreamChatThemeData(),
                    child: StreamBackButton(
                      onPressed: () => customCallbackWasCalled = true,
                    ),
                  ),
                ),
              );
            },
          },
        ),
      );

      // ignore: unawaited_futures
      tester.state<NavigatorState>(find.byType(Navigator)).pushNamed('/next');

      await tester.pumpAndSettle();

      expect(find.text('Home'), findsNothing); // Start off on the second page.
      expect(
        customCallbackWasCalled,
        false,
      ); // customCallbackWasCalled should still be false.
      await tester.tap(find.byType(StreamBackButton));

      await tester.pumpAndSettle();

      // We're still on the second page.
      expect(find.text('Home'), findsNothing);
      // But the custom callback is called.
      expect(customCallbackWasCalled, true);
    },
  );

  testWidgets(
    'it should show unread count',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.totalUnreadCount).thenAnswer((_) => 0);
      when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(0));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: const StreamBackButton(
                  showUnreadCount: true,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StreamUnreadIndicator), findsOneWidget);
    },
  );

  testWidgets(
    'unreadCount.total() shows the total unread count',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.totalUnreadCount).thenAnswer((_) => 10);
      when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(10));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: const StreamBackButton(
                  unreadCount: StreamBackButtonUnreadCount.total(),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('10'), findsOneWidget);
    },
  );

  testWidgets(
    'unreadCount.total(excludeCid:) excludes the given channel',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.totalUnreadCount).thenAnswer((_) => 10);
      when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(10));
      when(() => clientState.channels).thenReturn({channel.cid!: channel});
      when(() => channel.state).thenReturn(channelState);
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(3));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: StreamBackButton(
                  unreadCount: StreamBackButtonUnreadCount.total(
                    excludeCid: channel.cid,
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
    },
  );

  testWidgets(
    'unreadCount.channel(cid) shows that channel unread count',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.channels).thenReturn({channel.cid!: channel});
      when(() => channel.state).thenReturn(channelState);
      when(() => channelState.unreadCount).thenReturn(4);
      when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(4));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: StreamBackButton(
                  unreadCount: StreamBackButtonUnreadCount.channel(channel.cid!),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('4'), findsOneWidget);
    },
  );

  testWidgets(
    'no unreadCount shows no badge',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.totalUnreadCount).thenAnswer((_) => 10);
      when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(10));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: const StreamBackButton(),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StreamUnreadIndicator), findsNothing);
    },
  );

  testWidgets(
    'unreadCount takes precedence over the deprecated flags',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.totalUnreadCount).thenAnswer((_) => 10);
      when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(10));
      when(() => clientState.channels).thenReturn({channel.cid!: channel});
      when(() => channel.state).thenReturn(channelState);
      when(() => channelState.unreadCount).thenReturn(3);
      when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(3));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: StreamBackButton(
                  // The config wins over showUnreadCount: true, so the badge
                  // shows the excluded total (7), not the raw total (10).
                  unreadCount: StreamBackButtonUnreadCount.total(
                    excludeCid: channel.cid,
                  ),
                  showUnreadCount: true,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('7'), findsOneWidget);
    },
  );

  testWidgets(
    'showUnreadCount: true shows the total unread count',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.totalUnreadCount).thenAnswer((_) => 10);
      when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(10));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: const StreamBackButton(showUnreadCount: true),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('10'), findsOneWidget);
    },
  );

  testWidgets(
    'channelId shows that channel unread count',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final channel = MockChannel();
      final channelState = MockChannelState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.channels).thenReturn({channel.cid!: channel});
      when(() => channel.state).thenReturn(channelState);
      when(() => channelState.unreadCount).thenReturn(4);
      when(() => channelState.unreadCountStream).thenAnswer((_) => Stream.value(4));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: StreamBackButton(
                  showUnreadCount: true,
                  channelId: channel.cid,
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('4'), findsOneWidget);
    },
  );

  testWidgets(
    'showUnreadCount: false shows no badge',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.totalUnreadCount).thenAnswer((_) => 10);
      when(() => clientState.totalUnreadCountStream).thenAnswer((_) => Stream.value(10));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: const StreamBackButton(showUnreadCount: false),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StreamUnreadIndicator), findsNothing);
    },
  );
}
