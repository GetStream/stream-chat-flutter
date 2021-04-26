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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connected));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelListHeader(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final userAvatar = tester.widget<UserAvatar>(find.byType(UserAvatar));
      expect(userAvatar.user, clientState.user);
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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.disconnected));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelListHeader(
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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelListHeader(
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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelListHeader(
                titleBuilder: (context, status, client) {
                  return Text('TITLE');
                },
                subtitle: Text('SUBTITLE'),
                leading: Text('LEADING'),
                actions: [
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
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelListHeader(
                preNavigationCallback: () {
                  tapped = true;
                },
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(UserAvatar));
      expect(tapped, true);
    },
  );

  testWidgets(
    'it should apply passed callbacks',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.user).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream)
          .thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

      var tapped = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: ChannelListHeader(
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

      await tester.tap(find.byType(UserAvatar));
      await tester.tap(find.byType(StreamNeumorphicButton));
      expect(tapped, 2);
    },
  );
}
