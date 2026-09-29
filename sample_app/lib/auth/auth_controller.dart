import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart' hide PushProvider;
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

import '../push/push_provider.dart';
import '../push/push_token_manager.dart';
import '../utils/app_config.dart';

bool get platformSupportsPersistenceCredentials => !CurrentPlatform.isWeb && !CurrentPlatform.isMacOS;

/// Secure-storage keys for the active session.
const kStreamApiKey = 'STREAM_API_KEY';
const kStreamUserId = 'STREAM_USER_ID';
const kStreamToken = 'STREAM_TOKEN';
const kStreamBaseUrlKey = 'STREAM_BASE_URL';

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
  if (isE2eTestRun) return;

  if (kDebugMode) StreamChatClient.defaultLogHandler(record);

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
  const StreamConnectionOverride({
    this.baseURL,
    this.baseWsUrl,
    this.usePersistence = false,
  });

  final String? baseURL;
  final String? baseWsUrl;
  final bool usePersistence;
}

StreamChatClient _buildStreamChatClient(
  String apiKey, {
  String? baseUrl,
  StreamConnectionOverride? connectionOverride,
}) {
  final logLevel = connectionOverride != null ? Level.OFF : (kDebugMode ? Level.INFO : Level.SEVERE);
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
      baseURL: connectionOverride?.baseURL ?? baseUrl,
      baseWsUrl: connectionOverride?.baseWsUrl,
      // e2e only: lets the harness simulate a full network outage by failing
      // every HTTP request (paired with the WebSocket close from
      // debugConnectivityStream). See `AuthController.debugForceOffline`.
      chatApiInterceptors: connectionOverride != null ? [_offlineSimulationInterceptor] : null,
    )
    ..chatPersistenceClient = switch (connectionOverride) {
      // Production always persists.
      null => _chatPersistenceClient,
      // Under e2e, persistence is opt-in per test; the harness empties the DB
      // on teardown (see AuthController.debugReset) so it can't leak between
      // tests. Off by default keeps most e2e tests fast and DB-free.
      final override => override.usePersistence ? _chatPersistenceClient : null,
    };
}

/// Rejects every Stream API request with a connection error while
/// [AuthController.debugForceOffline] is set, mimicking a device that has lost
/// its network — the HTTP half of the e2e offline switch.
final _offlineSimulationInterceptor = InterceptorsWrapper(
  onRequest: (options, handler) {
    if (!authController.debugForceOffline) return handler.next(options);
    return handler.reject(
      DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        error: 'e2e: simulated offline',
      ),
    );
  },
);

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

  /// Whether the session is pointed at something other than the app's own
  /// defaults — a custom API key or base URL entered in "Advanced Options".
  ///
  /// Features that depend on server-side configuration only present on the
  /// demo app (the channel list's predefined filter) switch to a portable
  /// equivalent when this is true.
  bool get usingCustomBackend {
    final apiKey = _activeApiKey ?? kDefaultStreamApiKey;
    final baseUrl = _activeBaseUrl ?? '';
    return apiKey != kDefaultStreamApiKey || baseUrl != kStreamBaseUrl;
  }

  @visibleForTesting
  StreamConnectionOverride? debugConnectionOverride;

  /// Test-controlled connectivity source fed to the `StreamChat` widget.
  ///
  /// When set, it replaces the real `connectivity_plus` monitor so e2e tests
  /// can deterministically drive the client offline/online (see the e2e
  /// harness's `goOffline`/`goOnline`). Null in production (read by `app.dart`,
  /// so it can't be `@visibleForTesting` like [debugConnectionOverride]).
  Stream<List<ConnectivityResult>>? debugConnectivityStream;

  /// e2e only: when true, every Stream API HTTP request fails with a simulated
  /// connection error (see [_offlineSimulationInterceptor]). Paired with the
  /// WebSocket close driven by [debugConnectivityStream] to simulate a full
  /// network outage. Toggled by the harness's `goOffline`/`goOnline`.
  @visibleForTesting
  bool debugForceOffline = false;

  String? _activeApiKey;
  String? _activeBaseUrl;
  PushTokenManager? _pushTokenManager;

  /// Restores a previous session from secure storage, if any.
  ///
  /// No-op on platforms without credential persistence or when no credentials
  /// are stored; failures are swallowed so the user simply lands on the login
  /// flow.
  Future<void> tryAutoConnect() async {
    if (!platformSupportsPersistenceCredentials) return;
    if (value is! Unauthenticated) return;

    const secureStorage = FlutterSecureStorage();
    final apiKey = await secureStorage.read(key: kStreamApiKey);
    final userId = await secureStorage.read(key: kStreamUserId);
    final token = await secureStorage.read(key: kStreamToken);
    final baseUrl = await secureStorage.read(key: kStreamBaseUrlKey);
    if (userId == null || token == null) return;

    try {
      await connect(
        apiKey: apiKey ?? kDefaultStreamApiKey,
        user: User(id: userId),
        token: token,
        baseUrl: (baseUrl ?? '').isEmpty ? null : baseUrl,
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
    String? baseUrl,
    bool persistCredentials = true,
  }) async {
    value = const Authenticating();

    // The base URL is baked into the client at construction, so a change to it
    // needs a fresh client just as much as a change of app does.
    if (_client != null && (_activeApiKey != apiKey || _activeBaseUrl != baseUrl)) {
      await _client!.dispose();
      _client = null;
    }

    final client = _client ??= _buildStreamChatClient(
      apiKey,
      baseUrl: baseUrl,
      connectionOverride: debugConnectionOverride,
    );
    _activeApiKey = apiKey;
    _activeBaseUrl = baseUrl;

    try {
      final ownUser = await client.connectUser(user, token);

      if (persistCredentials && platformSupportsPersistenceCredentials) {
        const secureStorage = FlutterSecureStorage();
        await Future.wait([
          secureStorage.write(key: kStreamApiKey, value: apiKey),
          secureStorage.write(key: kStreamUserId, value: user.id),
          secureStorage.write(key: kStreamToken, value: token),
          secureStorage.write(key: kStreamBaseUrlKey, value: baseUrl ?? ''),
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

    if (platformSupportsPersistenceCredentials) {
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

    // Detach persistence from the client *before* closing it. Every SDK path
    // that reaches for it either uses `chatPersistenceClient?.` or is guarded by
    // `persistenceEnabled` (which is false once this is null), so anything that
    // lands after this point short-circuits instead of asserting against a
    // disconnected database. Ordering the teardown differently could not close
    // that window: a debounced channel-state write fires up to a second later,
    // and an HTTP request already on the wire cannot be cancelled at all — its
    // response builds a `ChannelClientState`, whose constructor reads the cached
    // threads. Both used to throw an async StateError, which the test framework
    // then blamed on an unrelated test that had already passed.
    final persistence = _client?.chatPersistenceClient;
    _client?.chatPersistenceClient = null;
    // dispose() won't flush; empty the DB so it can't leak into the next test.
    await persistence?.disconnect(flush: true);
    await _client?.dispose();
    _client = null;
    _activeApiKey = null;
    _activeBaseUrl = null;
    debugConnectionOverride = null;
    debugConnectivityStream = null;
    debugForceOffline = false;

    if (platformSupportsPersistenceCredentials) {
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
