import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;

/// Signature for a function that produces a [Stream] of push tokens.
typedef TokenStreamProvider = Stream<String> Function();

/// A push provider configured against Stream Chat.
///
/// Pairs the Stream Chat provider [type] and dashboard [name] with a
/// [TokenStreamProvider] that yields the current device token and all
/// future refreshes.
class PushProvider {
  /// Firebase Cloud Messaging; works on both iOS and Android.
  const PushProvider.firebase({
    required this.name,
    TokenStreamProvider tokenStreamProvider = _firebaseTokenProvider,
  }) : _tokenStreamProvider = tokenStreamProvider,
       type = chat.PushProvider.firebase;

  /// Raw Apple Push Notification service.
  ///
  /// Note: raw APNs payloads lack FCM metadata, so
  /// `firebase_messaging.onMessageOpenedApp` never fires on tap —
  /// prefer [PushProvider.firebase] unless integrating with
  /// non-Firebase tooling.
  const PushProvider.apn({
    required this.name,
    TokenStreamProvider tokenStreamProvider = _apnTokenProvider,
  }) : _tokenStreamProvider = tokenStreamProvider,
       type = chat.PushProvider.apn;

  static Stream<String> _firebaseTokenProvider() async* {
    // On iOS, `getToken()` throws if the APNs token isn't registered with
    // Apple yet — and registration happens asynchronously after
    // `requestPermission()`. Poll briefly before asking for the FCM token.
    // https://firebase.google.com/docs/cloud-messaging/flutter/client#access_the_registration_token
    //
    // If APNs genuinely never arrives (simulator, missing entitlement,
    // provisioning issue), skip token emission so we don't crash on the
    // guarded `getToken` call — future token refreshes will still fire via
    // `onTokenRefresh` if APNs registration eventually succeeds.
    if (!await _awaitApnsTokenOnIOS()) {
      debugPrint(
        '[push] ⚠️ APNs token not available — skipping FCM registration. '
        'Check: (1) not on simulator, (2) Push Notifications entitlement, '
        '(3) provisioning profile.',
      );
    } else {
      final initialToken = await FirebaseMessaging.instance.getToken();
      if (initialToken != null && initialToken.isNotEmpty) yield initialToken;
    }

    yield* FirebaseMessaging.instance.onTokenRefresh;
  }

  static Stream<String> _apnTokenProvider() async* {
    final initialToken = await FirebaseMessaging.instance.getAPNSToken();
    if (initialToken != null && initialToken.isNotEmpty) yield initialToken;

    yield* FirebaseMessaging.instance.onTokenRefresh;
  }

  /// Polls `getAPNSToken` up to [attempts] times. Always `true` off iOS.
  static Future<bool> _awaitApnsTokenOnIOS({
    Duration interval = const Duration(milliseconds: 500),
    int attempts = 10,
  }) async {
    if (chat.CurrentPlatform.isWeb || !chat.CurrentPlatform.isIos) return true;
    for (var i = 0; i < attempts; i++) {
      final apns = await FirebaseMessaging.instance.getAPNSToken();
      if (apns != null && apns.isNotEmpty) return true;
      await Future<void>.delayed(interval);
    }
    return false;
  }

  /// The provider name configured in the Stream dashboard.
  final String name;

  /// The Stream Chat provider type (FCM or APNs).
  final chat.PushProvider type;

  /// Returns the current push token, or throws [TimeoutException] if
  /// the token isn't available within [timeout].
  Future<String> getToken({required Duration timeout}) {
    return onTokenRefresh.first.timeout(timeout);
  }

  /// Emits the current push token (when available), then every refresh.
  Stream<String> get onTokenRefresh => _tokenStreamProvider();
  final TokenStreamProvider _tokenStreamProvider;
}
