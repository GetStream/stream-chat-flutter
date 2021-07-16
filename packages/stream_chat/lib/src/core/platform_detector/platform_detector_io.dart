import 'dart:io';
import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';

/// Version running on native systems
PlatformType get currentPlatform {
  if (Platform.isWindows) return PlatformType.windows;
  if (Platform.isFuchsia) return PlatformType.fuchsia;
  if (Platform.isMacOS) return PlatformType.macOS;
  if (Platform.isLinux) return PlatformType.linux;
  if (Platform.isIOS) return PlatformType.ios;
  return PlatformType.android;
}
