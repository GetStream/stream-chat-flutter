import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/core/error/error.dart';
import 'package:stream_chat/src/core/http/system_environment_manager.dart';
import 'package:stream_chat/src/core/http/token_manager.dart';
import 'package:stream_chat/src/core/models/event.dart';
import 'package:stream_chat/src/core/models/own_user.dart';
import 'package:stream_chat/src/core/util/extension.dart';
import 'package:stream_chat/src/event_type.dart';
import 'package:stream_chat/src/ws/connect_user_details.dart';
import 'package:stream_chat/src/ws/connection_status.dart';
import 'package:stream_chat/src/ws/timer_helper.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

/// Typedef which exposes an [Event] as the only parameter.
typedef EventHandler = void Function(Event);

/// Typedef used for connecting to a websocket. Method returns a
/// [WebSocketChannel] and accepts a connection [url] and an optional
/// [Iterable] of `protocols`.
typedef WebSocketChannelProvider = WebSocketChannel Function(
  Uri uri, {
  Iterable<String>? protocols,
});

/// A WebSocket connection that reconnects upon failure.
class WebSocket with TimerHelper {
  /// Creates a new websocket
  /// To connect the WS call [connect]
  WebSocket({
    required this.apiKey,
    required this.baseUrl,
    required this.tokenManager,
    this.systemEnvironmentManager,
    this.handler,
    Logger? logger,
    this.webSocketChannelProvider,
    this.reconnectionMonitorInterval = 10,
    this.healthCheckInterval = 20,
    this.reconnectionMonitorTimeout = 40,
    this.maxReconnectAttempts = 6,
    this.queryParameters = const {},
  }) : _logger = logger;

  ///
  final String apiKey;

  /// Additional query parameters to be added to the websocket url
  final Map<String, Object?> queryParameters;

  /// WS base url
  final String baseUrl;

  /// Manager responsible for handling authentication tokens.
  ///
  /// Used to retrieve tokens for websocket connections and refreshing expired
  /// tokens.
  final TokenManager tokenManager;

  /// Manager that provides system environment information like SDK version and
  /// platform details.
  ///
  /// Used to send client identification in websocket connection requests.
  final SystemEnvironmentManager? systemEnvironmentManager;

  /// Functions that will be called every time a new event is received from the
  /// connection
  final EventHandler? handler;

  final Logger? _logger;

  /// Connection function
  /// Used only for testing purpose
  @visibleForTesting
  final WebSocketChannelProvider? webSocketChannelProvider;

  /// Interval of the reconnection monitor timer
  /// This checks that it received a new event in the last
  /// [reconnectionMonitorTimeout] seconds, otherwise it considers the
  /// connection unhealthy and reconnects the WS
  final int reconnectionMonitorInterval;

  /// Interval of the health event sending timer
  /// This sends a health event every [healthCheckInterval] seconds in order to
  /// make the server aware that the client is still listening
  final int healthCheckInterval;

  /// The timeout that uses the reconnection monitor timer to consider the
  /// connection unhealthy
  final int reconnectionMonitorTimeout;

  /// Maximum number of reconnection attempts before giving up.
  ///
  /// Default is 6 attempts. ~30 seconds of reconnection attempts
  final int maxReconnectAttempts;

  OwnUser? _user;
  String? _connectionId;
  DateTime? _lastEventAt;
  WebSocketChannel? _webSocketChannel;
  StreamSubscription? _webSocketChannelSubscription;

  ///
  Completer<Event>? connectionCompleter;

  ///
  String? get connectionId => _connectionId;

  final _connectionStatusController = BehaviorSubject.seeded(
    ConnectionStatus.disconnected,
  );

  /// The current connection status value
  ConnectionStatus get connectionStatus => _connectionStatusController.value;
  set _connectionStatus(ConnectionStatus status) {
    _connectionStatusController.safeAdd(status);
  }

