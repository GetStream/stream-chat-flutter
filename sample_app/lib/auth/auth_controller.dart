import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sample_app/push/push_provider.dart';
import 'package:sample_app/push/push_token_manager.dart';
import 'package:sample_app/utils/app_config.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide PushProvider;
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

/// Secure-storage keys for the active session.
const kStreamApiKey = 'STREAM_API_KEY';
const kStreamUserId = 'STREAM_USER_ID';
const kStreamToken = 'STREAM_TOKEN';

// Firebase on both platforms: raw APNs payloads lack the FCM metadata that
// `firebase_messaging.onMessageOpenedApp` needs to fire on tap.
const _kIosPushProvider = PushProvider.firebase(name: 'firebase');
const _kAndroidPushProvider = PushProvider.firebase(name: 'firebase');

/// Shared across every client so reconnecting doesn't need a second
/// SQLite connection.
final _chatPersistenceClient = StreamChatPersistenceClient(
  logLevel: Level.SEVERE,
);

bool get isE2eTestRun => authController.debugConnectionOverride != null;

Future<void> _sampleAppLogHandler(LogRecord record) async {
  if (kDebugMode) StreamChatClient.defaultLogHandler(record);

  if (isE2eTestRun) return;

  // report errors to Firebase Crashlytics
  if (record.error != null || record.stackTrace != null) {
    await FirebaseCrashlytics.instance.recordError(
      record.error,
      record.stackTrace,
      reason: record.message,
    );
  }
}

@visibleForTesting
class StreamConnectionOverride {
  const StreamConnectionOverride({this.baseURL, this.baseWsUrl});

  final String? baseURL;
  final String? baseWsUrl;
}

StreamChatClient _buildStreamChatClient(
  String apiKey, {
  StreamConnectionOverride? connectionOverride,
}) {
  const logLevel = kDebugMode ? Level.INFO : Level.SEVERE;
  return StreamChatClient(
    apiKey,
    logLevel: logLevel,
    logHandlerFunction: _sampleAppLogHandler,
    retryPolicy: RetryPolicy(
      maxRetryAttempts: 3,
      shouldRetry: (client, attempt, error) {
        return error is StreamChatNetworkError && error.isRetriable;
      },
    ),
    baseURL: connectionOverride?.baseURL,
    baseWsUrl: connectionOverride?.baseWsUrl,
  )..chatPersistenceClient = _chatPersistenceClient;
}

/// Authentication state exposed by [AuthController].
sealed class AuthState {
  const AuthState();
}

/// No user is connected; show the login flow.
final class Unauthenticated extends AuthState {
  const Unauthenticated();
}

/// An [AuthController.connect] call is in flight; show a splash/spinner.
final class Authenticating extends AuthState {
  const Authenticating();
}

/// A user is connected; show the authenticated app shell.
final class Authenticated extends AuthState {
  const Authenticated(this.user);

  /// The connected user.
  final OwnUser user;
}

/// Owns the [StreamChatClient] + [PushTokenManager] lifecycle for the
/// sample app. Use the process-wide [authController] singleton.
///
/// The underlying [client] is kept alive across [disconnect]/[connect]
/// so the `StreamChat` ancestor stays mounted through the transition —
/// widgets that read `StreamChat.of(context)` crash if it disappears.
class AuthController extends ValueNotifier<AuthState> {
  AuthController() : super(const Unauthenticated());

  StreamChatClient? _client;

  /// The active client, or `null` before the first [connect].
  StreamChatClient? get client => _client;

  @visibleForTesting
  StreamConnectionOverride? debugConnectionOverride;

  String? _activeApiKey;
  PushTokenManager? _pushTokenManager;

  /// Restores a previous session from secure storage, if any.
  ///
  /// No-op on web or when no credentials are stored; failures are
  /// swallowed so the user simply lands on the login flow.
  Future<void> tryAutoConnect() async {
    if (CurrentPlatform.isWeb) return;
    if (value is! Unauthenticated) return;

    const secureStorage = FlutterSecureStorage();
    final apiKey = await secureStorage.read(key: kStreamApiKey);
    final userId = await secureStorage.read(key: kStreamUserId);
    final token = await secureStorage.read(key: kStreamToken);
    if (userId == null || token == null) return;

    try {
      await connect(
        apiKey: apiKey ?? kDefaultStreamApiKey,
        user: User(id: userId),
        token: token,
        persistCredentials: false,
      );
    } catch (e, stk) {
      debugPrint('[auth] auto-connect failed: $e; $stk');
    }
  }

  /// Connects [user] against [apiKey] using the supplied [token].
  ///
  /// Builds a new client on the first call; reuses the existing one
  /// when [apiKey] matches, or disposes and rebuilds when it differs.
  /// On success, credentials are optionally persisted to secure storage
  /// and a [PushTokenManager] starts mirroring push tokens. Rethrows
  /// any error from `connectUser`.
  Future<void> connect({
    required String apiKey,
    required User user,
    required String token,
    bool persistCredentials = true,
  }) async {
    value = const Authenticating();

    if (_client != null && _activeApiKey != apiKey) {
      await _client!.dispose();
      _client = null;
    }

    final client = _client ??= _buildStreamChatClient(
      apiKey,
      connectionOverride: debugConnectionOverride,
    );
    _activeApiKey = apiKey;

    try {
      final ownUser = await client.connectUser(user, token);

      if (persistCredentials && !CurrentPlatform.isWeb) {
        const secureStorage = FlutterSecureStorage();
        await Future.wait([
          secureStorage.write(key: kStreamApiKey, value: apiKey),
          secureStorage.write(key: kStreamUserId, value: user.id),
          secureStorage.write(key: kStreamToken, value: token),
        ]);
      }

      if (!isE2eTestRun) {
        _pushTokenManager = PushTokenManager(
          client: client,
          iosPushProvider: _kIosPushProvider,
          androidPushProvider: _kAndroidPushProvider,
        )..registerDevice();
      }

      value = Authenticated(ownUser);
    } catch (_) {
      value = const Unauthenticated();
      rethrow;
    }
  }

  /// Disconnects the current user, keeping [client] alive for the next
  /// [connect]. No-op when not [Authenticated].
  Future<void> disconnect({bool flushPersistence = true}) async {
    if (value is! Authenticated) return;
    final client = _client;
    if (client == null) return;

    await _pushTokenManager?.unregisterDevice();
    _pushTokenManager?.dispose().ignore();
    _pushTokenManager = null;

    if (!CurrentPlatform.isWeb) {
      const secureStorage = FlutterSecureStorage();
      await secureStorage.deleteAll();
    }

    value = const Unauthenticated();
    // Let the router unmount auth-gated pages before `disconnectUser`
    // synchronously disposes channel state — otherwise the channel
    // list's final rebuild trips `channel.state != null`.
    await SchedulerBinding.instance.endOfFrame;
    client.disconnectUser(flushChatPersistence: flushPersistence).ignore();
  }

  @visibleForTesting
  Future<void> debugReset() async {
    _pushTokenManager?.dispose().ignore();
    _pushTokenManager = null;

    await _client?.dispose();
    _client = null;
    _activeApiKey = null;
    debugConnectionOverride = null;

    if (!CurrentPlatform.isWeb) {
      const secureStorage = FlutterSecureStorage();
      await secureStorage.deleteAll();
    }

    value = const Unauthenticated();
  }

  @override
  void dispose() {
    _pushTokenManager?.dispose().ignore();
    _pushTokenManager = null;
    _client?.dispose().ignore();
    _client = null;
    super.dispose();
  }
}

/// Process-wide [AuthController] singleton.
final authController = AuthController();
