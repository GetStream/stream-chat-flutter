import 'dart:async';

import 'package:meta/meta.dart';
import 'package:stream_chat/src/core/http/token.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/src/ws/websocket.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:test/test.dart' as test;

import '../helpers/api_mocker_mixin.dart';
import '../helpers/mocks.dart';
import '../helpers/test_data.dart';
import 'websocket_tester.dart';

// The api key and WS base url the test client is configured with.
const _testApiKey = 'test-api-key';
const _testBaseWsUrl = 'wss://chat.test.stream-io-api.com';

/// Factory function signature for creating tester instances.
///
/// All concrete tester factory functions must conform to this signature.
typedef TesterFactory<S, T extends BaseTester<S>> =
    Future<T> Function({
      required S subject,
      required User user,
      required StreamChatClient client,
      required FakeChatApi chatApi,
      required WebSocketTester wsTester,
    });

/// Base class for all test utilities with WebSocket support.
///
/// Provides common functionality for emitting events, pumping the event queue,
/// and making assertions about the state object being tested.
///
/// Type parameter [S] is the subject being tested.
abstract base class BaseTester<S> with ApiMockerMixin {
  /// Creates a [BaseTester] wiring the [subject] to the harness-provided
  /// [user], [client], [chatApi] and [wsTester].
  const BaseTester({
    required this.subject,
    required this.user,
    required this.chatApi,
    required this._client,
    required this._wsTester,
  });

  /// The subject being tested.
  final S subject;

  /// The user for whom the test client is configured.
  ///
  /// This is the user used for authentication and for performing all actions
  /// through the client.
  final User user;

  @override
  @protected
  final FakeChatApi chatApi;

  /// The underlying [StreamChatClient] from which the [subject] was built.
  StreamChatClient get client => _client;
  final StreamChatClient _client;

  /// The currently connected user's state, if any.
  ///
  /// Null until the client has connected.
  OwnUser? get currentUser => _client.state.currentUser;

  // WebSocket tester for managing WebSocket interactions.
  final WebSocketTester _wsTester;

  /// Every URI the WebSocket attempted to connect with.
  ///
  /// Reconnection attempts append to this list, so tests can assert both on
  /// the auth payload of the initial attempt and on how many attempts were
  /// made.
  List<Uri> get connectUris => _wsTester.connectUris;

  /// Configures the fake server to accept a connection attempt for [user],
  /// defaulting to the user this tester is configured with.
  ///
  /// Attempts carrying a different user id, or a token whose `user_id` claim
  /// does not match, are rejected with an invalid-token-signature error frame.
  /// The connected event echoes [user] back as the `me` payload.
  void mockSuccessfulAuth([User? user]) {
    return _wsTester.mockSuccessfulAuth(user ?? this.user);
  }

  /// Configures the fake server to reject every connection attempt with an
  /// error frame carrying [errorCode].
  ///
  /// The default 40 ([ChatErrorCode.tokenExpired]) fails the attempt with a
  /// [StreamWebSocketError] under the harness's static token; with a token
  /// provider it triggers a silent token refresh and reconnect instead. All
  /// other codes fail the attempt regardless of the token setup.
  void mockFailedAuth({int errorCode = 40}) {
    return _wsTester.mockFailedAuth(errorCode: errorCode);
  }

  /// Configures the WebSocket transport to fail with [error].
  ///
  /// The channel opens, but its stream immediately errors — a broken socket
  /// rather than a server that refuses. The connection attempt fails with a
  /// retriable [StreamWebSocketError].
  void mockConnectionError({Object? error}) {
    return _wsTester.mockConnectionError(error: error);
  }

  /// Emits a WebSocket [event] and pumps the event loop.
  ///
  /// The event goes through the engine's real JSON frame decoding before
  /// reaching the client, exactly like a production server push.
  Future<void> emitEvent(Event event) async {
    _wsTester.emitEvent(event);
    await pumpEventQueue();
  }

  /// Emits a raw JSON-encodable WebSocket [frame] and pumps the event loop.
  ///
  /// Escape hatch for frames that cannot be expressed as an [Event] — error
  /// frames, malformed payloads, or hand-written maps.
  Future<void> emitRawFrame(Object frame) async {
    _wsTester.emitRawFrame(frame);
    await pumpEventQueue();
  }

  /// Waits for pending asynchronous work by running the event loop [times]
  /// times.
  Future<void> pumpEventQueue({int times = 20}) {
    return test.pumpEventQueue(times: times);
  }

  /// Disposes resources held by this tester.
  ///
  /// Called automatically after each test completes. Overrides must call
  /// `super.dispose()`.
  @mustCallSuper
  Future<void> dispose() async {}
}

