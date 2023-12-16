import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/attachment/thumbnail/media_attachment_thumbnail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

Widget wrapWithStreamChat(
  Widget child, {
  StreamChatClient? client,
}) {
  return MaterialApp(
    home: StreamChat(
      client: client ?? MockClient(),
      child: child,
    ),
  );
}

void main() {
  group('StreamMessageInputAttachmentList tests', () {
    testWidgets(
      'StreamMessageInputAttachmentList should render attachments',
      (WidgetTester tester) async {
        final attachments = [
          Attachment(type: 'file', id: 'file1'),
          Attachment(type: 'file', id: 'file2'),
          Attachment(type: 'media', id: 'media1'),
        ];

        await tester.pumpWidget(
          wrapWithStreamChat(
            StreamMessageInputAttachmentList(
              attachments: attachments,
            ),
          ),
        );

        // Expect 2 file attachments and 1 media attachment
        expect(find.byType(MessageInputFileAttachments), findsOneWidget);
        expect(find.byType(StreamFileAttachment), findsNWidgets(2));
        expect(find.byType(MessageInputMediaAttachments), findsOneWidget);
        expect(find.byType(StreamMediaAttachmentThumbnail), findsOneWidget);
      },
    );

    testWidgets(
      'StreamMessageInputAttachmentList should call onRemovePressed callback',
      (WidgetTester tester) async {
        Attachment? removedAttachment;

        final attachments = [
          Attachment(type: 'file', id: 'file1'),
          Attachment(type: 'file', id: 'file2'),
        ];

        await tester.pumpWidget(
          wrapWithStreamChat(
            StreamMessageInputAttachmentList(
              attachments: attachments,
              onRemovePressed: (attachment) {
                removedAttachment = attachment;
              },
            ),
          ),
        );

        final removeButtons = find.byType(RemoveAttachmentButton);

        // Tap the first remove button
        await tester.tap(removeButtons.first);
        await tester.pump();

        // Expect the onRemovePressed callback to be called with the second
        // attachment as they are reversed in the UI.
        expect(removedAttachment, attachments[1]);
      },
    );

    testWidgets(
      '''StreamMessageInputAttachmentList should display empty box if no attachments''',
      (WidgetTester tester) async {
        final attachments = <Attachment>[];

        await tester.pumpWidget(
          wrapWithStreamChat(
            StreamMessageInputAttachmentList(
              attachments: attachments,
            ),
          ),
        );

        // Expect an empty box
        expect(find.byType(SizedBox), findsOneWidget);
      },
    );
  });

  group('MessageInputFileAttachments tests', () {
    testWidgets(
      'MessageInputFileAttachments should render file attachments',
      (WidgetTester tester) async {
        final attachments = [
          Attachment(type: 'file', id: 'file1'),
          Attachment(type: 'file', id: 'file2'),
        ];

        await tester.pumpWidget(
          wrapWithStreamChat(
            MessageInputFileAttachments(
              attachments: attachments,
            ),
          ),
        );

        // Expect 2 file attachments
        expect(find.byType(StreamFileAttachment), findsNWidgets(2));
      },
    );

    testWidgets(
      'MessageInputFileAttachments should call onRemovePressed callback',
      (WidgetTester tester) async {
        Attachment? removedAttachment;

        final attachments = [
          Attachment(type: 'file', id: 'file1'),
        ];

        await tester.pumpWidget(
          wrapWithStreamChat(
            MessageInputFileAttachments(
              attachments: attachments,
              onRemovePressed: (attachment) {
                removedAttachment = attachment;
              },
            ),
          ),
        );

        final removeButton = find.byType(RemoveAttachmentButton);

        // Tap the remove button
        await tester.tap(removeButton);
        await tester.pump();

        // Expect the onRemovePressed callback to be called with the attachment
        expect(removedAttachment, attachments.first);
      },
    );
  });

  group('MessageInputMediaAttachments tests', () {
    testWidgets(
      'MessageInputMediaAttachments should render media attachments',
      (WidgetTester tester) async {
        final attachments = [
          Attachment(type: 'media', id: 'media1'),
          Attachment(type: 'media', id: 'media2'),
        ];

        await tester.pumpWidget(
          wrapWithStreamChat(
            MessageInputMediaAttachments(
              attachments: attachments,
            ),
          ),
        );

        // Expect 2 media attachments
        expect(find.byType(Stack), findsNWidgets(2));
      },
    );

    testWidgets(
      'MessageInputMediaAttachments should display empty box if no attachments',
      (WidgetTester tester) async {
        final attachments = <Attachment>[];

        await tester.pumpWidget(
          wrapWithStreamChat(
            MessageInputMediaAttachments(
              attachments: attachments,
            ),
          ),
        );

        // Expect an empty box
        expect(find.byType(SizedBox), findsOneWidget);
      },
    );
  });

  group('StreamMediaAttachmentBuilder tests', () {
    testWidgets(
      'StreamMediaAttachmentBuilder should render media attachment',
      (WidgetTester tester) async {
        final attachment = Attachment(type: 'media', id: 'media1');

        await tester.pumpWidget(
          wrapWithStreamChat(
            StreamMediaAttachmentBuilder(
              attachment: attachment,
              onRemovePressed: (attachment) {},
            ),
          ),
        );

        // Expect one media attachment widget
        expect(find.byType(StreamMediaAttachmentBuilder), findsOneWidget);
      },
    );

    testWidgets(
      'StreamMediaAttachmentBuilder should call onRemovePressed callback',
          (WidgetTester tester) async {
        Attachment? removedAttachment;

        final attachment = Attachment(type: 'file', id: 'file1');

        await tester.pumpWidget(
          wrapWithStreamChat(
            StreamMediaAttachmentBuilder(
              attachment: attachment,
              onRemovePressed: (attachment) {
                removedAttachment = attachment;
              },
            ),
          ),
        );

        final removeButton = find.byType(RemoveAttachmentButton);

        // Tap the remove button
        await tester.tap(removeButton);
        await tester.pump();

        // Expect the onRemovePressed callback to be called with the attachment
        expect(removedAttachment, attachment);
      },
    );
  });
}
