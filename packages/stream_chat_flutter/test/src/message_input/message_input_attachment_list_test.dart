import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

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
  group('StreamMessageComposerAttachmentList tests', () {
    testWidgets(
      'StreamMessageComposerAttachmentList should render attachments',
      (WidgetTester tester) async {
        final attachments = [
          Attachment(type: 'file', id: 'file1'),
          Attachment(type: 'file', id: 'file2'),
          Attachment(type: 'image', id: 'image1'),
        ];

        await tester.pumpWidget(
          wrapWithStreamChat(
            StreamMessageComposerAttachmentList(
              attachments: attachments,
            ),
          ),
        );

        // Expect 2 file attachments and 1 media attachment
        expect(find.byType(StreamMessageComposerFileAttachment), findsNWidgets(2));
        expect(find.byType(MessageInputMediaAttachments), findsOneWidget);
        expect(find.byType(StreamMediaAttachmentThumbnail), findsOneWidget);
      },
    );

    testWidgets(
      'StreamMessageComposerAttachmentList should call onRemovePressed callback',
      (WidgetTester tester) async {
        Attachment? removedAttachment;

        final attachments = [
          Attachment(type: 'file', id: 'file1'),
          Attachment(type: 'file', id: 'file2'),
        ];

        await tester.pumpWidget(
          wrapWithStreamChat(
            StreamMessageComposerAttachmentList(
              attachments: attachments,
              onRemovePressed: (attachment) {
                removedAttachment = attachment;
              },
            ),
          ),
        );

        final removeButtons = find.byType(StreamRemoveControl);

        // Tap the first remove button
        await tester.tap(removeButtons.first);
        await tester.pump();

        // Expect the onRemovePressed callback to be called with the second
        // attachment as they are reversed in the UI.
        expect(removedAttachment, attachments[0]);
      },
    );

    testWidgets(
      '''StreamMessageComposerAttachmentList should display empty box if no attachments''',
      (WidgetTester tester) async {
        final attachments = <Attachment>[];

        await tester.pumpWidget(
          wrapWithStreamChat(
            StreamMessageComposerAttachmentList(
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
            StreamMessageComposerAttachmentList(
              attachments: attachments,
            ),
          ),
        );

        // Expect 2 file attachments
        expect(find.byType(StreamMessageComposerFileAttachment), findsNWidgets(2));
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
            StreamMessageComposerAttachmentList(
              attachments: attachments,
              onRemovePressed: (attachment) {
                removedAttachment = attachment;
              },
            ),
          ),
        );

        final removeButton = find.byType(StreamRemoveControl);

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
          Attachment(type: 'image', id: 'image1'),
          Attachment(type: 'video', id: 'video1'),
        ];

        await tester.pumpWidget(
          wrapWithStreamChat(
            MessageInputMediaAttachments(
              attachments: attachments,
            ),
          ),
        );

        // Expect 2 media attachments
        expect(find.byType(StreamMediaAttachmentBuilder), findsNWidgets(2));
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

    testWidgets(
      'MessageInputMediaAttachments should render unsupported attachment for unknown types',
      (WidgetTester tester) async {
        final attachments = [
          Attachment(type: 'unknown', id: 'unknown1'),
          Attachment(type: 'something_else', id: 'unknown2'),
        ];

        await tester.pumpWidget(
          wrapWithStreamChat(
            MessageInputMediaAttachments(
              attachments: attachments,
            ),
          ),
        );

        // Expect a fallback unsupported attachment widget for each unknown type.
        expect(find.byType(StreamMessageComposerUnsupportedAttachment), findsNWidgets(2));
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

        final removeButton = find.byType(StreamRemoveControl);

        // Tap the remove button
        await tester.tap(removeButton);
        await tester.pump();

        // Expect the onRemovePressed callback to be called with the attachment
        expect(removedAttachment, attachment);
      },
    );
  });
}