/// Creates a tester instance, registering its disposal as a test tear-down.
///
/// This function is for internal use by concrete tester factories only.
Future<T> createTester<T extends BaseTester<Object?>>({
  required T Function() create,
}) async {
  final tester = create();
  test.addTearDown(tester.dispose); // Dispose tester after test
  return tester;
}

/// Generic test helper backing the concrete `<subject>Test` entry points.
///
/// Builds a real [StreamChatClient] with three replaced seams — the REST API
/// (a [FakeChatApi] whose sub-APIs are mocks), the WebSocket transport (a
/// mocked channel behind the real [WebSocket] engine) and optionally
/// [chatPersistenceClient] — then runs the phases
/// `connect → setUp → body → verify → tearDown` in a guarded zone.
///
/// [verify] and [tearDown] run straight after [body], in the same zone and
/// under the same error handling: the split is a readability convention, not
/// an isolation boundary, and a [body] that throws skips both.
///
/// The default connect phase authenticates [user] with [token], or through
/// [tokenProvider] when given (which takes precedence over [token]), and
/// asserts the connection; [connect] replaces it entirely. [logLevel] and
/// [isLocalUnreadCountEnabled] are forwarded to the client constructor;
/// [skip], [tags] and [timeout] to `test`. [skip] carries the reason to skip
/// this test; omit it to run the test.
///
/// This function is for internal use by concrete test helpers.
void testWithTester<S, T extends BaseTester<S>>(
  String description, {
  User? user,
  Token? token,
  TokenProvider? tokenProvider,
  ChatPersistenceClient? chatPersistenceClient,
  Level logLevel = Level.OFF,
  bool isLocalUnreadCountEnabled = false,
  required S Function(StreamChatClient client) build,
  required TesterFactory<S, T> createTesterFn,
  FutureOr<void> Function(T tester)? connect,
  FutureOr<void> Function(T tester)? setUp,
  required FutureOr<void> Function(T tester) body,
  FutureOr<void> Function(T tester)? verify,
  FutureOr<void> Function(T tester)? tearDown,
  String? skip,
  Iterable<String> tags = const [],
  test.Timeout? timeout,
}) {
  return test.test(
    description,
    skip: skip,
    tags: tags,
    timeout: timeout,
    () async {
      await _runZonedGuarded(() async {
        registerChatFallbackValues();

        final testUser = user ?? createDefaultUser();
        final testToken = token ?? createTestToken(testUser.id);

        final chatApi = FakeChatApi();
        final webSocketChannel = MockWebSocketChannel();

        // Broadcast so the engine can listen again after a disconnect, the
        // way a real socket can be reopened.
        final serverFrames = StreamController<Object>.broadcast();
        test.addTearDown(serverFrames.close); // Close controller after test

        final wsTester = WebSocketTester(
          channel: webSocketChannel,
          streamController: serverFrames,
        );

        // NOTE(hack): the client's TokenManager is private and only wired into
        // the WebSocket the client builds itself, so the injected WebSocket
        // gets its own manager, pre-loaded with the harness credentials.
        // Consequence: the token argument passed to `connectUser` never
        // reaches the connect URI — the harness `token:`/`tokenProvider:` is
        // what authenticates. The proper fix is a `@visibleForTesting
        // TokenManager?` seam on the StreamChatClient constructor so the
        // client and the injected WebSocket share one manager (validated: the
        // full stream_chat suite passes with it); adopt it together with the
        // internals-access re-evaluation. See README "Token handling".
        final wsTokenManager = TokenManager();
        await wsTokenManager.setTokenOrProvider(
          testUser.id,
          token: tokenProvider == null ? testToken : null,
          provider: tokenProvider,
        );

        late StreamChatClient client;
        final ws = WebSocket(
          apiKey: _testApiKey,
          baseUrl: _testBaseWsUrl,
          tokenManager: wsTokenManager,
          // Late-bound on purpose: no frame can be decoded before connect(),
          // which is only reachable through the client assigned right below.
          handler: (event) => client.handleEvent(event),
          webSocketChannelProvider: wsTester.channelProvider,
        );

        client = StreamChatClient(
          _testApiKey,
          chatApi: chatApi,
          ws: ws,
          logLevel: logLevel,
          isLocalUnreadCountEnabled: isLocalUnreadCountEnabled,
        )..chatPersistenceClient = chatPersistenceClient;
        test.addTearDown(client.dispose); // Dispose client after test

        final tester = await createTesterFn(
          subject: build.call(client),
          user: testUser,
          client: client,
          chatApi: chatApi,
          wsTester: wsTester,
        );

        // Connecting fires a background app-settings fetch; stub it up front
        // so custom connect phases don't hit an unstubbed mock.
        tester.mockApi(
          (api) => api.general.getAppSettings(),
          result: createDefaultGetAppSettingsResponse(),
        );

        final connectFn = connect ?? _defaultConnect(token: testToken, tokenProvider: tokenProvider);
        await connectFn.call(tester);

        await setUp?.call(tester);
        await body(tester);
        await verify?.call(tester);
        await tearDown?.call(tester);
      });
    },
  );
}

