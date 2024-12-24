import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

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
                  child: StreamGradientAvatar(
                      name: 'demo user', userId: 'demo123'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(StreamGradientAvatar), findsOneWidget);
    },
  );

  goldenTest(
    'golden test for the name "demo user"',
    fileName: 'gradient_avatar_0',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () => MaterialAppWrapper(
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: StreamGradientAvatar(name: 'demo user', userId: 'demo123'),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'golden test for the name "demo"',
    fileName: 'gradient_avatar_1',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () => MaterialAppWrapper(
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: StreamGradientAvatar(name: 'demo', userId: 'demo1'),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'control special character test',
    fileName: 'gradient_avatar_2',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () => MaterialAppWrapper(
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: StreamGradientAvatar(
              name: r'd123@/d de:$as',
              userId: 'demo123',
            ),
          ),
        ),
      ),
    ),
  );

  goldenTest(
    'control special character test 2',
    fileName: 'gradient_avatar_3',
    constraints: const BoxConstraints.tightFor(width: 300, height: 300),
    builder: () => MaterialAppWrapper(
      home: const Scaffold(
        body: Center(
          child: SizedBox(
            width: 100,
            height: 100,
            child: StreamGradientAvatar(
              name: r'123@/d $as',
              userId: 'demo123',
            ),
          ),
        ),
      ),
    ),
  );
}
