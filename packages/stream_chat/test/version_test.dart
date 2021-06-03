import 'dart:io';

import 'package:stream_chat/version.dart';
import 'package:test/test.dart';

void prepareTest() {
  // https://github.com/flutter/flutter/issues/20907
  if (Directory.current.path.endsWith('/test')) {
    Directory.current = Directory.current.parent;
  }
}

void main() {
  prepareTest();
  test('stream chat version matches pubspec', () {
    final pubspecPath = '${Directory.current.path}/pubspec.yaml';
    final pubspec = File(pubspecPath).readAsStringSync();
    // ignore: unnecessary_string_escapes
    final regex = RegExp('version:\s*(.*)');
    final match = regex.firstMatch(pubspec);
    expect(match, isNotNull);
    expect(PACKAGE_VERSION, match?.group(1)?.trim());
  });
}