  /// This notifies of connection status changes
  Stream<ConnectionStatus> get connectionStatusStream {
    return _connectionStatusController.stream.distinct();
  }

  void _initWebSocketChannel(Uri uri) {
    _logger?.info('Initiating connection with $baseUrl');
    if (_webSocketChannel != null) {
      _closeWebSocketChannel();
    }
    _webSocketChannel =
        webSocketChannelProvider?.call(uri) ?? WebSocketChannel.connect(uri);
    _subscribeToWebSocketChannel();
  }

  void _closeWebSocketChannel() {
    _logger?.info('Closing connection with $baseUrl');
    if (_webSocketChannel != null) {
      _unsubscribeFromWebSocketChannel();
      _webSocketChannel?.sink.close(status.normalClosure, 'Closing connection');
      _webSocketChannel = null;
    }
  }

  void _subscribeToWebSocketChannel() {
    _logger?.info('Started listening to $baseUrl');
    if (_webSocketChannelSubscription != null) {
      _unsubscribeFromWebSocketChannel();
    }
    _webSocketChannelSubscription = _webSocketChannel?.stream.listen(
      _onDataReceived,
      onError: _onConnectionError,
      onDone: _onConnectionClosed,
    );
  }

  void _unsubscribeFromWebSocketChannel() {
    _logger?.info('Stopped listening to $baseUrl');
    if (_webSocketChannelSubscription != null) {
      _webSocketChannelSubscription?.cancel();
      _webSocketChannelSubscription = null;
    }
  }

  Future<Uri> _buildUri({
    bool refreshToken = false,
    bool includeUserDetails = true,
  }) async {
    final userDetails = ConnectUserDetails.fromOwnUser(_user!);
    final token = await tokenManager.loadToken(refresh: refreshToken);
    final params = {
      'user_id': userDetails.id,
      'user_details': includeUserDetails ? userDetails : {'id': userDetails.id},
      'user_token': token.rawValue,
      'server_determines_connection_id': true,
    };

    final userAgent = systemEnvironmentManager?.userAgent;
    final qs = {
      'json': jsonEncode(params),
      'api_key': apiKey,
      'authorization': token.rawValue,
      'stream-auth-type': token.authType.name,
      if (userAgent != null) 'X-Stream-Client': jsonEncode(userAgent),
      ...queryParameters,
    };

    final scheme = switch (baseUrl) {
      final url when url.startsWith(RegExp('^(ws?|http?)://')) => 'ws',
      final url when url.startsWith(RegExp('^(wss?|https?)://')) => 'wss',
      _ => throw const FormatException('Invalid url format'),
    };

    final address = baseUrl.replaceAll(RegExp(r'(^\w+:|^)\/\/'), '');
    final (:host, :port) = switch (address.split(':')) {
      [final host] => (host: host, port: null),
      [final host, final port] => (host: host, port: int.tryParse(port)),
      _ => throw const FormatException('Invalid address format'),
    };

    _logger?.info('[buildUri] #ws; scheme: $scheme, host: $host, port: $port');

    return Uri(
      scheme: scheme,
      host: host,
      port: port,
      pathSegments: ['connect'],
      queryParameters: qs,
    );
  }

  bool _connectRequestInProgress = false;

  /// Connect the WS using the parameters passed in the constructor
  Future<Event> connect(
    OwnUser user, {
    bool includeUserDetails = false,
  }) {
    if (_connectRequestInProgress) {
      throw const StreamWebSocketError('''
        You've called connect twice,
        can only attempt 1 connection at the time,
        ''');
    }
    _connectRequestInProgress = true;
    _manuallyClosed = false;

    _user = user;
    _connectionStatus = ConnectionStatus.connecting;

    connectionCompleter = Completer<Event>();

    _setupConnection(includeUserDetails: includeUserDetails);

    return connectionCompleter!.future;
  }

