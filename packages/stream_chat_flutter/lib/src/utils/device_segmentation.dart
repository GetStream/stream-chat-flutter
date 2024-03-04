import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Returns true if the app is running on web.
bool get isWeb => CurrentPlatform.isWeb;

/// Returns true if the app is running in a mobile device.
bool get isMobileDevice => CurrentPlatform.isIos || CurrentPlatform.isAndroid;

/// Returns true if the app is running in a desktop device.
bool get isDesktopDevice =>
    CurrentPlatform.isMacOS ||
    CurrentPlatform.isWindows ||
    CurrentPlatform.isLinux;

/// Returns true if the app is running on Microsoft Windows or GNU/Linux.
bool get isDesktopVideoPlayerSupported =>
    // package:media_kit is not used on macOS.
    !CurrentPlatform.isMacOS &&
    (CurrentPlatform.isWindows || CurrentPlatform.isLinux);

/// Returns true if the app is running in a mobile or web.
bool get isMobileDeviceOrWeb => isWeb || isMobileDevice;

/// Returns true if the app is running in a desktop or web.
bool get isDesktopDeviceOrWeb => isWeb || isDesktopDevice;

/// Returns true if the app is running in a flutter test environment.
bool get isTestEnvironment => CurrentPlatform.isFlutterTest;
