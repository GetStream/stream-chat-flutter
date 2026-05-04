import 'package:meta/meta.dart' show visibleForTesting;
import 'package:stream_chat/src/core/platform_detector/platform_detector_stub.dart'
    if (dart.library.html) 'platform_detector_web.dart'
    if (dart.library.io) 'platform_detector_io.dart';

/// Possible platforms
enum PlatformType {
  /// Android: <https://www.android.com/>
  android,

  /// iOS: <https://www.apple.com/ios/>
  ios,

  /// web: <https://en.wikipedia.org/wiki/World_Wide_Web>
  web,

  /// macOS: <https://www.apple.com/macos>
  macOS,

  /// Windows: <https://www.windows.com>
  windows,

  /// Linux: <https://www.linux.org>
  linux,

  /// Fuchsia: <https://fuchsia.dev/fuchsia-src/concepts>
  fuchsia,
}

/// Utility class that provides information on the current platform
class CurrentPlatform {
  CurrentPlatform._();

  /// True if the app is running on android
  static bool get isAndroid => type == PlatformType.android;

  /// True if the app is running on ios
  static bool get isIos => type == PlatformType.ios;

  /// True if the app is running on web
  static bool get isWeb => type == PlatformType.web;

  /// True if the app is running on macos
  static bool get isMacOS => type == PlatformType.macOS;

  /// True if the app is running on windows
  static bool get isWindows => type == PlatformType.windows;

  /// True if the app is running on linux
  static bool get isLinux => type == PlatformType.linux;

  /// True if the app is running on fuchsia
  static bool get isFuchsia => type == PlatformType.fuchsia;

  /// True if the app is running in test environment
  static bool get isFlutterTest => isFlutterTestEnvironment;

  /// Returns a string version of the platform
  static String get name {
    return switch (type) {
      PlatformType.android => 'android',
      PlatformType.ios => 'ios',
      PlatformType.web => 'web',
      PlatformType.macOS => 'macos',
      PlatformType.windows => 'windows',
      PlatformType.linux => 'linux',
      PlatformType.fuchsia => 'fuchsia',
    };
  }

  /// Override the value reported by [type] in tests.
  ///
  /// Setting this affects all reads of [type], [name], and the per-platform
  /// flags ([isAndroid], [isWeb], …). Reset to `null` after each test (e.g.
  /// in `tearDown`) to avoid leaking state.
  ///
  /// The override is honored only when asserts are enabled (debug, profile,
  /// and tests); release builds tree-shake it away. Mirrors Flutter's
  /// `debugDefaultTargetPlatformOverride`.
  @visibleForTesting
  static PlatformType? debugCurrentPlatformOverride;

  /// Get current platform type
  static PlatformType get type {
    var result = currentPlatform;
    assert(
      () {
        if (debugCurrentPlatformOverride case final override?) {
          result = override;
        }
        return true;
      }(),
      'debugCurrentPlatformOverride applied',
    );
    return result;
  }
}
