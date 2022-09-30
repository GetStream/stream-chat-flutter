import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

  testGoldens('golden test for CountdownButton', (tester) async {
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

    await screenMatchesGolden(tester, 'countdown_button_0');
  });
}
