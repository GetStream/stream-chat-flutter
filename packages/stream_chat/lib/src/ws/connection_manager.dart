import 'dart:async';

import 'package:stream_core/stream_core.dart';

import '../core/models/own_user.dart';
import 'connect_request.dart';
import 'connection_status.dart';
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
    required this._tokenManager,
    WebSocketProvider? wsProvider,
    String tag = 'SCh:Connection',
  }) : _logger = StreamLogger(tag) {
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
  final TokenManager _tokenManager;

  late final StreamWebSocketClient _ws;
  late final ConnectionRecoveryHandler _recovery;

  final StreamLogger _logger;

  // The user the open connection belongs to, and `null` while there is none.
  _Session? _session;

  final _reconnection = _PausableReconnectionPolicy();

  // The attempt everyone opening a connection waits on, while one is under way.
  final _opening = InFlightCache<String, HealthCheckEvent>();

  /// Every frame the server has sent, as it arrives.
  EventEmitter<WsEvent> get events => _ws.events;

  /// The state of the connection, reported on listen and again on every change.
  ConnectionStateEmitter get connectionState => _ws.connectionState;

  /// The status the connection presents as.
  ConnectionStatus get status => _statusOf(connectionState.value);

  /// [status] on listen, and again on each change.
  ///
  /// Reports once per change in status, so the steps a connection passes through on its way to
  /// being open do not each report one.
  Stream<ConnectionStatus> get statusStream => connectionState.map(_statusOf).distinct();

  ConnectionStatus _statusOf(WebSocketConnectionState state) {
    return .fromState(state, isRecovering: _recovery.isRecovering);
  }

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
  /// Completes with the attempt already under way when there is one for [user].
  ///
  /// Throws a [StateError] when a connection is already open, or one is being opened for another
  /// user, and a [StreamChatException] when the server refuses the connection.
  Future<HealthCheckEvent> connect(
    OwnUser user, {
    bool includeUserDetails = false,
  }) async {
    if (isDisposed) throw StateError('Cannot connect a disposed ConnectionManager');

    // Reopening is asked for on events that can land mid-attempt, whose attempt is the connection
    // the caller was after.
    if (connectionState.value case Connecting() || Authenticating()) {
      if (_session case final open? when open.user.id == user.id) return _connect(user);

      throw StateError(
        'Cannot connect ${user.id}: a connection is already being opened for '
        '${_session?.user.id ?? 'another user'}. Disconnect before connecting again.',
      );
    }

    // Answered with the frame that opened the connection, the only one naming the user the server
    // signed in.
    if (connectionState.value case Connected()) {
      if (_session case final open? when open.user.id == user.id) {
        if (open.established case final established?) return established;
      }

      throw StateError(
        'Cannot connect ${user.id}: a connection is already open for '
        '${_session?.user.id ?? 'another user'}. Disconnect before connecting again.',
      );
    }

    // The socket refuses to open one while another is still closing.
    if (connectionState.value case Disconnecting()) {
      await connectionState.waitFor<Disconnected>();

      // Asked for again rather than opened on what was true before the wait.
      return connect(user, includeUserDetails: includeUserDetails);
    }

    _session = _Session(user, includeUserDetails: includeUserDetails);
    resumeReconnect();

    return _connect(user);
  }

  /// Closes the connection, which stays closed until [connect] is called again.
  Future<void> disconnect() {
    _session = null;
    return _ws.disconnect();
  }

  // Waits for the attempt to land or to close, and answers with the frame that landed it.
  //
  // Everyone waiting on one attempt shares it, including whoever did not start it: a second run
  // would wait on the same frame again and report the same refusal twice.
  Future<HealthCheckEvent> _connect(OwnUser user) => _opening.run(
    user.id,
    () async {
      final session = _session;

      // Subscribed before connecting: the frame that establishes the connection is the first health
      // check, and the only one carrying the user the server signed in.
      final established = events.waitFor<HealthCheckEvent>();

      // Not awaited: the state has moved on by the time this returns, so the closure waited on
      // below cannot be the one this attempt replaces.
      unawaited(_ws.connect());

      final settledState = await settled;
      if (settledState case Disconnected(:final source)) {
        // Otherwise it fails unobserved when the socket closes without a frame.
        established.ignore();
        _refuse(user, source);
      }

      // Already on its way by the time the attempt settles. Kept for whoever asks for the
      // connection it opened.
      final event = await established;
      session?.establishedWith(event);

      return event;
    },
  );

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
      _tokenManager.expireToken();

      if (_tokenManager.usesStaticProvider) {
        throw StreamAuthenticationException(
          message: 'The token was refused and the provider has no other to give',
          cause: refused,
        );
      }
    }

    final userToken = await _tokenManager.getToken();

    return _request.build(
      user: session.user,
      token: userToken,
      includeUserDetails: session.includeUserDetails,
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

  // The frame that opened this connection, and `null` until one does.
  HealthCheckEvent? get established => _established;
  HealthCheckEvent? _established;

  // Whether an attempt names the user in full, which creates or updates them server-side.
  bool get includeUserDetails => _includeUserDetails;
  bool _includeUserDetails;

  // Remembers the frame the connection was opened with, and answers with it.
  HealthCheckEvent establishedWith(HealthCheckEvent event) {
    // Spent here rather than as an attempt is built, which leaves one that never landed paying.
    _includeUserDetails = false;
    return _established = event;
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
