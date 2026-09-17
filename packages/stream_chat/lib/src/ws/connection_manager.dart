import 'dart:async';

import 'package:stream_core/stream_core.dart';

import '../core/models/own_user.dart';
import 'connect_request.dart';
import 'events/events.dart';
import 'stream_chat_ws_event.dart';

/// The connection a `StreamChatClient` works over.
///
/// Opens and closes the connection, answers for the id the server issues it, and reopens one that
/// drops. Obtained via `StreamChatClient`; not constructed directly.
class ConnectionManager with Disposable {
  /// Creates a [ConnectionManager] that connects with [request].
  ///
  /// [wsProvider] stands in for the socket, for tests that drive one without a server.
  ///
  /// Reports under [tag], and the socket and recovery handler it owns under `<tag>:Ws` and
  /// `<tag>:Recovery`, so one prefix selects the whole family.
  ConnectionManager({
    required this._request,
    required TokenManager tokenManager,
    WebSocketProvider? wsProvider,
    String tag = 'SCh:Connection',
  }) : _tokens = tokenManager,
       _logger = StreamLogger(tag) {
    _ws = StreamWebSocketClient(
      tag: '$tag:Ws',
      messageCodec: const StreamChatWsCodec(),
      optionsProvider: _buildOptions,
      wsProvider: wsProvider,
    );

    _recovery = ConnectionRecoveryHandler(
      client: _ws,
      tag: '$tag:Recovery',
      policies: [_reconnection],
    );
  }

  final ConnectRequest _request;
  final TokenManager _tokens;

  late final StreamWebSocketClient _ws;
  late final ConnectionRecoveryHandler _recovery;

  final StreamLogger _logger;

  // The user the open connection belongs to, and `null` while there is none.
  _Session? _session;

  final _reconnection = _PausableReconnectionPolicy();

  /// Every frame the server has sent, as it arrives.
  EventEmitter<WsEvent> get events => _ws.events;

  /// The state of the connection, reported on listen and again on every change.
  ConnectionStateEmitter get connectionState => _ws.connectionState;

  /// The state a connection attempt settles in, either [Connected] or [Disconnected].
  ///
  /// Completes immediately when none is being opened, so a caller that cannot go on without a
  /// connection can await it unconditionally — and has to handle [Disconnected] either way.
  Future<WebSocketConnectionState> get settled => connectionState.settled;

  /// The unique identifier for the open WebSocket connection.
  ///
  /// Null while no connection is open. Requests made over an open connection are sent with it.
  String? get connectionId => switch (connectionState.value) {
    Connected(:final healthCheck) => healthCheck.connectionId,
    _ => null,
  };

  /// Stops a dropped connection from being reopened, until [resumeReconnect].
  ///
  /// Leaves an open connection alone. Use while the app is in the background, where a reopened
  /// connection cannot be used.
  void pauseReconnect() => _reconnection.pause();

  /// Reopens dropped connections again, after [pauseReconnect].
  void resumeReconnect() => _reconnection.resume();

  /// Opens a connection for [user], completing with the health check that established it.
  ///
  /// Set [includeUserDetails] to send the user's full details, which creates or updates them
  /// server-side.
  ///
  /// Throws a [StateError] when a connection is already open or being opened, and a
  /// [StreamChatException] when the server refuses the connection.
  Future<HealthCheckEvent> connect(
    OwnUser user, {
    bool includeUserDetails = false,
  }) async {
    if (isDisposed) throw StateError('Cannot connect a disposed ConnectionManager');

    if (connectionState.value case Connecting() || Authenticating()) {
      throw StateError('A connection is already in progress for ${user.id}.');
    }

    if (connectionState.value case Connected()) {
      throw StateError('A connection is already available for ${user.id}.');
    }

    // The socket refuses to open one while another is still closing.
    if (connectionState.value case Disconnecting()) {
      await connectionState.waitFor<Disconnected>();
    }

    _session = _Session(user, includeUserDetails: includeUserDetails);
    resumeReconnect();

    return _open(user);
  }

  /// Closes the connection, which stays closed until [connect] is called again.
  Future<void> disconnect() {
    _session = null;
    return _ws.disconnect();
  }

  // Waits for the attempt to land or to close, and answers with the frame that landed it.
  Future<HealthCheckEvent> _open(OwnUser user) async {
    // Subscribed before connecting: the frame that establishes the connection is the first health
    // check, and the only one carrying the user the server signed in.
    final established = events.waitFor<HealthCheckEvent>();

    // `connect` reports `Connecting` before it suspends, so the closure waited on below cannot be
    // the one this attempt replaces.
    unawaited(_ws.connect());

    final settledState = await settled;
    if (settledState case Disconnected(:final source)) {
      // Otherwise it fails unobserved when the socket closes without a frame.
      established.ignore();
      _refuse(user, source);
    }

    // `Connected` is reported before the frame, so `established` is already on its way.
    return established;
  }

  // Raises why the server would not open a connection, the way a rejected request is raised.
  Never _refuse(OwnUser user, DisconnectionSource source) {
    _logger.w(() => 'connect ${user.id} failed: ${source.closeReason}', error: source.cause);

    Error.throwWithStackTrace(source.exception, source.stackTrace ?? StackTrace.current);
  }

  // The request for a single attempt. Nothing is sent over the socket to authenticate one, so this
  // is where a refused token is replaced.
  Future<WebSocketOptions> _buildOptions(
    StreamApiException? previousError,
  ) async {
    final session = _session;
    if (session == null) throw StateError('No user is connected.');

    // Drop the token the server refused, so the load below asks for another. A provider with no
    // other to give ends the session instead of presenting the same one forever.
    if (previousError case final refused? when refused.isTokenExpired) {
      _tokens.expireToken();

      if (_tokens.usesStaticProvider) {
        throw StreamAuthenticationException(
          message: 'The token was refused and the provider has no other to give',
          cause: refused,
        );
      }
    }

    final userToken = await _tokens.getToken();

    return _request.build(
      user: session.user,
      token: userToken,
      includeUserDetails: session.takeIncludeUserDetails(),
    );
  }

  @override
  Future<void> dispose() async {
    _session = null;
    await _recovery.dispose();
    await _ws.dispose();
    return super.dispose();
  }
}

// A connection opened for one user: who each request names, and whether their details still have
// to be sent.
class _Session {
  _Session(
    this.user, {
    required this._includeUserDetails,
  });

  final OwnUser user;

  bool _includeUserDetails;

  // Spends the answer: the attempt after this one names the user the server has by then.
  bool takeIncludeUserDetails() {
    final includeUserDetails = _includeUserDetails;
    _includeUserDetails = false;
    return includeUserDetails;
  }
}

// A policy that can be switched off, for while a reopened connection would go unused.
class _PausableReconnectionPolicy implements AutomaticReconnectionPolicy {
  var _paused = false;

  void pause() => _paused = true;
  void resume() => _paused = false;

  @override
  bool canBeReconnected() => !_paused;
}
