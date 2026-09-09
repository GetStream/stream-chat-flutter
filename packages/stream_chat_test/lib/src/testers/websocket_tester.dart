import 'dart:async';
import 'dart:convert';

import 'package:mocktail/mocktail.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../helpers/mocks.dart';
import '../helpers/test_data.dart';

/// A test utility for managing WebSocket connection mocking and event emission.
///
/// This class encapsulates WebSocket channel mocking, authentication simulation,
/// and event emission for testing real-time features. It provides methods to
/// configure WebSocket behavior for both successful and failed connection
/// scenarios.
///
/// The real [WebSocket] engine is kept in play: [channelProvider] is passed as
/// its `webSocketChannelProvider`, so real URI building, frame decoding,
/// health-check monitoring and reconnection logic all run in tests — only the
/// transport is simulated.
///
/// Chat authenticates through the connect URI (token and user payload in query
/// parameters) rather than a first frame, so the fake server validates
/// credentials from the URI captured by [channelProvider] and answers through
/// the channel's stream.
///
/// This class is used internally by testers and should not be instantiated
/// directly in test code.
final class WebSocketTester {
  /// Creates a [WebSocketTester] with the given [channel] and
  /// [streamController].
  ///
  /// The [channel] is the mock WebSocket channel to configure, and
  /// [streamController] is used to emit frames that simulate server responses.
  WebSocketTester({
    required this._channel,
    required this._streamController,
  });

  // The mock WebSocket channel being configured.
  final MockWebSocketChannel _channel;

  // The stream controller used to emit WebSocket frames.
  final StreamController<Object> _streamController;

  /// Every URI the WebSocket attempted to connect with.
  ///
  /// Reconnection attempts append to this list, so tests can assert both on
  /// the auth payload of the initial attempt and on how many attempts were
  /// made.
  final List<Uri> connectUris = [];

  // The configured server reaction to a connection attempt.
  void Function(Uri uri)? _onConnectionAttempt;

  // Function to reset previous mock configuration, allowing reconfiguration
  // between test scenarios.
  WebSocketResetFunction? _resetFunction;

  /// The connection function handed to the real [WebSocket] as its
  /// `webSocketChannelProvider`.
  ///
  /// Records each connect [uri] and schedules the configured server reaction.
  WebSocketChannel channelProvider(Uri uri, {Iterable<String>? protocols}) {
    connectUris.add(uri);
    // The WebSocket subscribes to the channel's stream synchronously after
    // this returns, so a microtask always lands after the listener is
    // attached.
    scheduleMicrotask(() => _onConnectionAttempt?.call(uri));
    return _channel;
  }

  /// Configures WebSocket mocks to simulate successful authentication.
  ///
  /// Sets up the WebSocket channel to respond with a connected `health.check`
  /// event when a connection is attempted with the specified [userId]. Like
  /// the real backend, the fake server checks the credentials in the connect
  /// URI — both the connect payload's user id and the `user_id` claim of the
  /// token — and emits an error frame with code 43 (invalid token signature)
  /// when either does not match [userId].
  ///
  /// Be aware that the token in the connect URI is always the one the harness
  /// pre-loaded into the injected WebSocket's own token manager — the token
  /// argument passed to `connectUser` never reaches it (see the README's
  /// "Token handling" section), so the token check here only guards
  /// harness-level credential mistakes.
  ///
  /// Call this before connecting the client in your test setup.
  ///
  /// Example:
  /// ```dart
  /// wsTester.mockSuccessfulAuth('user-123');
  /// await client.connectUser(user, token); // Will succeed
  /// ```
  void mockSuccessfulAuth(String userId) {
    _resetFunction?.call(); // Reset previous mocks if any
    _resetFunction = _whenListenWebSocket(_channel);
    _onConnectionAttempt = (uri) {
      final auth = _ConnectAuth.fromUri(uri);
      if (auth == null || auth.userId != userId || auth.tokenUserId != userId) {
        // Wrong credentials - simulate authentication failure
        // (invalid token signature).
        return emitRawFrame(
          createDefaultConnectionErrorFrame(
            code: ChatErrorCode.tokenSignatureInvalid.code,
            message: 'invalid token signature',
          ),
        );
      }

      // Correct credentials - simulate successful authentication.
      return emitEvent(createDefaultConnectedEvent(userId: userId));
    };
  }

