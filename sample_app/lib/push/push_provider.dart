import 'dart:io' show Platform;

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:stream_chat_flutter/stream_chat_flutter.dart' as chat;

/// Signature for a function that creates a [Stream] of push tokens.
typedef TokenStreamProvider = Stream<String> Function();

/// Describes a push provider configured for a specific platform.
///
/// Pairs a Stream Chat [chat.PushProvider] enum value (with its configured
/// name) with a [TokenStreamProvider] that yields the current device token
/// and subsequent refreshes.
class PushProvider {
  const PushProvider.firebase({
    required this.name,
    TokenStreamProvider tokenStreamProvider = _firebaseTokenProvider,
  }) : _tokenStreamProvider = tokenStreamProvider,
       type = chat.PushProvider.firebase;

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

  /// Returns `true` if APNs has a token by the deadline, `false` otherwise.
  /// Always returns `true` on non-iOS platforms (no-op).
  static Future<bool> _awaitApnsTokenOnIOS({
    Duration interval = const Duration(milliseconds: 500),
    int attempts = 10,
  }) async {
    if (kIsWeb || !Platform.isIOS) return true;
    for (var i = 0; i < attempts; i++) {
      final apns = await FirebaseMessaging.instance.getAPNSToken();
      if (apns != null && apns.isNotEmpty) return true;
      await Future<void>.delayed(interval);
    }
    return false;
  }

  /// The name of the push provider configured in Stream Chat.
  final String name;

  /// The Stream Chat push provider type.
  final chat.PushProvider type;

  /// Returns the current push token for the device.
  Future<String> getToken({required Duration timeout}) {
    return onTokenRefresh.first.timeout(timeout);
  }

  /// Emits the current push token for the device and emits a new token
  /// whenever the token is refreshed.
  Stream<String> get onTokenRefresh => _tokenStreamProvider();
  final TokenStreamProvider _tokenStreamProvider;
}
