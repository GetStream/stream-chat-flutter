import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('ImageHeaderThemeData copyWith, ==, hashCode basics', () {
    expect(
        const ImageHeaderThemeData(), const ImageHeaderThemeData().copyWith());
    expect(const ImageHeaderThemeData().hashCode,
        const ImageHeaderThemeData().copyWith().hashCode);
  });
}
