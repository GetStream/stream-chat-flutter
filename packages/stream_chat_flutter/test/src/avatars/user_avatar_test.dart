import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  late MockClient client;
  late MockUser user;

  setUpAll(() {
    client = MockClient();
    user = MockUser();

    when(() => user.name).thenReturn('user123');
    when(() => user.id).thenReturn('123');
  });

  testWidgets(
    'control test',
    (WidgetTester tester) async {
      when(() => user.online).thenReturn(true);
      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            streamChatThemeData: StreamChatThemeData.light(),
            child: Builder(builder: (context) {
              return Scaffold(
                body: Center(
                  child: StreamUserAvatar(
                    user: user,
                  ),
                ),
              );
            }),
          ),
        ),
      );

      expect(find.byType(StreamUserAvatar), findsOneWidget);
    },
  );

  testGoldens(
    'golden test for online user "user123"',
    (WidgetTester tester) async {
      when(() => user.online).thenReturn(true);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamChatConfiguration(
              data: StreamChatConfigurationData(),
              child: child!,
            );
          },
          home: StreamChatTheme(
            data: StreamChatThemeData.light(),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Center(
                    child: StreamUserAvatar(
                      user: user,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'user_avatar_0');
    },
  );

  testGoldens(
    'golden test for offline user "user123"',
    (WidgetTester tester) async {
      when(() => user.online).thenReturn(false);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) {
            return StreamChatConfiguration(
              data: StreamChatConfigurationData(),
              child: child!,
            );
          },
          home: StreamChatTheme(
            data: StreamChatThemeData.light(),
            child: Builder(
              builder: (context) {
                return Scaffold(
                  body: Center(
                    child: StreamUserAvatar(
                      user: user,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'user_avatar_1');
    },
  );
}
