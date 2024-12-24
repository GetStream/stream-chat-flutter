import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';

void main() {
  testWidgets('CountdownButton works', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: StreamCountdownButton(count: 5),
            ),
          ),
        ),
      ),
    );

    expect(find.text('5'), findsOneWidget);
  });

  goldenTest(
    'golden test for CountdownButton',
    fileName: 'countdown_button_0',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: const Scaffold(
          body: Center(
            child: StreamCountdownButton(count: 5),
          ),
        ),
      ),
    ),
  );
}
