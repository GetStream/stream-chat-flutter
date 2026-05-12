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

  group('debugCurrentPlatformOverride', () {
    tearDown(() => CurrentPlatform.debugCurrentPlatformOverride = null);

    test('changes type, name, and flags', () {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.web;

      expect(CurrentPlatform.type, PlatformType.web);
      expect(CurrentPlatform.name, 'web');
      expect(CurrentPlatform.isWeb, isTrue);
      expect(CurrentPlatform.isLinux, isFalse);
    });

    test('clearing the override restores the real platform', () {
      CurrentPlatform.debugCurrentPlatformOverride = PlatformType.windows;
      CurrentPlatform.debugCurrentPlatformOverride = null;

      expect(CurrentPlatform.type, PlatformType.linux);
      expect(CurrentPlatform.isWindows, isFalse);
    });
  });
}
