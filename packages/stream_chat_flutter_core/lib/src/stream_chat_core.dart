import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat/version.dart';
import 'package:stream_chat_flutter_core/src/typedef.dart';

/// Widget used to provide information about the chat to the widget tree.
/// This Widget is used to react to life cycle changes and system updates.
/// When the app goes into the background, the websocket connection is kept
/// alive for two minutes before being terminated.
///
/// Conversely, when app is resumed or restarted, a new connection is initiated.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final StreamChatClient client;
///
///   MyApp(this.client);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Container(
///         child: StreamChatCore(
///           client: client,
///           child: ChannelListPage(),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
class StreamChatCore extends StatefulWidget {
  /// Constructor used for creating a new instance of [StreamChatCore].
  ///
  /// [StreamChatCore] is a stateful widget which reacts to system events and
  /// updates Stream's connection status accordingly.
  const StreamChatCore({
    Key? key,
    required this.client,
    required this.child,
    this.onBackgroundEventReceived,
    this.backgroundKeepAlive = const Duration(minutes: 1),
    this.connectivityStream,
  }) : super(key: key);

  /// Instance of Stream Chat Client containing information about the current
  /// application.
  final StreamChatClient client;

  /// Widget descendant.
  final Widget child;

  /// The amount of time that will pass before disconnecting the client in
  /// the background
  final Duration backgroundKeepAlive;

  /// Handler called whenever the [client] receives a new [Event] while the app
  /// is in background. Can be used to display various notifications depending
  /// upon the [Event.type]
  final EventHandler? onBackgroundEventReceived;

  /// Stream of connectivity result
  /// Visible for testing
  @visibleForTesting
  final Stream<ConnectivityResult>? connectivityStream;

  @override
  StreamChatCoreState createState() => StreamChatCoreState();

  /// Use this method to get the current [StreamChatCoreState] instance
  static StreamChatCoreState of(BuildContext context) {
    StreamChatCoreState? streamChatState;

    streamChatState = context.findAncestorStateOfType<StreamChatCoreState>();

    assert(
      streamChatState != null,
      'You must have a StreamChat widget at the top of your widget tree',
    );

    return streamChatState!;
  }
}

/// State class associated with [StreamChatCore].
class StreamChatCoreState extends State<StreamChatCore>
    with WidgetsBindingObserver {
  /// Initialized client used throughout the application.
  StreamChatClient get client => widget.client;

  Timer? _disconnectTimer;

  @override
  Widget build(BuildContext context) {
    StreamChatClient.additionalHeaders = {
      'X-Stream-Client': '${StreamChatClient.defaultUserAgent}-core',
    };
    return widget.child;
  }

  // coverage:ignore-start

  /// The current user
  @Deprecated('Use `.currentUser` instead, Will be removed in future releases')
  User? get user => client.state.currentUser;

  /// The current user as a stream
  @Deprecated(
    'Use `.currentUserStream` instead, Will be removed in future releases',
  )
  Stream<User?> get userStream => client.state.currentUserStream;

  // coverage:ignore-end

  /// The current user
  User? get currentUser => client.state.currentUser;

  /// The current user as a stream
  Stream<User?> get currentUserStream => client.state.currentUserStream;

  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  var _isInForeground = true;
  var _isConnectionAvailable = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _subscribeToConnectivityChange(widget.connectivityStream);
  }

  void _subscribeToConnectivityChange([
    Stream<ConnectivityResult>? connectivityStream,
  ]) {
    if (_connectivitySubscription == null) {
      connectivityStream ??= Connectivity().onConnectivityChanged;
      _connectivitySubscription =
          connectivityStream.distinct().listen((result) {
        _isConnectionAvailable = result != ConnectivityResult.none;
        if (!_isInForeground) return;
        if (_isConnectionAvailable) {
          if (client.wsConnectionStatus == ConnectionStatus.disconnected &&
              currentUser != null) {
            client.openConnection();
          }
        } else {
          if (client.wsConnectionStatus == ConnectionStatus.connected) {
            client.closeConnection();
          }
        }
      });
    }
  }

  void _unsubscribeFromConnectivityChange() {
    if (_connectivitySubscription != null) {
      _connectivitySubscription?.cancel();
      _connectivitySubscription = null;
    }
  }

  @override
  void didUpdateWidget(StreamChatCore oldWidget) {
    super.didUpdateWidget(oldWidget);
    final connectivityStream = widget.connectivityStream;
    if (connectivityStream != oldWidget.connectivityStream) {
      _unsubscribeFromConnectivityChange();
      _subscribeToConnectivityChange(connectivityStream);
    }
  }

  StreamSubscription? _eventSubscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _isInForeground = [
      AppLifecycleState.resumed,
      AppLifecycleState.inactive,
    ].contains(state);
    if (currentUser != null) {
      if (_isInForeground) {
        _onForeground();
      } else {
        _onBackground();
      }
    }
  }

  void _onForeground() {
    if (_disconnectTimer?.isActive == true) {
      _eventSubscription?.cancel();
      _disconnectTimer?.cancel();
    } else if (client.wsConnectionStatus == ConnectionStatus.disconnected &&
        _isConnectionAvailable) {
      client.openConnection();
    }
  }

  void _onBackground() {
    if (widget.onBackgroundEventReceived == null) {
      if (client.wsConnectionStatus != ConnectionStatus.disconnected) {
        client.closeConnection();
      }
      return;
    }

    _eventSubscription = client.on().listen(widget.onBackgroundEventReceived);

    void onTimerComplete() {
      _eventSubscription?.cancel();
      client.closeConnection();
    }

    _disconnectTimer = Timer(widget.backgroundKeepAlive, onTimerComplete);
    return;
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    _unsubscribeFromConnectivityChange();
    _eventSubscription?.cancel();
    _disconnectTimer?.cancel();
    super.dispose();
  }
}
