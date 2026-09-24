import 'package:stream_chat/src/core/models/attachment_file.dart';
import 'package:test/test.dart';

void main() {
  test('AttachmentFile.extension returns the text after the last dot', () {
    final file = AttachmentFile(path: '/me/user/archive.tar.gz', size: 1);

    expect(file.extension, 'gz');
  });

  test('AttachmentFile.extension returns null when the name has no dot', () {
    final file = AttachmentFile(path: '/me/user/somefile', size: 1);

    expect(file.extension, isNull);
  });

  test(
    'AttachmentFile.extension returns null when the name ends with a dot',
    () {
      final file = AttachmentFile(path: '/me/user/somefile.', size: 1);

      expect(file.extension, isNull);
    },
  );
}
