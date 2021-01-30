import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

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
  /// Instance of Stream Chat Client containing information about the current
  /// application.
  final Client client;

  /// Widget descendant.
  final Widget child;

  /// Constructor used for creating a new instance of [StreamChatCore].
  ///
  /// [StreamChatCore] is a stateful widget which reacts to system events and updates
  /// Stream's connection status accordingly.
  StreamChatCore({
    Key key,
    @required this.client,
    @required this.child,
  }) : super(key: key);

  /// Instance of Stream Chat Client containing information about the current
  /// application.
  final Client client;

  /// Widget descendant.
  final Widget child;

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

  StreamSubscription _newMessageSubscription;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (client.state?.user != null) {
      if (state == AppLifecycleState.paused) {
        if (client.showLocalNotification != null) {
          _newMessageSubscription = client
              .on(EventType.messageNew)
              .where((e) => e.user?.id != user.id)
              .where((e) => e.message.silent != true)
              .where((e) => e.message.shadowed != true)
              .listen((event) async {
            final channel = client.channel(
              event.channelType,
              id: event.channelId,
            );

            client.showLocalNotification(
              event.message,
              ChannelModel(
                id: channel.id,
                createdAt: channel.createdAt,
                extraData: channel.extraData,
                type: channel.type,
                memberCount: channel.memberCount,
                frozen: channel.frozen,
                cid: channel.cid,
                deletedAt: channel.deletedAt,
                config: channel.config,
                createdBy: channel.createdBy,
                updatedAt: channel.updatedAt,
                lastMessageAt: channel.lastMessageAt,
              ),
            );
          });
          _disconnectTimer = Timer(client.backgroundKeepAlive, () {
            client.disconnect();
          });
        } else {
          client.disconnect();
        }
      } else if (state == AppLifecycleState.resumed) {
        _newMessageSubscription?.cancel();
        if (_disconnectTimer?.isActive == true) {
          _disconnectTimer.cancel();
        } else {
          if (client.wsConnectionStatus.value ==
              ConnectionStatus.disconnected) {
            NotificationService.handleIosMessageQueue(client);
            client.connect();
          }
        }
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disconnectTimer?.cancel();
    super.dispose();
  }
}
