import 'dart:io';
import 'platform_detector.dart';

PlatformType get currentPlatform {
  if (Platform.isWindows) return PlatformType.Windows;
  if (Platform.isFuchsia) return PlatformType.Fuchsia;
  if (Platform.isMacOS) return PlatformType.MacOS;
  if (Platform.isLinux) return PlatformType.Linux;
  if (Platform.isIOS) return PlatformType.Ios;
  return PlatformType.Android;
}