  Future<void> _setupConnection({
    required bool includeUserDetails,
  }) async {
    try {
      final uri = await _buildUri(
        includeUserDetails: includeUserDetails,
      );
      _logger?.info('[connect] #ws; uri: $uri');
      _initWebSocketChannel(uri);
    } catch (e, stk) {
      _onConnectionError(e, stk);
    }
  }

  int _reconnectAttempt = 0;
  bool _reconnectRequestInProgress = false;

  void _reconnect({bool refreshToken = false}) async {
    _logger?.info('Retrying connection : $_reconnectAttempt');
    if (_reconnectRequestInProgress) return;

    if (_reconnectAttempt >= maxReconnectAttempts) {
      _logger?.severe('Max reconnect attempts reached: $maxReconnectAttempts');
      return disconnect();
    }

    _reconnectRequestInProgress = true;

    _stopMonitoringEvents();
    // Closing any previously opened web-socket
    _closeWebSocketChannel();

    _reconnectAttempt += 1;
    _connectionStatus = ConnectionStatus.connecting;

    final delay = _getReconnectInterval(_reconnectAttempt);
    setTimer(
      Duration(milliseconds: delay),
      () async {
        // If the user is null, it means either the connection was never
        // established or it was disconnected manually.
        //
        // In either case, we should not attempt to reconnect.
        if (_user == null) return;

        final uri = await _buildUri(
          refreshToken: refreshToken,
          includeUserDetails: false,
        );
        _logger?.info('[reconnect] #ws; uri: $uri');
        try {
          _initWebSocketChannel(uri);
        } catch (e, stk) {
          _onConnectionError(e, stk);
        }
      },
    );
  }

  // returns the reconnect interval based on `reconnectAttempt` in milliseconds
  int _getReconnectInterval(int reconnectAttempt) {
    // try to reconnect in 0.25-25 seconds
    // (random to spread out the load from failures)
    final max = math.min(500 + reconnectAttempt * 2000, 25000);
    final min = math.min(
      math.max(250, (reconnectAttempt - 1) * 2000),
      25000,
    );
    return (math.Random().nextDouble() * (max - min) + min).floor();
  }

  void _startMonitoringEvents() {
    _logger?.info('Starting monitoring events');
    // cancel all previous timers
    cancelAllTimers();

    _startHealthCheck();
    _startReconnectionMonitor();
  }

  void _stopMonitoringEvents() {
    _logger?.info('Stopped monitoring events');
    // reset lastEvent
    _lastEventAt = null;

    cancelAllTimers();
  }

  void _handleConnectedEvent(Event event) {
    // updating connectionId and status
    _connectionId = event.connectionId;
    _connectionStatus = ConnectionStatus.connected;

    _logger?.info('Connection successful: $_connectionId');

    // notify user that connection is completed
    final completer = connectionCompleter;
    if (completer != null && !completer.isCompleted) {
      completer.complete(event);
    }

    // start monitoring health-check events
    _startMonitoringEvents();
  }

  void _handleHealthCheckEvent(Event event) {
    _logger?.info('HealthCheck received : ${event.connectionId}');

    _connectionId = event.connectionId;
    _connectionStatus = ConnectionStatus.connected;
  }

  void _handleStreamError(Map<String, Object?> errorResponse) {
    // resetting connect, reconnect request flag
    _resetRequestFlags();

    final error = StreamWebSocketError.fromStreamError(errorResponse);
    final isTokenExpired = error.errorCode == ChatErrorCode.tokenExpired;
    if (isTokenExpired && !tokenManager.isStatic) {
      _logger?.warning('Connection failed, token expired');
      return _reconnect(refreshToken: true);
    }

    _logger?.severe('Connection failed', error);

    final completer = connectionCompleter;
    // complete with error if not yet completed
    if (completer != null && !completer.isCompleted) {
      // complete the connection with error
      completer.completeError(error);
      // disconnect the web-socket connection
      return disconnect();
    }

    return _reconnect();
  }

