import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';

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
/// Use [StreamChat.of] to get the current [StreamChatState] instance.
class StreamChat extends StatefulWidget {
  final Client client;
  final Widget child;
  final StreamChatThemeData streamChatThemeData;

  StreamChat({
    Key key,
    @required this.client,
    @required this.child,
    this.streamChatThemeData,
  }) : super(
          key: key,
        );

  @override
  StreamChatState createState() => StreamChatState();

  /// Use this method to get the current [StreamChatState] instance
  static StreamChatState of(BuildContext context) {
    StreamChatState streamChatState;

    streamChatState = context.findAncestorStateOfType<StreamChatState>();

    if (streamChatState == null) {
      throw Exception(
          'You must have a StreamChat widget at the top of your widget tree');
    }

    return streamChatState;
  }
}

/// The current state of the StreamChat widget
class StreamChatState extends State<StreamChat> with WidgetsBindingObserver {
  Client get client => widget.client;
  Timer _disconnectTimer;

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme(context, widget.streamChatThemeData);
    return StreamChatTheme(
      data: theme,
      child: Builder(
        builder: (context) {
          final materialTheme = Theme.of(context);
          final streamTheme = StreamChatTheme.of(context);
          return Theme(
            data: materialTheme.copyWith(
              primaryIconTheme: streamTheme.primaryIconTheme,
              accentColor: streamTheme.colorTheme.accentBlue,
              scaffoldBackgroundColor: streamTheme.colorTheme.white,
              buttonTheme: streamTheme.buttonTheme,
            ),
            child: widget.child,
          );
        },
      ),
    );
  }

  StreamChatThemeData _getTheme(
    BuildContext context,
    StreamChatThemeData themeData,
  ) {
    final defaultTheme = StreamChatThemeData.getDefaultTheme(Theme.of(context));
    return defaultTheme.merge(themeData) ?? themeData;
  }

  /// The current user
  User get user => widget.client.state.user;

  /// The current user as a stream
  Stream<User> get userStream => widget.client.state.userStream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    client.state?.totalUnreadCountStream?.listen((count) {
      if (count > 0) {
        FlutterAppBadger.updateBadgeCount(count);
      } else {
        FlutterAppBadger.removeBadge();
      }
    });
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
