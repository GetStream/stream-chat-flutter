import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/command_button.dart';

import '../material_app_wrapper.dart';

void main() {
  testWidgets('CommandButton onPressed works', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: CommandButton(
              color: Colors.red,
              onPressed: () {
                count++;
              },
            ),
          ),
        ),
      ),
    );

    final button = find.byType(IconButton);
    expect(button, findsOneWidget);
    await tester.tap(button);
    expect(count, 1);
  });

  testWidgets('CommandButton should accept icon', (tester) async {
    const icon = Icon(Icons.add);
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: CommandButton(
              icon: icon,
              onPressed: () {},
            ),
          ),
        ),
      ),
    );

    final iconFound = find.byWidget(icon);
    expect(iconFound, findsOneWidget);
  });

  testWidgets('CommandButton should not accept both color and icon',
      (tester) async {
    expect(
      () => MaterialApp(
        home: Scaffold(
          body: Center(
            child: CommandButton(
              color: Colors.red,
              icon: const Icon(Icons.add),
              onPressed: () {},
            ),
          ),
        ),
      ),
      throwsA(
        isA<AssertionError>().having(
          (e) => e.message,
          'message',
          'Either icon or color should be provided',
        ),
      ),
    );
  });

  goldenTest(
    'golden test for CommandButton',
    fileName: 'command_button_0',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: Scaffold(
        body: Center(
          child: CommandButton(
            color: Colors.blueAccent,
            onPressed: () {},
          ),
        ),
      ),
    ),
  );
}
