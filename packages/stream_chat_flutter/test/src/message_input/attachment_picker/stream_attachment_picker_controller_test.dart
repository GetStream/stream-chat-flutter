import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Attachment _fileAttachment({required String path, int size = 100}) {
  return Attachment(
    type: 'file',
    uploadState: const UploadState.success(),
    file: AttachmentFile(path: path, size: size),
  );
}

void main() {
  group('StreamAttachmentPickerController.addAttachment', () {
    test('throws when the validator rejects the attachment', () async {
      final controller = StreamAttachmentPickerController(
        validator: const StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
        ),
      );
      addTearDown(controller.dispose);

      await expectLater(
        controller.addAttachment(_fileAttachment(path: '/tmp/virus.exe')),
        throwsA(isA<AttachmentBlockedError>()),
      );
    });

    test('completes when the validator passes the attachment', () async {
      final controller = StreamAttachmentPickerController(
        validator: const StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
        ),
      );
      addTearDown(controller.dispose);

      await expectLater(
        controller.addAttachment(_fileAttachment(path: '/tmp/doc.pdf')),
        completes,
      );
    });

    test('throws AttachmentLimitReachedError when maxAttachmentCount exceeded', () async {
      final controller = StreamAttachmentPickerController(
        validator: const StreamAttachmentValidator(maxAttachmentCount: 1),
      );
      addTearDown(controller.dispose);

      await controller.addAttachment(_fileAttachment(path: '/tmp/a.pdf'));

      await expectLater(
        controller.addAttachment(_fileAttachment(path: '/tmp/b.pdf')),
        throwsA(isA<AttachmentLimitReachedError>()),
      );
    });
  });
}
