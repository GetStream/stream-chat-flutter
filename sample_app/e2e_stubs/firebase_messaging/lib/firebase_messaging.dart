/// No-op stand-in for `firebase_messaging`, swapped in via `pubspec_overrides.e2e.yaml`.
///
/// See the `firebase_core` stub for the rationale. Only the API surface used by
/// `sample_app` is stubbed: permission requests report denied, token getters
/// return null, and the message streams never emit.
library;

/// Signature of the top-level FCM background handler.
typedef BackgroundMessageHandler = Future<void> Function(RemoteMessage message);

/// No-op replacement for the FCM entry point.
class FirebaseMessaging {
  FirebaseMessaging._();

  /// The shared no-op instance.
  static final FirebaseMessaging instance = FirebaseMessaging._();

  /// Never emits.
  static Stream<RemoteMessage> get onMessage => const Stream.empty();

  /// Never emits.
  static Stream<RemoteMessage> get onMessageOpenedApp => const Stream.empty();

  /// Does nothing; [handler] is never invoked.
  static void onBackgroundMessage(BackgroundMessageHandler handler) {}

  /// Never emits.
  Stream<String> get onTokenRefresh => const Stream.empty();

  /// Always resolves to null.
  Future<String?> getToken({String? vapidKey}) async => null;

  /// Always resolves to null.
  Future<String?> getAPNSToken() async => null;

  /// Always resolves to null.
  Future<RemoteMessage?> getInitialMessage() async => null;

  /// Always reports [AuthorizationStatus.denied].
  Future<NotificationSettings> requestPermission({
    bool alert = true,
    bool announcement = false,
    bool badge = true,
    bool carPlay = false,
    bool criticalAlert = false,
    bool provisional = false,
    bool providesAppNotificationSettings = false,
    bool sound = true,
  }) async =>
      const NotificationSettings(authorizationStatus: AuthorizationStatus.denied);

  /// Does nothing.
  Future<void> setForegroundNotificationPresentationOptions({
    bool alert = false,
    bool badge = false,
    bool sound = false,
  }) async {}
}

/// Mirrors the real enum values.
enum AuthorizationStatus {
  /// Permission granted.
  authorized,

  /// Permission denied — the stub's fixed answer.
  denied,

  /// Permission not requested yet.
  notDetermined,

  /// Provisional (quiet) permission.
  provisional,
}

/// Minimal result type for [FirebaseMessaging.requestPermission].
class NotificationSettings {
  /// Creates settings with the given [authorizationStatus].
  const NotificationSettings({required this.authorizationStatus});

  /// The reported permission state.
  final AuthorizationStatus authorizationStatus;
}

/// Minimal FCM message: only [data] is read by `sample_app`.
class RemoteMessage {
  /// Creates a message carrying [data].
  const RemoteMessage({this.data = const {}});

  /// The message payload.
  final Map<String, dynamic> data;
}
