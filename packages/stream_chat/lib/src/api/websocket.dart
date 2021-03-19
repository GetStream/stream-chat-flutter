import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stream_chat/src/api/connection_status.dart';
import 'package:stream_chat/src/models/event.dart';
import 'package:stream_chat/src/models/user.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Typedef which exposes an [Event] as the only parameter.
typedef EventHandler = void Function(Event);

/// Typedef used for connecting to a websocket. Method returns a
/// [WebSocketChannel] and accepts a connection [url] and an optional
/// [Iterable] of `protocols`.
typedef ConnectWebSocket = WebSocketChannel Function(String url,
    {Iterable<String> protocols});

// TODO: parse error even
// TODO: if parsing an error into an event fails we should not hide the
// TODO: original error
/// A WebSocket connection that reconnects upon failure.
class WebSocket {
  /// Creates a new websocket
  /// To connect the WS call [connect]
  WebSocket({
    @required this.baseUrl,
    this.user,
    this.connectParams,
    this.connectPayload,
    this.handler,
    this.logger,
    this.connectFunc,
    this.reconnectionMonitorInterval = 1,
    this.healthCheckInterval = 20,
    this.reconnectionMonitorTimeout = 40,
  }) {
    final qs = Map<String, String>.from(connectParams);

    final data = Map<String, dynamic>.from(connectPayload);

    data['user_details'] = user.toJson();
    qs['json'] = json.encode(data);

    if (baseUrl.startsWith('https')) {
      _path = baseUrl.replaceFirst('https://', '');
      _path = Uri.https(_path, 'connect', qs)
          .toString()
          .replaceFirst('https', 'wss');
    } else if (baseUrl.startsWith('http')) {
      _path = baseUrl.replaceFirst('http://', '');
      _path =
          Uri.http(_path, 'connect', qs).toString().replaceFirst('http', 'ws');
    } else {
      _path = Uri.https(baseUrl, 'connect', qs)
          .toString()
          .replaceFirst('https', 'wss');
    }
  }

  /// WS base url
  final String baseUrl;

  /// User performing the WS connection
  final User user;

  /// Querystring connection parameters
  final Map<String, String> connectParams;

  /// WS connection payload
  final Map<String, dynamic> connectPayload;

  /// Functions that will be called every time a new event is received from the
  /// connection
  final EventHandler handler;

  /// A WS specific logger instance
  final Logger logger;

  /// Connection function
  /// Used only for testing purpose
  @visibleForTesting
  final ConnectWebSocket connectFunc;

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

  final _connectionStatusController =
      BehaviorSubject.seeded(ConnectionStatus.disconnected);

  set _connectionStatus(ConnectionStatus status) =>
      _connectionStatusController.add(status);

  /// The current connection status value
  ConnectionStatus get connectionStatus => _connectionStatusController.value;

  /// This notifies of connection status changes
  Stream<ConnectionStatus> get connectionStatusStream =>
      _connectionStatusController.stream;

  String _path;
  int _retryAttempt = 1;
  WebSocketChannel _channel;
  Timer _healthCheck, _reconnectionMonitor;
  DateTime _lastEventAt;
  bool _manuallyDisconnected = false;
  bool _connecting = false;
  bool _reconnecting = false;

  Event _decodeEvent(String source) => Event.fromJson(json.decode(source));

  Completer<Event> _connectionCompleter = Completer<Event>();

  /// Connect the WS using the parameters passed in the constructor
  Future<Event> connect() {
    _manuallyDisconnected = false;

    if (_connecting) {
      logger.severe('already connecting');
      return null;
    }

    _connecting = true;
    _connectionStatus = ConnectionStatus.connecting;

    logger.info('connecting to $_path');

    _channel =
        connectFunc?.call(_path) ?? WebSocketChannel.connect(Uri.parse(_path));
    _channel.stream.listen(
      (data) {
        final jsonData = json.decode(data);
        if (jsonData['error'] != null) {
          return _onConnectionError(jsonData['error']);
        }
        _onData(data);
      },
      onError: (error, stacktrace) {
        _onConnectionError(error, stacktrace);
      },
      onDone: () {
        _onDone();
      },
    );
    return _connectionCompleter.future;
  }

