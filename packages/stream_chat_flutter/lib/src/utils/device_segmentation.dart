import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

// ignore_for_file: public_member_api_docs

bool get isMobileDevice => !kIsWeb && (Platform.isIOS || Platform.isAndroid);

bool get isDesktopDevice =>
    !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);

bool get isDesktopVideoPlayerSupported =>
    !kIsWeb && (!Platform.isMacOS && Platform.isWindows || Platform.isLinux);

bool get isMobileDeviceOrWeb => kIsWeb || isMobileDevice;

bool get isDesktopDeviceOrWeb => kIsWeb || isDesktopDevice;

bool get isTestEnvironment =>
    !kIsWeb && (Platform.environment.containsKey('FLUTTER_TEST'));
