import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:sample_app/push/push_provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide PushProvider;

/// Mirrors push tokens to [client] for the current platform.
///
/// Picks [iosPushProvider] on iOS, [androidPushProvider] on Android, and
/// no-ops on web. All token-retrieval and network errors are logged and
/// swallowed so they never block login/logout.
class PushTokenManager {
  PushTokenManager({
    required this.client,
    required this.iosPushProvider,
    required this.androidPushProvider,
  });

  final StreamChatClient client;
  final PushProvider iosPushProvider;
  final PushProvider androidPushProvider;

  StreamSubscription<String>? _tokenSubscription;

  Future<void> _onTokenRefresh(String token, PushProvider provider) async {
    debugPrint('[push] token received (provider=${provider.name})');

    try {
      await client.addDevice(
        token,
        provider.type,
        pushProviderName: provider.name,
      );
      debugPrint('[push] addDevice OK (type=${provider.type.name}, name=${provider.name})');
    } catch (e, stk) {
      debugPrint('[push] addDevice failed: $e; $stk');
    }
  }

  PushProvider? get _currentPushProvider {
    if (CurrentPlatform.isWeb) return null;
    if (CurrentPlatform.isIos) return iosPushProvider;
    if (CurrentPlatform.isAndroid) return androidPushProvider;
    return null;
  }

  /// Subscribes to token refreshes and forwards each to [client].
  /// Call once per manager instance.
  void registerDevice() {
    final pushProvider = _currentPushProvider;
    if (pushProvider == null) return;

    debugPrint('[push] registering device (provider=${pushProvider.name})');
    _tokenSubscription = pushProvider.onTokenRefresh.listen(
      (token) => _onTokenRefresh(token, pushProvider),
    );
  }

  /// Removes the current device token from [client]. Uses a 3s timeout
  /// so a flaky network can't hold up logout.
  Future<void> unregisterDevice() async {
    final pushProvider = _currentPushProvider;
    if (pushProvider == null) return;

    final String token;
    try {
      token = await pushProvider.getToken(timeout: const Duration(seconds: 3));
    } catch (e) {
      debugPrint('[push] unregister: failed to get token: $e');
      return;
    }

    try {
      await client.removeDevice(token);
      debugPrint('[push] removeDevice OK');
    } catch (e, stk) {
      debugPrint('[push] removeDevice failed: $e; $stk');
    }
  }

  /// Cancels the token-refresh subscription. Idempotent.
  Future<void> dispose() async {
    await _tokenSubscription?.cancel();
    _tokenSubscription = null;
  }
}