  /// Configures WebSocket mocks to simulate authentication failure.
  ///
  /// Sets up the WebSocket channel to always respond with an error frame when
  /// a connection is attempted, regardless of the provided credentials.
  ///
  /// The [errorCode] parameter allows customizing the backend error code
  /// returned. Default is 40 ([ChatErrorCode.tokenExpired]). All errors use
  /// HTTP status code 401.
  ///
  /// **Backend Error Codes (401 Status):**
  ///
  /// - `40`: tokenExpired — with a token *provider*, the engine silently
  ///   refreshes the token and reconnects; with a static token (the harness
  ///   default) there is no other token to load, so the connection attempt
  ///   fails with a [StreamWebSocketError].
  /// - `41`: tokenNotValidYet, `42`: tokenUsedBeforeIssuedAt,
  ///   `43`: tokenSignatureInvalid, `2`: accessKeyError, `5`: authFailed —
  ///   reported, never retried, because no other token repairs them.
  ///
  /// Call this before connecting the client when testing error scenarios.
  ///
  /// Example:
  /// ```dart
  /// wsTester.mockFailedAuth(errorCode: 43);
  /// await expectLater(
  ///   client.connectUser(user, token),
  ///   throwsA(isA<StreamWebSocketError>()),
  /// );
  /// ```
  void mockFailedAuth({int errorCode = 40}) {
    _resetFunction?.call(); // Reset previous mocks if any
    _resetFunction = _whenListenWebSocket(_channel);
    _onConnectionAttempt = (_) {
      // Always emit an authentication failure frame.
      emitRawFrame(createDefaultConnectionErrorFrame(code: errorCode));
    };
  }

  /// Configures the WebSocket so that the transport fails.
  ///
  /// The channel opens, but its stream immediately errors — a broken socket
  /// rather than a server that refuses. The connection attempt fails with a
  /// retriable [StreamWebSocketError] and the engine schedules background
  /// reconnects (cancelled when the client is disposed by the test teardown).
  ///
  /// Call this before connecting the client.
  ///
  /// Example:
  /// ```dart
  /// wsTester.mockConnectionError();
  /// await expectLater(
  ///   client.connectUser(user, token),
  ///   throwsA(isA<StreamWebSocketError>()),
  /// );
  /// ```
  void mockConnectionError({Object? error}) {
    _resetFunction?.call(); // Reset previous mocks if any
    _resetFunction = _whenListenWebSocket(_channel);
    _onConnectionAttempt = (_) {
      _streamController.addError(error ?? WebSocketChannelException('connection refused'));
    };
  }

  /// Emits a typed [event] to simulate a server message.
  ///
  /// The event goes through the engine's real JSON frame decoding before
  /// reaching the client, exactly like a production server push.
  ///
  /// **Note:** You must call [mockSuccessfulAuth] or [mockFailedAuth] before
  /// calling this method.
  ///
  /// Example:
  /// ```dart
  /// wsTester.emitEvent(
  ///   createDefaultEvent(type: EventType.messageNew, cid: 'messaging:123'),
  /// );
  /// ```
  void emitEvent(Event event) => emitRawFrame(event);

