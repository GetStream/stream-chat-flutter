import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('AttachmentError test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => StreamChat(
          client: MockClient(),
          child: child,
        ),
        home: const Scaffold(
          body: Center(
            child: AttachmentError(),
          ),
        ),
      ),
    );

    expect(find.byType(Icon), findsOneWidget);
  });
}
