import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/src/gradient_avatar.dart';
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

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: const Scaffold(
              body: Center(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: GradientAvatar(name: 'demo user', userId: 'demo123'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(GradientAvatar), findsOneWidget);
    },
  );

  testGoldens(
    'golden test for the name "demo user"',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: GradientAvatar(name: 'demo user', userId: 'demo123'),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'gradient_avatar_0');
    },
  );

  testGoldens(
    'golden test for the name "demo"',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: GradientAvatar(name: 'demo', userId: 'demo1'),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'gradient_avatar_1');
    },
  );

  testGoldens(
    'control special character test',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: GradientAvatar(
                  name: 'd123@/d de:\$as',
                  userId: 'demo123',
                ),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'gradient_avatar_2');
    },
  );

  testGoldens(
    'control special character test 2',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: GradientAvatar(name: '123@/d \$as', userId: 'demo123'),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'gradient_avatar_3');
    },
  );
}
