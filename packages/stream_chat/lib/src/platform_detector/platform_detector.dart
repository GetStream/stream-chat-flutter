import 'platform_detector_stub.dart'
    if (dart.library.html) 'platform_detector_web.dart'
    if (dart.library.io) 'platform_detector_io.dart';

/// Possible platforms
enum PlatformType {
  ///
  Android,

  ///
  Ios,

  ///
  Web,

  ///
  MacOS,

  ///
  Windows,

  ///
  Linux,

  ///
  Fuchsia,
}

/// Utility class that provides information on the current platform
class CurrentPlatform {
  CurrentPlatform._();

  /// True if the app is running on android
  static bool get isAndroid => type == PlatformType.Android;

  /// True if the app is running on ios
  static bool get isIos => type == PlatformType.Ios;

  /// True if the app is running on web
  static bool get isWeb => type == PlatformType.Web;

  /// True if the app is running on macos
  static bool get isMacOS => type == PlatformType.MacOS;

  /// True if the app is running on windows
  static bool get isWindows => type == PlatformType.Windows;

  /// True if the app is running on linux
  static bool get isLinux => type == PlatformType.Linux;

  /// True if the app is running on fuchsia
  static bool get isFuchsia => type == PlatformType.Fuchsia;

  /// Returns a string version of the platform
  static String get name {
    switch (type) {
      case PlatformType.Android:
        return 'android';
      case PlatformType.Ios:
        return 'ios';
      case PlatformType.Web:
        return 'web';
      case PlatformType.MacOS:
        return 'macos';
      case PlatformType.Windows:
        return 'windows';
      case PlatformType.Linux:
        return 'linux';
      case PlatformType.Fuchsia:
        return 'fuchsia';
      default:
        return '';
    }
  }

  /// Get current platform type
  static PlatformType get type => currentPlatform;
}
