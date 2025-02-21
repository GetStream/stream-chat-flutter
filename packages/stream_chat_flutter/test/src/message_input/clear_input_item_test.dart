import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_input/clear_input_item_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';

void main() {
  testWidgets('ClearInputItemButton onPressed works', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData.light(),
          child: Scaffold(
            body: Center(
              child: ClearInputItemButton(
                onTap: () {
                  count++;
                },
              ),
            ),
          ),
        ),
      ),
    );

    final button = find.byType(RawMaterialButton);
    expect(button, findsOneWidget);
    expect(find.byType(StreamSvgIcon), findsOneWidget);
    await tester.tap(button);
    expect(count, 1);
  });

  goldenTest(
    'golden test for ClearInputItemButton',
    fileName: 'clear_input_item_0',
    constraints: const BoxConstraints.tightFor(width: 50, height: 50),
    builder: () => MaterialAppWrapper(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: Scaffold(
          body: Center(
            child: ClearInputItemButton(
              onTap: () {},
            ),
          ),
        ),
      ),
    ),
  );
}
