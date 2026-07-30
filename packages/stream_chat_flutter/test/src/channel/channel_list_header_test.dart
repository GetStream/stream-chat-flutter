import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'control test',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));

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

      final userAvatar = tester.widget<StreamUserAvatar>(find.byType(StreamUserAvatar));
      expect(userAvatar.user, clientState.currentUser);
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
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.disconnected));

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
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

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
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connecting));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: StreamChannelListHeader(
                title: const Text('TITLE'),
                subtitle: const Text('SUBTITLE'),
                trailing: const Text('ACTION'),
                client: client,
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('TITLE'), findsOneWidget);
      expect(find.text('SUBTITLE'), findsOneWidget);
      expect(find.text('ACTION'), findsOneWidget);
    },
  );

  testWidgets(
    'trailing slot receives caller-provided widget',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));

      var trailingTapped = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: StreamChannelListHeader(
                trailing: GestureDetector(
                  onTap: () => trailingTapped++,
                  child: const Text('trailing-slot'),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('trailing-slot'));
      expect(trailingTapped, 1);
    },
  );

  group('default avatar floating behavior', () {
    // The header installs its own StreamAppBarTheme around the bar, so the
    // avatar has to resolve from inside it — otherwise channelListHeaderTheme
    // is invisible to the avatar while the bar honours it.
    Future<void> pumpHeader(
      WidgetTester tester, {
      StreamAppStyle appStyle = StreamAppStyle.regular,
      StreamAppBarBehavior? themeBehavior,
      StreamAppBarBehavior? styleBehavior,
    }) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));
      when(() => client.wsConnectionStatusStream).thenAnswer((_) => Stream.value(ConnectionStatus.connected));

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [StreamTheme(appStyle: appStyle)]),
          home: StreamChat(
            client: client,
            themeData: StreamChatThemeData(
              channelListHeaderTheme: switch (themeBehavior) {
                final behavior? => StreamAppBarThemeData(style: StreamAppBarStyle(behavior: behavior)),
                _ => null,
              },
            ),
            child: Scaffold(
              body: StreamChannelListHeader(
                style: switch (styleBehavior) {
                  final behavior? => StreamAppBarStyle(behavior: behavior),
                  _ => null,
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    bool? avatarIsFloating(WidgetTester tester) {
      return tester.widget<StreamUserAvatar>(find.byType(StreamUserAvatar)).isFloating;
    }

    testWidgets('is not floating by default', (tester) async {
      await pumpHeader(tester);

      expect(avatarIsFloating(tester), isNot(isTrue));
    });

    testWidgets('floats when the app style is floating', (tester) async {
      await pumpHeader(tester, appStyle: StreamAppStyle.floating);

      expect(avatarIsFloating(tester), isTrue);
    });

    testWidgets('floats when the header theme says so, over a regular app style', (tester) async {
      await pumpHeader(tester, themeBehavior: StreamAppBarBehavior.floating);

      expect(avatarIsFloating(tester), isTrue);
    });

    testWidgets('the header style wins over both the header theme and the app style', (tester) async {
      await pumpHeader(
        tester,
        appStyle: StreamAppStyle.floating,
        themeBehavior: StreamAppBarBehavior.floating,
        styleBehavior: StreamAppBarBehavior.regular,
      );

      expect(avatarIsFloating(tester), isNot(isTrue));
    });
  });
}