  void _onDataReceived(dynamic data) {
    final jsonData = json.decode(data) as Map<String, Object?>;
    final error = jsonData['error'] as Map<String, Object?>?;
    if (error != null) return _handleStreamError(error);

    // resetting connect, reconnect request flag
    _resetRequestFlags(resetAttempts: true);

    Event? event;
    try {
      event = Event.fromJson(jsonData);
    } catch (e, stk) {
      _logger?.warning('Error parsing an event: $e');
      _logger?.warning('Stack trace: $stk');
    }

    if (event == null) return;

    _lastEventAt = DateTime.now();
    _logger?.info('Event received: ${event.type}');

    if (event.type == EventType.healthCheck) {
      if (event.me != null) {
        _handleConnectedEvent(event);
      } else {
        _handleHealthCheckEvent(event);
      }
    }

    return handler?.call(event);
  }

  void _onConnectionError(error, [stacktrace]) {
    _logger?.warning(
        '[onConnectionError] #ws; error occurred', error, stacktrace);

    StreamWebSocketError wsError;
    if (error is WebSocketChannelException) {
      wsError = StreamWebSocketError.fromWebSocketChannelError(error);
    } else {
      wsError = StreamWebSocketError(error.toString());
    }

    final completer = connectionCompleter;
    // complete with error if not yet completed
    if (completer != null && !completer.isCompleted) {
      // complete the connection with error
      completer.completeError(wsError);
    }

    // resetting connect, reconnect request flag
    _resetRequestFlags();

    _reconnect();
  }

  bool _manuallyClosed = false;

  void _onConnectionClosed() {
    _logger?.warning('Connection closed : $connectionId');

    // resetting connect, reconnect request flag
    _resetRequestFlags();

    // resetting connection
    _connectionId = null;

    // check if we manually closed the connection
    if (_manuallyClosed) return;
    _reconnect();
  }

  bool get _needsToReconnect {
    final lastEventAt = _lastEventAt;
    // means not yet connected or disconnected
    if (lastEventAt == null) return false;

    // means we missed a health check
    final now = DateTime.now();
    return now.difference(lastEventAt).inSeconds > reconnectionMonitorTimeout;
  }

  void _resetRequestFlags({bool resetAttempts = false}) {
    _connectRequestInProgress = false;
    _reconnectRequestInProgress = false;
    if (resetAttempts) _reconnectAttempt = 0;
  }

  void _startReconnectionMonitor() {
    _logger?.info('Starting reconnection monitor');
    setPeriodicTimer(
      Duration(seconds: reconnectionMonitorInterval),
      (_) {
        final needsToReconnect = _needsToReconnect;
        _logger?.info('Needs to reconnect : $needsToReconnect');
        if (needsToReconnect) _reconnect();
      },
      immediate: true,
    );
  }

  void _startHealthCheck() {
    _logger?.info('Starting health check monitor');
    setPeriodicTimer(
      Duration(seconds: healthCheckInterval),
      (_) {
        _logger?.info('Sending Event: ${EventType.healthCheck}');
        final event = Event(
          type: EventType.healthCheck,
          connectionId: connectionId,
        );
        _webSocketChannel?.sink.add(jsonEncode(event));
      },
      immediate: true,
    );
  }

  /// Disconnects the WS and releases eventual resources
  void disconnect() {
    if (connectionStatus == ConnectionStatus.disconnected) return;
    _connectionStatus = ConnectionStatus.disconnected;

    _logger?.info('Disconnecting web-socket connection');

    _manuallyClosed = true;
    _resetRequestFlags(resetAttempts: true);
    _stopMonitoringEvents();

    // resetting user
    _user = null;
    connectionCompleter = null;

    _closeWebSocketChannel();
  }

  /// Disposes the web-socket connection and releases resources
  Future<void> dispose() async {
    _logger?.info('Disposing web-socket connection');

    _stopMonitoringEvents();
    _unsubscribeFromWebSocketChannel();
    _closeWebSocketChannel();
    _connectionStatusController.close();
  }
}
