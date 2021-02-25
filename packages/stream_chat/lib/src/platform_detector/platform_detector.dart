import 'platform_detector_stub.dart'
    if (dart.library.html) 'platform_detector_web.dart'
    if (dart.library.io) 'platform_detector_io.dart';

enum PlatformType {
  Android,
  Ios,
  Web,
  MacOS,
  Windows,
  Linux,
  Fuchsia,
}

class CurrentPlatform {
  CurrentPlatform._();
  static bool get isAndroid => currentPlatform == PlatformType.Android;
  static bool get isIos => currentPlatform == PlatformType.Ios;
  static bool get isWeb => currentPlatform == PlatformType.Web;
  static bool get isMacOS => currentPlatform == PlatformType.MacOS;
  static bool get isWindows => currentPlatform == PlatformType.Windows;
  static bool get isLinux => currentPlatform == PlatformType.Linux;
  static bool get isFuchsia => currentPlatform == PlatformType.Fuchsia;

  static String get name {
    switch (currentPlatform) {
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

  PlatformType get type => currentPlatform;
}
