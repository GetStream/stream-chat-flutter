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
  static bool get isAndroid => type == PlatformType.Android;
  static bool get isIos => type == PlatformType.Ios;
  static bool get isWeb => type == PlatformType.Web;
  static bool get isMacOS => type == PlatformType.MacOS;
  static bool get isWindows => type == PlatformType.Windows;
  static bool get isLinux => type == PlatformType.Linux;
  static bool get isFuchsia => type == PlatformType.Fuchsia;

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

  static PlatformType get type => currentPlatform;
}
