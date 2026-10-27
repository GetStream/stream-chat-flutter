import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

/// The API key the app connects with.
///
/// The mock server accepts any key.
const kStreamApiKey = 'kv7mcsxr24p8';

/// Where the app connects, and how.
///
/// The e2e harness points it at the mock server it started for the test and
/// decides the rest per test.
class StreamConnectionOverride {
  const StreamConnectionOverride({
    this.baseURL,
    this.baseWsUrl,
    this.usePersistence = false,
    this.tokenProvider,
  });

  final String? baseURL;
  final String? baseWsUrl;

  /// Whether the client caches channels and messages on disk.
  final bool usePersistence;

  /// When set, the user connects with a token from this provider instead of
  /// the static token, so the SDK refreshes it whenever it expires.
  final Future<String> Function(String userId)? tokenProvider;
}

// One persistence client for every [StreamChatClient], so reconnecting does
// not open a second SQLite connection.
final _chatPersistenceClient = StreamChatPersistenceClient(logLevel: Level.SEVERE);

StreamChatClient _buildStreamChatClient(StreamConnectionOverride? connectionOverride) {
  return StreamChatClient(
      kStreamApiKey,
      logLevel: kDebugMode ? Level.WARNING : Level.OFF,
      retryPolicy: RetryPolicy(
        maxRetryAttempts: 3,
        shouldRetry: (client, attempt, error) => error is StreamChatNetworkError && error.isRetriable,
      ),
      baseURL: connectionOverride?.baseURL,
      baseWsUrl: connectionOverride?.baseWsUrl,
      // Lets the harness simulate a full network outage by failing every
      // HTTP request, paired with the WebSocket close from
      // `debugConnectivityStream`.
      chatApiInterceptors: [_offlineSimulationInterceptor],
    )
    ..chatPersistenceClient = switch (connectionOverride?.usePersistence) {
      true => _chatPersistenceClient,
      _ => null,
    };
}

// Rejects every Stream API request with a connection error while
// [AuthController.debugForceOffline] is set, the way a device without a
// network would.
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

/// No user is connected; the login screen shows.
final class Unauthenticated extends AuthState {
  const Unauthenticated({this.error});

  /// The error the last [AuthController.connect] failed with, if it failed.
  final Object? error;
}

/// An [AuthController.connect] call is in flight.
final class Authenticating extends AuthState {
  const Authenticating();
}

/// A user is connected; the app shell shows.
final class Authenticated extends AuthState {
  const Authenticated(this.user);

  final OwnUser user;
}

/// Owns the [StreamChatClient] lifecycle.
///
/// Shared through the process-wide [authController]. The client is kept across
/// [disconnect] and [connect], so the `StreamChat` ancestor stays mounted
/// through the transition.
class AuthController extends ValueNotifier<AuthState> {
  AuthController() : super(const Unauthenticated());

  StreamChatClient? _client;

  /// The active client, or `null` before the first [connect].
  StreamChatClient? get client => _client;

  /// Where the next client connects, and how its user authenticates.
  ///
  /// The connection settings apply when the client is built; the token
  /// provider applies on every [connect].
  StreamConnectionOverride? debugConnectionOverride;

  /// Replaces the real `connectivity_plus` monitor.
  ///
  /// Lets the harness drive the client offline and online. Null keeps the real
  /// monitor.
  Stream<List<ConnectivityResult>>? debugConnectivityStream;

  /// While true, every Stream API HTTP request fails with a simulated
  /// connection error (see [_offlineSimulationInterceptor]).
  bool debugForceOffline = false;

  /// Connects [user] with [token], or with the override's token provider.
  ///
  /// Rethrows any error from the SDK.
  Future<void> connect({required User user, required String token}) async {
    value = const Authenticating();
    final client = _client ??= _buildStreamChatClient(debugConnectionOverride);

    try {
      final ownUser = switch (debugConnectionOverride?.tokenProvider) {
        final tokenProvider? => await client.connectUserWithProvider(user, tokenProvider),
        _ => await client.connectUser(user, token),
      };
      value = Authenticated(ownUser);
    } catch (error) {
      value = Unauthenticated(error: error);
      rethrow;
    }
  }

  /// Disconnects the current user, keeping [client] for the next [connect].
  Future<void> disconnect() async {
    if (value is! Authenticated) return;
    final client = _client;
    if (client == null) return;

    value = const Unauthenticated();
    // Let the authenticated screens unmount before `disconnectUser`
    // synchronously disposes the channel state they read.
    await SchedulerBinding.instance.endOfFrame;
    client.disconnectUser(flushChatPersistence: true).ignore();
  }

  /// Tears the client down between tests, which share one app process.
  Future<void> debugReset() async {
    // Detach persistence before closing the client: a debounced state write
    // or an in-flight response could otherwise reach a closed database after
    // the test ended, and fail whichever test runs next.
    final persistence = _client?.chatPersistenceClient;
    _client?.chatPersistenceClient = null;
    await persistence?.disconnect(flush: true);
    await _client?.dispose();
    _client = null;
    debugConnectionOverride = null;
    debugConnectivityStream = null;
    debugForceOffline = false;
    value = const Unauthenticated();
  }

  @override
  void dispose() {
    _client?.dispose().ignore();
    _client = null;
    super.dispose();
  }
}

/// Process-wide [AuthController].
final authController = AuthController();