  /// Emits a raw JSON-encodable [frame] to simulate a server message.
  ///
  /// Escape hatch for frames that cannot be expressed as an [Event] — error
  /// frames, malformed payloads, or hand-written maps.
  ///
  /// Throws a [StateError] if no WebSocket connection is listening, which
  /// would otherwise make the frame vanish silently.
  void emitRawFrame(Object frame) {
    if (!_streamController.hasListener) {
      throw StateError(
        'No WebSocket connection is listening for server frames. '
        'Configure the connection (mockSuccessfulAuth / mockFailedAuth) and '
        'connect the client before emitting events.',
      );
    }
    _streamController.add(jsonEncode(frame));
  }

  // Configures the WebSocket channel mocks.
  //
  // Sets up the channel to stream frames from the tester's stream controller
  // and installs a sink spy that acknowledges outgoing health-check pings the
  // way a real server does, keeping the connection healthy for the duration
  // of a test.
  //
  // Returns a function that can be called to reset the mock configuration,
  // allowing the WebSocket to be reconfigured for different test scenarios.
  WebSocketResetFunction _whenListenWebSocket(MockWebSocketChannel webSocketChannel) {
    final webSocketSink = MockWebSocketSink();

    // Mock sink close/done, used when the engine tears the channel down.
    when(() => webSocketSink.close(any(), any())).thenAnswer((_) => Future<void>.value());
    when(() => webSocketSink.done).thenAnswer((_) => Completer<void>().future);

    // Mock channel ready state.
    when(() => webSocketChannel.ready).thenAnswer((_) => Future<void>.value());

    // Mock channel stream to use our test stream controller.
    when(() => webSocketChannel.stream).thenAnswer((_) => _streamController.stream);

    // Mock channel sink to use our test sink.
    when(() => webSocketChannel.sink).thenAnswer((_) => webSocketSink);

    // Spy on outgoing frames: acknowledge health-check pings so the engine's
    // reconnection monitor keeps seeing recent events.
    when(() => webSocketSink.add(any<Object>())).thenAnswer((invocation) {
      final frame = jsonDecode(invocation.positionalArguments.first as String) as Map<String, dynamic>;

      if (frame['type'] == EventType.healthCheck && _streamController.hasListener) {
        emitEvent(
          Event(
            type: EventType.healthCheck,
            connectionId: frame['connection_id'] as String? ?? 'test-connection-id',
          ),
        );
      }
    });

    // Return reset function to clear this mock configuration.
    return () => reset(webSocketSink);
  }
}

/// A function type for resetting WebSocket mock configuration.
///
/// This allows reconfiguring WebSocket mocks between different test scenarios
/// by resetting the previous mock setup.
typedef WebSocketResetFunction = void Function();

// The authentication material chat places in the connect URI.
class _ConnectAuth {
  const _ConnectAuth({
    required this.userId,
    required this.token,
  });

  // Parses the `json` payload from a connect [uri]; returns null when the
  // payload is missing or malformed.
  static _ConnectAuth? fromUri(Uri uri) {
    final payload = uri.queryParameters['json'];
    if (payload == null) return null;

    final Object? decoded;
    try {
      decoded = jsonDecode(payload);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, dynamic>) return null;

    if ((decoded['user_id'], decoded['user_token']) case (final String userId, final String token)) {
      return _ConnectAuth(userId: userId, token: token);
    }
    return null;
  }

  final String userId;
  final String token;

  // The `user_id` claim carried by [token], or null when the token is not a
  // decodable JWT or carries no such claim — the fake server's stand-in for
  // the backend's signature check.
  String? get tokenUserId {
    final segments = token.split('.');
    if (segments.length != 3) return null;

    try {
      // Tolerate both base64 and base64url payload encodings.
      final urlSafe = segments[1].replaceAll('+', '-').replaceAll('/', '_');
      final claimsJson = utf8.decode(base64Url.decode(base64Url.normalize(urlSafe)));
      final claims = jsonDecode(claimsJson);
      if (claims is! Map<String, dynamic>) return null;

      final userId = claims['user_id'];
      return userId is String ? userId : null;
    } on FormatException {
      return null;
    }
  }
}
