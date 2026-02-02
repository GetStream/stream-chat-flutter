import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/context_menu_items/download_menu_item.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../material_app_wrapper.dart';
import '../mocks.dart';

void main() {
  group('DownloadMenuItem tests', () {
    testWidgets('renders ListTile widget', (tester) async {
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

    goldenTest(
      'golden test for DownloadMenuItem',
      fileName: 'download_menu_item_0',
      constraints: const BoxConstraints.tightFor(width: 300, height: 100),
      builder: () => MaterialAppWrapper(
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
  });
}
