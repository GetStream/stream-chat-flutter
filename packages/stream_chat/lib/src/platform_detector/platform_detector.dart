import 'package:stream_chat/src/platform_detector/platform_detector_stub.dart'
    if (dart.library.html) 'platform_detector_web.dart'
    if (dart.library.io) 'platform_detector_io.dart';

/// Possible platforms
enum PlatformType {
  ///
  android,

  ///
  ios,

  ///
  web,

  ///
  macOS,

  ///
  windows,

  ///
  linux,

  ///
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

  /// Returns a string version of the platform
  static String get name {
    switch (type) {
      case PlatformType.android:
        return 'android';
      case PlatformType.ios:
        return 'ios';
      case PlatformType.web:
        return 'web';
      case PlatformType.macOS:
        return 'macos';
      case PlatformType.windows:
        return 'windows';
      case PlatformType.linux:
        return 'linux';
      case PlatformType.fuchsia:
        return 'fuchsia';
      default:
        return '';
    }
  }

  /// Get current platform type
  static PlatformType get type => currentPlatform;
}
