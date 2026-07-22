import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Whether Firebase (Core, Crashlytics, and Cloud Messaging) is supported on
/// the current platform.
///
/// Firebase has no Linux/Windows/Fuchsia desktop support, so `main()` skips
/// `Firebase.initializeApp` there to avoid crashing on startup, and
/// `NotificationService` skips FCM setup for the same reason. It remains
/// enabled on web, Android, iOS, and macOS.
bool get isFirebaseSupported =>
    CurrentPlatform.isWeb ||
    CurrentPlatform.isAndroid ||
    CurrentPlatform.isIos ||
    CurrentPlatform.isMacOS;
