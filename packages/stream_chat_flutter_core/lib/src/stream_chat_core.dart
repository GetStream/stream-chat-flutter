import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

typedef EventHandler = void Function(Event event);

/// Widget used to provide information about the chat to the widget tree.
/// This Widget is used to react to life cycle changes and system updates.
/// When the app goes into the background, the websocket connection is kept alive
/// for two minutes before being terminated.
///
/// Conversely, when app is resumed or restarted, a new connection is initiated.
///
/// ```dart
/// class MyApp extends StatelessWidget {
///   final Client client;
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
  /// [StreamChatCore] is a stateful widget which reacts to system events and updates
  /// Stream's connection status accordingly.
  StreamChatCore({
    Key key,
    @required this.client,
    @required this.child,
    this.onBackgroundEventReceived,
    this.backgroundKeepAlive = const Duration(minutes: 1),
  })  : assert(client != null),
        assert(child != null),
        super(key: key);

  /// Instance of Stream Chat Client containing information about the current
  /// application.
  final Client client;

  /// Widget descendant.
  final Widget child;

  /// The amount of time that will pass before disconnecting the client in the background
  final Duration backgroundKeepAlive;

  /// Handler called whenever the [client] receives a new [Event] while the app
  /// is in background. Can be used to display various notifications depending
  /// upon the [Event.type]
  final EventHandler onBackgroundEventReceived;

  @override
  StreamChatCoreState createState() => StreamChatCoreState();

  /// Use this method to get the current [StreamChatCoreState] instance
  static StreamChatCoreState of(BuildContext context) {
    StreamChatCoreState streamChatState;

    streamChatState = context.findAncestorStateOfType<StreamChatCoreState>();

    if (streamChatState == null) {
      throw Exception(
          'You must have a StreamChat widget at the top of your widget tree');
    }

    return streamChatState;
  }
}

/// State class associated with [StreamChatCore].
class StreamChatCoreState extends State<StreamChatCore>
    with WidgetsBindingObserver {
  /// Initialized client used throughout the application.
  Client get client => widget.client;

  Timer _disconnectTimer;

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  /// The current user
  User get user => widget.client.state.user;

  /// The current user as a stream
  Stream<User> get userStream => widget.client.state.userStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  StreamSubscription _eventSubscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (client.state?.user != null) {
      if (state == AppLifecycleState.paused) {
        if (widget.onBackgroundEventReceived != null) {
          _eventSubscription =
              client.on().listen(widget.onBackgroundEventReceived);
          _disconnectTimer = Timer(
            widget.backgroundKeepAlive,
            client.disconnect,
          );
        } else {
          client.disconnect();
        }
      } else if (state == AppLifecycleState.resumed) {
        _eventSubscription?.cancel();
        if (_disconnectTimer?.isActive == true) {
          _disconnectTimer.cancel();
        } else {
          if (client.wsConnectionStatus == ConnectionStatus.disconnected) {
            client.connect();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _eventSubscription?.cancel();
    _disconnectTimer?.cancel();
    super.dispose();
  }
}
