@TestOn('linux')
import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';
import 'package:test/test.dart';

void main() {
  test('`.type` should return current platform', () {
    final type = CurrentPlatform.type;
    expect(type, PlatformType.linux);
  });

  test('`.name` should return current platform name', () {
    final name = CurrentPlatform.name;
    expect(name, 'linux');
  });

  test('flags', () {
    expect(CurrentPlatform.isWeb, isFalse);
    expect(CurrentPlatform.isIos, isFalse);
    expect(CurrentPlatform.isLinux, isTrue);
    expect(CurrentPlatform.isAndroid, isFalse);
    expect(CurrentPlatform.isMacOS, isFalse);
    expect(CurrentPlatform.isWindows, isFalse);
    expect(CurrentPlatform.isFuchsia, isFalse);
  });
}
