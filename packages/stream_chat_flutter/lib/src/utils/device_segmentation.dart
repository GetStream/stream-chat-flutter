import 'dart:io' show Platform;

import 'package:flutter/foundation.dart'
    show TargetPlatform, debugDefaultTargetPlatformOverride, kIsWeb;

// ignore: public_member_api_docs
bool get isMobileDevice => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
// ignore: public_member_api_docs
bool get isDesktopDevice =>
    !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
// ignore: public_member_api_docs
bool get isMobileDeviceOrWeb => kIsWeb || isMobileDevice;
// ignore: public_member_api_docs
bool get isDesktopDeviceOrWeb => kIsWeb || isDesktopDevice;

// ignore: public_member_api_docs
bool get isMobileTestEnvironment =>
    debugDefaultTargetPlatformOverride == TargetPlatform.android ||
    debugDefaultTargetPlatformOverride == TargetPlatform.iOS;

// ignore: public_member_api_docs
bool get isDesktopTestEnvironment =>
    debugDefaultTargetPlatformOverride == TargetPlatform.macOS ||
    debugDefaultTargetPlatformOverride == TargetPlatform.windows ||
    debugDefaultTargetPlatformOverride == TargetPlatform.linux;

// ignore: public_member_api_docs
bool get isWebTestEnvironment =>
    !isMobileTestEnvironment && !isDesktopTestEnvironment;
