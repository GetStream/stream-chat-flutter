import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

AppSettings _makeFileSettings({
  List<String> blocked = const [],
  List<String> allowed = const [],
}) {
  return AppSettings(
    name: 'test',
    fileUploadConfig: UploadConfig(
      blockedFileExtensions: blocked,
      allowedFileExtensions: allowed,
    ),
    imageUploadConfig: UploadConfig(),
    autoTranslationEnabled: false,
    asyncUrlEnrichEnabled: false,
  );
}

Attachment _fileAttachment({required String path, int size = 100}) {
  return Attachment(
    type: 'file',
    uploadState: const UploadState.success(),
    file: AttachmentFile(path: path, size: size),
  );
}

void main() {
  group('StreamAttachmentPickerController.addAttachment', () {
    group('Fix 2 — extension extraction', () {
      test('path without a dot passes an allow-list (null extension = allowed)', () async {
        // Before the fix, split('.').last on '/tmp/somefile' returned the full
        // path string, which is not in the allow-list and wrongly blocked the
        // file. After the fix, extension is null, which isAllowed treats as
        // "no extension → allowed".
        final controller = StreamAttachmentPickerController(
          appSettings: _makeFileSettings(allowed: ['.pdf']),
        );
        addTearDown(controller.dispose);

        await expectLater(
          controller.addAttachment(_fileAttachment(path: '/tmp/somefile')),
          completes,
        );
      });

      test('path without a dot is not blocked by a block-list', () async {
        final controller = StreamAttachmentPickerController(
          appSettings: _makeFileSettings(blocked: ['.exe']),
        );
        addTearDown(controller.dispose);

        await expectLater(
          controller.addAttachment(_fileAttachment(path: '/tmp/somefile')),
          completes,
        );
      });

      test('path with a dot correctly extracts extension and enforces block-list', () async {
        final controller = StreamAttachmentPickerController(
          appSettings: _makeFileSettings(blocked: ['.exe']),
        );
        addTearDown(controller.dispose);

        await expectLater(
          controller.addAttachment(_fileAttachment(path: '/tmp/virus.exe')),
          throwsA(isA<AttachmentBlockedError>()),
        );
      });

      test('path with a dot correctly extracts extension and enforces allow-list', () async {
        final controller = StreamAttachmentPickerController(
          appSettings: _makeFileSettings(allowed: ['.pdf']),
        );
        addTearDown(controller.dispose);

        // '.pdf' is in the allow-list → should pass.
        await expectLater(
          controller.addAttachment(_fileAttachment(path: '/tmp/document.pdf')),
          completes,
        );

        // '.txt' is not in the allow-list → should be blocked.
        await expectLater(
          controller.addAttachment(_fileAttachment(path: '/tmp/notes.txt')),
          throwsA(isA<AttachmentBlockedError>()),
        );
      });

      test('path with multiple dots uses only the last segment as extension', () async {
        final controller = StreamAttachmentPickerController(
          appSettings: _makeFileSettings(allowed: ['.pdf']),
        );
        addTearDown(controller.dispose);

        // 'my.report.pdf' → last segment = 'pdf', which is allowed.
        // Before the fix this worked by coincidence. After the fix the logic
        // is explicit: split('.').last when a dot exists.
        await expectLater(
          controller.addAttachment(_fileAttachment(path: '/tmp/my.report.pdf')),
          completes,
        );
      });

      test('path is null → extension is null → always allowed', () async {
        // null path is the case for web or when the file has no path yet.
        final controller = StreamAttachmentPickerController(
          appSettings: _makeFileSettings(allowed: ['.pdf']),
        );
        addTearDown(controller.dispose);

        await expectLater(
          controller.addAttachment(
            Attachment(
              type: 'file',
              uploadState: const UploadState.success(),
              file: AttachmentFile(
                path: null,
                bytes: Uint8List.fromList([1, 2, 3]),
                size: 3,
              ),
            ),
          ),
          completes,
        );
      });
    });
  });
}
