import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test(
    'StreamAttachmentPickerController.addAttachment throws when the upload '
    'config blocks the file',
    () async {
      final controller = _controller(
        const StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
        ),
      );

      await expectLater(
        controller.addAttachment(_fileAttachment('setup.exe')),
        throwsA(isA<AttachmentBlockedError>()),
      );
    },
  );

  test(
    'StreamAttachmentPickerController.addAttachment keeps a blocked file out '
    'of the attachments',
    () async {
      final controller = _controller(
        const StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
        ),
      );

      try {
        await controller.addAttachment(_fileAttachment('setup.exe'));
      } on AttachmentBlockedError catch (_) {}

      expect(controller.value.attachments, isEmpty);
    },
  );

  test(
    'StreamAttachmentPickerController.addAttachment throws when the file '
    'exceeds the size limit',
    () async {
      final controller = _controller(
        const StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(sizeLimit: 500),
        ),
      );

      await expectLater(
        controller.addAttachment(_fileAttachment('report.pdf', size: 600)),
        throwsA(const AttachmentTooLargeError(fileSize: 600, maxSize: 500)),
      );
    },
  );

  test(
    'StreamAttachmentPickerController throws when the value holds more '
    'attachments than the count limit',
    () {
      final controller = _controller(
        const StreamAttachmentValidator(maxAttachmentCount: 1),
      );
      final attachments = [
        _fileAttachment('a.pdf'),
        _fileAttachment('b.pdf'),
      ];

      expect(
        () => controller.value = controller.value.copyWith(
          attachments: attachments,
        ),
        throwsA(const AttachmentLimitReachedError(maxCount: 1)),
      );
    },
  );

  test(
    'StreamAttachmentPickerController allows 10 attachments when no '
    'validator is given',
    () {
      final controller = StreamAttachmentPickerController();
      addTearDown(controller.dispose);

      expect(controller.validator.maxAttachmentCount, 10);
    },
  );

  test('StreamAttachmentPickerController can be subclassed', () {
    final controller = _SubclassedController();
    addTearDown(controller.dispose);

    expect(controller.validator.maxAttachmentCount, 5);
  });

  test(
    'StreamAttachmentPickerController applies the deprecated '
    'maxAttachmentSize to both upload configs',
    () {
      final controller = StreamAttachmentPickerController(
        maxAttachmentSize: 500,
      );
      addTearDown(controller.dispose);

      final validator = controller.validator;
      expect(validator.fileUploadConfig.sizeLimit, 500);
      expect(validator.imageUploadConfig.sizeLimit, 500);
    },
  );

  test(
    'StreamAttachmentPickerController applies the deprecated '
    'maxAttachmentCount to the validator',
    () {
      final controller = StreamAttachmentPickerController(
        maxAttachmentCount: 3,
      );
      addTearDown(controller.dispose);

      expect(controller.validator.maxAttachmentCount, 3);
    },
  );
}

StreamAttachmentPickerController _controller(
  StreamAttachmentValidator validator,
) {
  final controller = StreamAttachmentPickerController(validator: validator);
  addTearDown(controller.dispose);
  return controller;
}

Attachment _fileAttachment(String name, {int size = 1024}) {
  return Attachment(
    type: AttachmentType.file,
    file: AttachmentFile(path: '/tmp/$name', size: size),
  );
}

class _SubclassedController extends StreamAttachmentPickerController {
  _SubclassedController()
      : super(
          validator: const StreamAttachmentValidator(maxAttachmentCount: 5),
        );
}
