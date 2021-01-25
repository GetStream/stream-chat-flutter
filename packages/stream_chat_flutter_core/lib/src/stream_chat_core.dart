import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

/// Widget used to provide information about the chat to the widget tree
///
/// class MyApp extends StatelessWidget {
///   final Client client;
///
///   MyApp(this.client);
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Container(
///         child: StreamChat(
///           client: client,
///           child: ChannelListPage(),
///         ),
///       ),
///     );
///   }
/// }
///
/// Use [StreamChatCore.of] to get the current [StreamChatCoreState] instance.
class StreamChatCore extends StatefulWidget {
  final Client client;
  final Widget child;

  StreamChatCore({
    Key key,
    @required this.client,
    @required this.child,
  }) : super(
          key: key,
        );

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

/// The current state of the StreamChat widget
class StreamChatCoreState extends State<StreamChatCore>
    with WidgetsBindingObserver {
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
    super.dispose();
  }
}
