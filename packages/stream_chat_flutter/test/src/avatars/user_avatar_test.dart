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
            themeData: StreamChatThemeData(),
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
          data: StreamChatThemeData(),
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
          data: StreamChatThemeData(),
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

  // The design system owns these sizes, and the switches mapping them fall
  // back rather than being exhaustive, so adding one upstream no longer breaks
  // the build. This is what tells us a new size has arrived and still needs a
  // mapping of its own — the table has no entry for it.
  group('online indicator size', () {
    const expected = {
      StreamAvatarSize.xs: StreamOnlineIndicatorSize.sm,
      StreamAvatarSize.sm: StreamOnlineIndicatorSize.sm,
      StreamAvatarSize.md: StreamOnlineIndicatorSize.md,
      StreamAvatarSize.lg: StreamOnlineIndicatorSize.lg,
      StreamAvatarSize.xl: StreamOnlineIndicatorSize.xl,
      StreamAvatarSize.xxl: StreamOnlineIndicatorSize.xxl,
      StreamAvatarSize.xxxl: StreamOnlineIndicatorSize.xxxl,
    };

    test('every avatar size is mapped', () {
      expect(expected.keys, containsAll(StreamAvatarSize.values));
    });

    for (final size in StreamAvatarSize.values) {
      testWidgets('$size gets ${expected[size]}', (tester) async {
        when(() => user.online).thenReturn(true);

        await tester.pumpWidget(
          MaterialApp(
            home: StreamChat(
              client: client,
              themeData: StreamChatThemeData(),
              child: Scaffold(
                body: Center(
                  child: StreamUserAvatar(user: user, size: size),
                ),
              ),
            ),
          ),
        );

        final indicator = tester.widget<StreamOnlineIndicator>(
          find.byType(StreamOnlineIndicator),
        );
        expect(indicator.props.size, expected[size]);
      });
    }
  });
}
