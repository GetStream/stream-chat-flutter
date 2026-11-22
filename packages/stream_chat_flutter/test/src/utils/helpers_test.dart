import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('fileSize shows a whole number of megabytes without decimals', () {
    expect(fileSize(2 * 1024 * 1024), '2 MB');
  });

  test('fileSize shows a whole number of gigabytes without decimals', () {
    expect(fileSize(2 * 1024 * 1024 * 1024), '2 GB');
  });

  test('fileSize shows a whole number of terabytes without decimals', () {
    expect(fileSize(2 * 1024 * 1024 * 1024 * 1024), '2 TB');
  });

  test('fileSize shows a whole number of petabytes without decimals', () {
    expect(fileSize(2 * 1024 * 1024 * 1024 * 1024 * 1024), '2 PB');
  });

  test('fileSize keeps the decimals of 1.5 MB', () {
    expect(fileSize(1536 * 1024), '1.50 MB');
  });

  test('fileSize keeps the decimals of 1.5 GB', () {
    expect(fileSize(1536 * 1024 * 1024), '1.50 GB');
  });

  test('fileSize keeps the decimals of 1.5 TB', () {
    expect(fileSize(1536 * 1024 * 1024 * 1024), '1.50 TB');
  });

  test('fileSize keeps the decimals of 1.5 PB', () {
    expect(fileSize(1536 * 1024 * 1024 * 1024 * 1024), '1.50 PB');
  });

  test('fileSize keeps the decimals of a size just over a whole megabyte', () {
    expect(fileSize(1024 * 1024 + 1024), '1.00 MB');
  });
}
