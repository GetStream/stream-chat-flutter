import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/context_menu_items/download_menu_item.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('DownloadMenuItem test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockClient(),
          child: child,
        ),
        home: Scaffold(
          body: Center(
            child: DownloadMenuItem(
              attachment: MockAttachment(),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(ListTile), findsOneWidget);
  });

  testGoldens(
    'golden test for DownloadMenuItem',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => StreamChatTheme(
            data: StreamChatThemeData.light(),
            child: child!,
          ),
          home: Scaffold(
            body: Center(
              child: DownloadMenuItem(
                attachment: MockAttachment(),
              ),
            ),
          ),
        ),
      );

      await screenMatchesGolden(tester, 'download_menu_item_0');
    },
  );
}
