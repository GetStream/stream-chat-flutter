import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:sample_app/push/push_provider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide PushProvider;

/// Manages push-token registration for the current [StreamChatClient].
///
/// Picks the right [PushProvider] for the current platform, listens for token
/// refreshes, and mirrors them to Stream Chat via `addDevice` / `removeDevice`.
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

    // Clear any stale registrations (old provider, prior installs with a
    // different token) before re-registering. Preserves rows that already
    // match the current token so legitimate multi-device setups aren't wiped.
    await _removeStaleDevices(currentToken: token);

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

  Future<void> _removeStaleDevices({required String currentToken}) async {
    try {
      final response = await client.getDevices();
      for (final device in response.devices) {
        if (device.id == currentToken) continue;
        try {
          await client.removeDevice(device.id);
          debugPrint('[push] removed stale device id=${device.id} provider=${device.pushProvider}');
        } catch (e) {
          debugPrint('[push] failed to remove stale device id=${device.id}: $e');
        }
      }
    } catch (e, stk) {
      debugPrint('[push] getDevices failed: $e; $stk');
    }
  }

  PushProvider? get _currentPushProvider {
    if (kIsWeb) return null;
    if (Platform.isIOS) return iosPushProvider;
    if (Platform.isAndroid) return androidPushProvider;
    return null;
  }

  void registerDevice() {
    final pushProvider = _currentPushProvider;
    if (pushProvider == null) return;

    debugPrint('[push] registering device (provider=${pushProvider.name})');
    _tokenSubscription = pushProvider.onTokenRefresh.listen(
      (token) => _onTokenRefresh(token, pushProvider),
    );
  }

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

  Future<void> dispose() async {
    await _tokenSubscription?.cancel();
    _tokenSubscription = null;
  }
}
