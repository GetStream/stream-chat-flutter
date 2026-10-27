import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/utils/helpers.dart';

void main() {
  test('fileSize shows a whole number of a unit without decimals', () {
    expect(fileSize(2 * 1024), '2 KB');
    expect(fileSize(2 * 1024 * 1024), '2 MB');
    expect(fileSize(2 * 1024 * 1024 * 1024), '2 GB');
  });

  test('fileSize keeps the decimals of a size that is not a whole number of a unit', () {
    expect(fileSize(1536), '1.50 KB');
    expect(fileSize(1536 * 1024), '1.50 MB');
    expect(fileSize(1536 * 1024 * 1024), '1.50 GB');
    expect(fileSize(1536 * 1024 * 1024 * 1024), '1.50 TB');
  });
}