// Default connect implementation: mock successful auth, connect the client
// and assert the connection was established.
FutureOr<void> Function(BaseTester<Object?>) _defaultConnect({
  required Token token,
  TokenProvider? tokenProvider,
}) {
  return (tester) async {
    // Mock successful authentication for the configured user.
    tester.mockSuccessfulAuth();

    // Connect the client.
    final ownUser = await switch (tokenProvider) {
      final provider? => tester.client.connectUserWithProvider(tester.user, provider),
      _ => tester.client.connectUser(tester.user, token.rawValue),
    };

    // Verify the client is connected.
    test.expect(ownUser.id, tester.user.id);
    test.expect(tester.client.wsConnectionStatus, ConnectionStatus.connected);
  };
}

// Runs the test body in a guarded zone.
//
// Errors raised outside the main async chain while the body runs — from event
// handlers, timers and unawaited futures — fail the test instead of escaping
// it. Errors arriving after the body completes do not; see the note below.
//
// NOTE(parity): errors arriving AFTER the body has completed (e.g. a timer
// armed during the test that fires in the teardown window) are silently
// dropped by the `isCompleted` guards below, whereas plain `package:test`
// would report them as "test failed after it had already completed". The
// window is most relevant after `mockConnectionError`, which leaves the
// engine scheduling background reconnect work that only teardown cancels.
// Kept as-is for parity with stream_feeds_test's base_tester; fix in both
// packages together by forwarding post-completion errors to the parent zone.
Future<void> _runZonedGuarded(Future<void> Function() body) {
  final completer = Completer<void>();
  runZonedGuarded(
    () async {
      await body();
      if (!completer.isCompleted) completer.complete();
    },
    (error, stackTrace) {
      if (!completer.isCompleted) completer.completeError(error, stackTrace);
    },
  );
  return completer.future;
}
