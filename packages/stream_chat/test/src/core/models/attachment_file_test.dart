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
