import 'dart:typed_data';

import 'package:stream_chat/src/core/models/attachment_file.dart';
import 'package:test/test.dart';

import '../../utils.dart';

void main() {
  group('src/models/attachment_file', () {
    test('should parse json correctly', () {
      final attachment =
          AttachmentFile.fromJson(jsonFixture('attachment_file.json'));
      expect(attachment.name, 'test.jpg');
      expect(attachment.size, 12);
      expect(
        attachment.path,
        '/me/user/test.jpg',
      );
    });

    group('extension', () {
      test('returns the text after the last dot', () {
        final file = AttachmentFile(path: '/me/user/archive.tar.gz', size: 1);
        expect(file.extension, 'gz');
      });

      test('returns null when the name has no extension', () {
        final file = AttachmentFile(path: '/me/user/somefile', size: 1);
        expect(file.extension, isNull);
      });

      test('returns null when the name ends with a dot', () {
        final file = AttachmentFile(path: '/me/user/somefile.', size: 1);
        expect(file.extension, isNull);
      });
    });

    test('should serialize to json correctly', () {
      final attachment = AttachmentFile(
        size: 12,
        bytes: Uint8List.fromList([1, 2, 3]),
        name: 'test.jpg',
        path: '/me/user/test.jpg',
      );

      expect(
        attachment.toJson(),
        {
          'size': 12,
          'name': 'test.jpg',
          'path': '/me/user/test.jpg',
        },
      );
    });
  });
}
