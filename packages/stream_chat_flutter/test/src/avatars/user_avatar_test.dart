import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
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

  goldenTest(
    'golden test for online user "user123"',
    fileName: 'user_avatar_0',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () {
      when(() => user.online).thenReturn(true);
      return MaterialAppWrapper(
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
      );
    },
  );

  goldenTest(
    'golden test for offline user "user123"',
    fileName: 'user_avatar_1',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () {
      when(() => user.online).thenReturn(false);
      return MaterialAppWrapper(
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
      );
    },
  );
}
