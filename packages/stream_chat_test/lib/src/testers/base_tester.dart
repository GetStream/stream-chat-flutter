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
  ///
  /// Example:
  /// ```dart
  /// // Use the configured user's ID for authentication
  /// tester.mockSuccessfulAuth(tester.user.id);
  /// ```
  final User user;

  @override
  @protected
  final FakeChatApi chatApi;

  /// The underlying [StreamChatClient] from which the subject was built.
  ///
  /// Use this to access client-level properties and methods.
  ///
  /// Note: prefer using [subject] for testing the specific state object.
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

  /// Configures WebSocket mocks to simulate successful authentication for
  /// [userId].
  ///
  /// Use this in test setup to configure how the WebSocket should respond to
  /// connection attempts.
  ///
  /// Example:
  /// ```dart
  /// tester.mockSuccessfulAuth(tester.user.id);
  /// await tester.client.connectUser(tester.user, token); // Will succeed
  /// ```
  void mockSuccessfulAuth(String userId) {
    return _wsTester.mockSuccessfulAuth(userId);
  }

  /// Configures WebSocket mocks to simulate authentication failure.
  ///
  /// The [errorCode] parameter allows customizing the backend error code
  /// returned; default is 40 ([ChatErrorCode.tokenExpired]). With the
  /// harness's static token the connection attempt fails with a
  /// [StreamWebSocketError]; a token *provider* turns code 40 into a silent
  /// token refresh and reconnect instead.
  ///
  /// Use this in test setup when testing error scenarios.
  ///
  /// Example:
  /// ```dart
  /// tester.mockFailedAuth(errorCode: 43);
  /// await expectLater(
  ///   tester.client.connectUser(tester.user, token),
  ///   throwsA(isA<StreamWebSocketError>()),
  /// );
  /// ```
  void mockFailedAuth({int errorCode = 40}) {
    return _wsTester.mockFailedAuth(errorCode: errorCode);
  }

  /// Configures the WebSocket so that the transport fails.
  ///
  /// The channel opens, but its stream immediately errors — a broken socket
  /// rather than a server that refuses. The connection attempt fails with a
  /// retriable [StreamWebSocketError].
  ///
  /// Example:
  /// ```dart
  /// tester.mockConnectionError();
  /// await expectLater(
  ///   tester.client.connectUser(tester.user, token),
  ///   throwsA(isA<StreamWebSocketError>()),
  /// );
  /// ```
  void mockConnectionError({Object? error}) {
    return _wsTester.mockConnectionError(error: error);
  }

  /// Emits a WebSocket [event] and pumps the event loop.
  ///
  /// The event goes through the engine's real JSON frame decoding before
  /// reaching the client, exactly like a production server push. The event
  /// loop is pumped afterwards to allow async event handlers to run.
  ///
  /// Example:
  /// ```dart
  /// await tester.emitEvent(
  ///   createDefaultEvent(type: EventType.messageNew, cid: channel.cid),
  /// );
  /// expect(tester.channelState?.messages, hasLength(1));
  /// ```
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

  /// Waits for events to be processed.
  ///
  /// Returns a [Future] that completes after the event loop has run the given
  /// number of [times] (20 by default).
  ///
  /// Awaiting this approximates waiting until all asynchronous work (other
  /// than work that's waiting for external resources) completes.
  Future<void> pumpEventQueue({int times = 20}) {
    return test.pumpEventQueue(times: times);
  }

  /// Disposes resources held by this tester.
  ///
  /// This method is called automatically after each test completes.
  /// Subclasses can override this method to perform cleanup of resources such
  /// as stream subscriptions, controllers, or other state that needs explicit
  /// disposal.
  ///
  /// Subclasses that override this method should call `super.dispose()` to
  /// ensure any base cleanup is performed.
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

/// Generic test helper for chat subjects with WebSocket support.
///
/// Automatically sets up the test client, WebSocket infrastructure, and
/// coordinates the test lifecycle.
///
/// The client is real; only three seams are replaced: the REST API (a
/// [FakeChatApi] whose sub-APIs are mocks), the WebSocket transport (a mocked
/// channel driven by a [WebSocketTester], with the real [WebSocket] engine in
/// play), and optionally the persistence client.
///
/// Parameters:
/// - [user]: the user the client is configured for (defaults to
///   luke_skywalker)
/// - [token]: the static token used to connect (defaults to a development
///   token for [user])
/// - [tokenProvider]: connects through [StreamChatClient.connectUserWithProvider]
///   instead of a static token; also drives the engine's token refresh path
/// - [chatPersistenceClient]: optional persistence client assigned to the
///   client before connecting
/// - [logLevel]: the client's log level (defaults to [Level.OFF] to keep test
///   output quiet)
/// - [build]: constructs the subject under test using the provided client
/// - [createTesterFn]: the concrete tester factory function
/// - [connect]: optional, custom connection logic (defaults to successful
///   auth + connect + connection assertion)
/// - [setUp]: optional, runs before body for setting up mocks and test state
/// - [body]: the test callback that receives a tester for interactions
/// - [verify]: optional, runs after body for verifying API calls
/// - [tearDown]: optional, runs after verify for custom cleanup
/// - [skip], [tags], [timeout]: forwarded to `test`
///
/// This function is for internal use by concrete test helpers.
void testWithTester<S, T extends BaseTester<S>>(
  String description, {
  User? user,
  Token? token,
  TokenProvider? tokenProvider,
  ChatPersistenceClient? chatPersistenceClient,
  Level logLevel = Level.OFF,
  required S Function(StreamChatClient client) build,
  required TesterFactory<S, T> createTesterFn,
  FutureOr<void> Function(T tester)? connect,
  FutureOr<void> Function(T tester)? setUp,
  required FutureOr<void> Function(T tester) body,
  FutureOr<void> Function(T tester)? verify,
  FutureOr<void> Function(T tester)? tearDown,
  // NOTE(parity): typed `bool` to match stream_feeds_test, which prevents
  // passing the skip *reason* STYLE_GUIDE.md requires (`package:test` accepts
  // a String for exactly that). Widen together with the feeds package.
  bool skip = false,
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
    tester.mockSuccessfulAuth(tester.user.id);

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

// Runs the test body in a guarded zone to catch all errors.
//
// This ensures that errors from event handlers, timers, and unawaited
// futures are properly caught and reported, not just errors in the
// main async chain.
//
// NOTE(parity): errors arriving AFTER the body has completed (e.g. a timer
// armed during the test that fires in the teardown window) are silently
// dropped by the `isCompleted` guards below, whereas plain `package:test`
// would report them as "test failed after it had already completed". Kept
// as-is for parity with stream_feeds_test's base_tester; fix in both
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
