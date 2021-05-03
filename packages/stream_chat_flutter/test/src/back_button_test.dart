import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/back_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'BackButton control test',
    (WidgetTester tester) async {
      final theme = ThemeData();
      await tester.pumpWidget(
        MaterialApp(
          home: const Material(child: Text('Home')),
          routes: <String, WidgetBuilder>{
            '/next': (BuildContext context) {
              return Material(
                child: Center(
                  child: StreamChatTheme(
                    data: StreamChatThemeData.fromTheme(theme),
                    child: StreamBackButton(),
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
      final theme = ThemeData();
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChatTheme(
                data: StreamChatThemeData.fromTheme(theme),
                child: StreamBackButton(),
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
      final theme = ThemeData();
      var customCallbackWasCalled = false;
      await tester.pumpWidget(
        MaterialApp(
          home: const Material(child: Text('Home')),
          routes: <String, WidgetBuilder>{
            '/next': (BuildContext context) {
              return Material(
                child: Center(
                  child: StreamChatTheme(
                    data: StreamChatThemeData.fromTheme(theme),
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
      when(() => clientState.totalUnreadCountStream)
          .thenAnswer((i) => Stream.value(0));

      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: Center(
              child: StreamChat(
                client: client,
                child: StreamBackButton(
                  showUnreads: true,
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(UnreadIndicator), findsOneWidget);
    },
  );
}
