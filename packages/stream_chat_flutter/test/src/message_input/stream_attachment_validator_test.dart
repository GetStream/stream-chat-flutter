import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// The validator derives MIME from `attachment.file?.mediaType?.mimeType`,
// which is auto-resolved from the path's extension via `package:mime`.
// Tests choose paths whose extension auto-derives to the desired MIME.
Attachment _attachment({
  String type = 'file',
  String? path,
  int size = 100,
}) {
  return Attachment(
    type: type,
    uploadState: const UploadState.success(),
    file: AttachmentFile(
      path: path,
      bytes: path == null ? Uint8List.fromList([1, 2, 3]) : null,
      size: size,
    ),
  );
}

void main() {
  group('StreamAttachmentValidator.validateCount', () {
    test('returns null when total is below the limit', () {
      const validator = StreamAttachmentValidator(maxAttachmentCount: 3);
      expect(validator.validateCount(2), isNull);
    });

    test('returns null when total equals the limit', () {
      const validator = StreamAttachmentValidator(maxAttachmentCount: 3);
      expect(validator.validateCount(3), isNull);
    });

    test('returns AttachmentLimitReachedError when total exceeds the limit',
        () {
      const validator = StreamAttachmentValidator(maxAttachmentCount: 3);
      final result = validator.validateCount(4);
      expect(result, isA<AttachmentLimitReachedError>());
      expect((result! as AttachmentLimitReachedError).maxCount, 3);
    });
  });

  group('StreamAttachmentValidator.validate', () {
    test('returns null when attachment has no file', () {
      const validator = StreamAttachmentValidator();
      final attachment = Attachment(type: 'file');
      expect(validator.validate(attachment), isNull);
    });

    test('passes when both allow and block lists are empty', () {
      const validator = StreamAttachmentValidator();
      expect(validator.validate(_attachment(path: '/tmp/file.pdf')), isNull);
    });

    group('block-list (no allow-list)', () {
      test('blocks file whose name ends with a blocked extension', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/virus.exe')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('passes a non-blocked extension', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
        );
        expect(validator.validate(_attachment(path: '/tmp/doc.pdf')), isNull);
      });

      test('extension match is case-insensitive', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.EXE']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/virus.exe')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('blocks by MIME type', () {
        // `.exe` auto-resolves to `application/x-msdownload`.
        const validator = StreamAttachmentValidator(
          fileUploadConfig:
              UploadConfig(blockedMimeTypes: ['application/x-msdownload']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/file.exe')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('passes when neither extension nor MIME match the block-list', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.exe']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/doc.pdf')),
          isNull,
        );
      });
    });

    group('allow-list (no block-list)', () {
      test('passes when extension is in allow-list', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig:
              UploadConfig(allowedFileExtensions: ['.csv', '.pdf']),
        );
        expect(validator.validate(_attachment(path: '/tmp/doc.pdf')), isNull);
      });

      test('blocks when extension fails allow-list even if MIME is allowed',
          () {
        // Backend semantic: each populated list is enforced independently.
        // An allowed MIME does not compensate for a disallowed extension.
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(
            allowedFileExtensions: ['.pdf'],
            allowedMimeTypes: ['application/pdf'],
          ),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/doc.unknown')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('passes when both extension and MIME satisfy their allow-lists', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(
            allowedFileExtensions: ['.pdf'],
            allowedMimeTypes: ['application/pdf'],
          ),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/doc.pdf')),
          isNull,
        );
      });

      test(
          'a .tar.gz allow-list entry rejects .tar.gz files, since only the '
          'last extension is compared', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(allowedFileExtensions: ['.tar.gz']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/archive.tar.gz')),
          isA<AttachmentBlockedError>(),
        );
      });

      test(
          'a .tar.gz block-list entry lets .tar.gz files through, since only '
          'the last extension is compared', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.tar.gz']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/archive.tar.gz')),
          isNull,
        );
      });

      test('a .gz block-list entry blocks .tar.gz files', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.gz']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/archive.tar.gz')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('an allow-list entry without a leading dot accepts matching files',
          () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(allowedFileExtensions: ['pdf']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/report.pdf')),
          isNull,
        );
      });

      test('a .gz allow-list entry accepts .tar.gz files', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(allowedFileExtensions: ['.gz']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/archive.tar.gz')),
          isNull,
        );
      });

      test('a .tar.gz allow-list entry rejects a plain .gz file', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(allowedFileExtensions: ['.tar.gz']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/archive.gz')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('cross-dimension mixing: allow-ext + block-MIME both enforced', () {
        // `.pdf` auto-resolves to `application/pdf`. With allow-ext `.pdf` and
        // block-MIME `application/pdf`, the file passes the ext gate but
        // fails the MIME gate — demonstrating each list is enforced
        // independently.
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(
            allowedFileExtensions: ['.pdf'],
            blockedMimeTypes: ['application/pdf'],
          ),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/doc.pdf')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('blocks when neither extension nor MIME match the allow-list', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(allowedFileExtensions: ['.pdf']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/notes.txt')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('blocks file with no extension and no MIME', () {
        // No path → no extension to match; no MIME → no MIME match.
        // With an allow-list active, nothing matches → blocked.
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(allowedFileExtensions: ['.pdf']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/somefile')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('reports no extension for a blocked file without one', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(allowedFileExtensions: ['.pdf']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/somefile')),
          isA<AttachmentBlockedError>()
              .having((e) => e.fileExtension, 'fileExtension', isNull),
        );
      });
    });

    group('size limit', () {
      test('returns AttachmentTooLargeError when file exceeds backend limit',
          () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(sizeLimit: 50),
        );
        final result = validator.validate(_attachment(path: '/tmp/big.pdf'));
        expect(result, isA<AttachmentTooLargeError>());
        expect((result! as AttachmentTooLargeError).maxSize, 50);
      });

      test('ext/MIME error wins when both ext and size are invalid', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(
            blockedFileExtensions: ['.exe'],
            sizeLimit: 50,
          ),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/virus.exe')),
          isA<AttachmentBlockedError>(),
        );
      });
    });

    group('image vs file config', () {
      test('image attachments use imageUploadConfig', () {
        const validator = StreamAttachmentValidator(
          imageUploadConfig: UploadConfig(blockedFileExtensions: ['.png']),
        );
        expect(
          validator
              .validate(_attachment(type: 'image', path: '/tmp/photo.png')),
          isA<AttachmentBlockedError>(),
        );
      });

      test('non-image attachments use fileUploadConfig', () {
        const validator = StreamAttachmentValidator(
          fileUploadConfig: UploadConfig(blockedFileExtensions: ['.png']),
        );
        expect(
          validator.validate(_attachment(path: '/tmp/photo.png')),
          isA<AttachmentBlockedError>(),
        );
      });
    });
  });
}
