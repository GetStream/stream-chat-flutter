import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('AttachmentHandler Downloads', () {
    test('AttachmentHandler downloads image', () async {
      final attachment = Attachment(
        title: 'test image attachment',
        type: 'image',
        extraData: const {
          'mime_type': 'png',
        },
      );

      final attachmentHandler = MockAttachmentHandler();

      when(() => attachmentHandler.downloadAttachment(attachment))
          .thenAnswer((invocation) async => 'filePath');

      expect(
        await attachmentHandler.downloadAttachment(attachment),
        'filePath',
      );
    });

    test('AttachmentHandler downloads giphy', () async {
      final attachment = Attachment(
        title: 'test giphy attachment',
        type: 'giphy',
        extraData: const {
          'original':
              'https://giphy.com/gifs/nrkp3-dance-happy-3o7TKnCdBx5cMg0qti',
        },
      );

      final attachmentHandler = MockAttachmentHandler();

      when(() => attachmentHandler.downloadAttachment(attachment))
          .thenAnswer((invocation) async => 'filePath');

      expect(
        await attachmentHandler.downloadAttachment(attachment),
        'filePath',
      );
    });

    test('AttachmentHandler downloads video', () async {
      final attachment = Attachment(
        title: 'test video attachment',
        type: 'video',
        assetUrl: 'https://www.youtube.com/watch?v=lytQi-slT5Y',
      );

      final attachmentHandler = MockAttachmentHandler();

      when(() => attachmentHandler.downloadAttachment(attachment))
          .thenAnswer((invocation) async => 'filePath');

      expect(
        await attachmentHandler.downloadAttachment(attachment),
        'filePath',
      );
    });
  });
}
