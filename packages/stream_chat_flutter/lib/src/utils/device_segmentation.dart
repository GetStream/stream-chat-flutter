import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

// ignore: public_member_api_docs
bool get isMobileDevice => !kIsWeb && (Platform.isIOS || Platform.isAndroid);
// ignore: public_member_api_docs
bool get isDesktopDevice =>
    !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
// ignore: public_member_api_docs
bool get isMobileDeviceOrWeb => kIsWeb || isMobileDevice;
// ignore: public_member_api_docs
bool get isDesktopDeviceOrWeb => kIsWeb || isDesktopDevice;