  void _onDone() {
    _connecting = false;
    if (_manuallyDisconnected) {
      return;
    }

    logger.info('connection closed | closeCode: ${_channel.closeCode} | '
        'closedReason: ${_channel.closeReason}');

    if (!_reconnecting) {
      _reconnect();
    }
  }

  void _onData(data) {
    if (_manuallyDisconnected) {
      return;
    }

    final event = _decodeEvent(data);
    logger.info('received new event: $data');

    if (_lastEventAt == null) {
      logger.info('connection estabilished');
      _connecting = false;
      _reconnecting = false;
      _lastEventAt = DateTime.now();

      _connectionStatus = ConnectionStatus.connected;
      _retryAttempt = 1;

      if (!_connectionCompleter.isCompleted) {
        _connectionCompleter.complete(event);
      }

      _startReconnectionMonitor();
      _startHealthCheck();
    }

    handler(event);
    _lastEventAt = DateTime.now();
  }

  Future<void> _onConnectionError(error, [stacktrace]) async {
    logger..severe('error connecting')..severe(error);
    if (stacktrace != null) {
      logger.severe(stacktrace);
    }
    _connecting = false;

    if (!_reconnecting) {
      _connectionStatus = ConnectionStatus.disconnected;
    }

    if (!_connectionCompleter.isCompleted) {
      _cancelTimers();
      _connectionCompleter.completeError(error, stacktrace);
    } else if (!_reconnecting) {
      return _reconnect();
    }
  }

  void _reconnectionTimer(_) {
    final now = DateTime.now();
    if (_lastEventAt != null &&
        now.difference(_lastEventAt).inSeconds > reconnectionMonitorTimeout) {
      _channel.sink.close();
    }
  }

  void _startReconnectionMonitor() {
    _reconnectionMonitor = Timer.periodic(
      Duration(seconds: reconnectionMonitorInterval),
      _reconnectionTimer,
    );

    _reconnectionTimer(_reconnectionMonitor);
  }

  void _reconnectTimer() async {
    if (!_reconnecting) {
      return;
    }
    if (_connecting) {
      logger.info('already connecting');
      return;
    }

    logger.info('reconnecting..');

    _cancelTimers();

    try {
      await connect();
    } catch (e) {
      logger.log(Level.SEVERE, e.toString());
    }
    await Future.delayed(
      Duration(seconds: min(_retryAttempt * 5, 25)),
      () {
        _reconnectTimer();
        _retryAttempt++;
      },
    );
  }

  Future<void> _reconnect() async {
    logger.info('reconnect');
    if (!_reconnecting) {
      _reconnecting = true;
      _connectionStatus = ConnectionStatus.connecting;
    }

    _reconnectTimer();
  }

  void _cancelTimers() {
    _lastEventAt = null;
    if (_healthCheck != null) {
      _healthCheck.cancel();
    }
    if (_reconnectionMonitor != null) {
      _reconnectionMonitor.cancel();
    }
  }

  void _healthCheckTimer(_) {
    logger.info('sending health.check');
    _channel.sink.add("{'type': 'health.check'}");
  }

  void _startHealthCheck() {
    logger.info('start health check monitor');

    _healthCheck = Timer.periodic(
      Duration(seconds: healthCheckInterval),
      _healthCheckTimer,
    );

    _healthCheckTimer(_healthCheck);
  }

  /// Disconnects the WS and releases eventual resources
  Future<void> disconnect() async {
    _connecting = false;
    if (!_connectionCompleter.isCompleted) {
      _connectionCompleter.complete();
    }
    if (_manuallyDisconnected) {
      return;
    }
    logger.info('disconnecting');
    _connectionCompleter = Completer();
    _cancelTimers();
    _reconnecting = false;
    _manuallyDisconnected = true;
    _connectionStatus = ConnectionStatus.disconnected;
    await _connectionStatusController.close();
    return _channel.sink.close();
  }
}
