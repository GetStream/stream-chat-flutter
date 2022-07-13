import 'package:stream_chat/src/core/platform_detector/platform_detector.dart';

/// Version running on web
PlatformType get currentPlatform => PlatformType.web;

/// True if the app is running in test environment.
///
/// Always returns false as we don't have environment variables on web.
bool get isFlutterTestEnvironment => false;
