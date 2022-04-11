import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
      'AttachmentUploadStateBuilder returns Offstage when message is sent',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: StreamChannel(
              channel: MockChannel(),
              child: StreamAttachmentUploadStateBuilder(
                attachment: Attachment(
                  id: 'test',
                ),
                message: Message(
                  id: 'test',
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(Offstage), findsOneWidget);
  });
}
