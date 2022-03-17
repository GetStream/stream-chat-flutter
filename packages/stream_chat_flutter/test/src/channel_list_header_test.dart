import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'control test',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connected));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: const Scaffold(
              body: StreamChannelListHeader(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final userAvatar =
          tester.widget<StreamUserAvatar>(find.byType(StreamUserAvatar));
      expect(userAvatar.user, clientState.currentUser);
      expect(find.byType(StreamNeumorphicButton), findsOneWidget);
      expect(find.text('Stream Chat'), findsOneWidget);
    },
  );

  testWidgets(
    'it should show the InfoTile message if disconnected',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.disconnected));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: const Scaffold(
              body: StreamChannelListHeader(
                showConnectionStateTile: true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Disconnected'), findsOneWidget);
    },
  );

  testWidgets(
    'it should show the InfoTile message if connecting',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: const Scaffold(
              body: StreamChannelListHeader(
                showConnectionStateTile: true,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Reconnecting...'), findsOneWidget);
    },
  );

  testWidgets(
    'it should apply passed properties',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: StreamChannelListHeader(
                titleBuilder: (context, status, client) => const Text('TITLE'),
                subtitle: const Text('SUBTITLE'),
                leading: const Text('LEADING'),
                actions: const [
                  Text('ACTION'),
                ],
                client: client,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('TITLE'), findsOneWidget);
      expect(find.text('SUBTITLE'), findsOneWidget);
      expect(find.text('LEADING'), findsOneWidget);
      expect(find.text('ACTION'), findsOneWidget);
    },
  );

  testWidgets(
    'it should apply prenavigationcallback',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: StreamChannelListHeader(
                preNavigationCallback: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(StreamUserAvatar));
      expect(tapped, true);
    },
  );

  testWidgets(
    'it should apply passed callbacks',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

      var tapped = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: StreamChannelListHeader(
                onUserAvatarTap: (u) {
                  tapped++;
                },
                onNewChatButtonTap: () {
                  tapped++;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(StreamUserAvatar));
      await tester.tap(find.byType(StreamNeumorphicButton));
      expect(tapped, 2);
    },
  );
}
