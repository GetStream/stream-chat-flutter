import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/context_menu_items/stream_chat_context_menu_item.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('StreamChatContextMenuItem test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockClient(),
          child: child,
        ),
        home: const Scaffold(
          body: Center(
            child: StreamChatContextMenuItem(),
          ),
        ),
      ),
    );

    expect(find.byType(ListTile), findsOneWidget);
  });

  testGoldens(
    'golden test for StreamChatContextMenuItem',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChatTheme(
            data: StreamChatThemeData.light(),
            child: child!,
          ),
          home: Scaffold(
            body: Center(
              child: StreamChatContextMenuItem(
                leading: const Icon(Icons.download),
                title: const Text('Download'),
                onClick: () {},
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'stream_chat_context_menu_item_0');
    },
  );
}
