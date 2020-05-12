import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
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
              accentColor: streamTheme.accentColor,
              scaffoldBackgroundColor: streamTheme.backgroundColor,
            ),
            child: WillPopScope(
              onWillPop: () async {
                if (_navigatorKey.currentState.canPop()) {
                  _navigatorKey.currentState.pop();
                  return false;
                } else {
                  return true;
                }
              },
              child: Navigator(
                initialRoute: '/',
                key: _navigatorKey,
                onGenerateRoute: (settings) {
                  return MaterialPageRoute(
                    settings: settings,
                    builder: (_) => widget.child,
                  );
                },
              ),
            ),
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
    final theme = defaultTheme.copyWith(
      primaryColor: themeData?.primaryColor,
      defaultChannelImage: themeData?.defaultChannelImage,
      primaryIconTheme: themeData?.primaryIconTheme,
      defaultUserImage: themeData?.defaultUserImage,
      backgroundColor: themeData?.backgroundColor,
      channelTheme: defaultTheme.channelTheme.copyWith(
        channelHeaderTheme:
            defaultTheme.channelTheme.channelHeaderTheme.copyWith(
          color: themeData?.channelTheme?.channelHeaderTheme?.color,
          lastMessageAt:
              themeData?.channelTheme?.channelHeaderTheme?.lastMessageAt,
          title: themeData?.channelTheme?.channelHeaderTheme?.title,
          avatarTheme: defaultTheme.channelPreviewTheme.avatarTheme.copyWith(
            constraints: themeData
                ?.channelTheme?.channelHeaderTheme?.avatarTheme?.constraints,
            borderRadius: themeData
                ?.channelTheme?.channelHeaderTheme?.avatarTheme?.borderRadius,
          ),
        ),
        inputBackground: themeData?.channelTheme?.inputBackground,
        messageInputButtonIconTheme:
            themeData?.channelTheme?.messageInputButtonIconTheme,
        inputGradient: themeData?.channelTheme?.inputGradient,
        messageInputButtonTheme:
            themeData?.channelTheme?.messageInputButtonTheme,
      ),
      ownMessageTheme: defaultTheme.ownMessageTheme.copyWith(
        replies: themeData?.ownMessageTheme?.replies,
        createdAt: themeData?.ownMessageTheme?.createdAt,
        messageText: themeData?.ownMessageTheme?.messageText,
        messageBackgroundColor:
            themeData?.ownMessageTheme?.messageBackgroundColor,
        messageAuthor: themeData?.ownMessageTheme?.messageAuthor,
        messageMention: themeData?.ownMessageTheme?.messageMention,
        avatarTheme: defaultTheme.ownMessageTheme.avatarTheme.copyWith(
          constraints: themeData?.ownMessageTheme?.avatarTheme?.constraints,
          borderRadius: themeData?.ownMessageTheme?.avatarTheme?.borderRadius,
        ),
      ),
      otherMessageTheme: defaultTheme.otherMessageTheme.copyWith(
        replies: themeData?.otherMessageTheme?.replies,
        createdAt: themeData?.otherMessageTheme?.createdAt,
        messageText: themeData?.otherMessageTheme?.messageText,
        messageBackgroundColor:
            themeData?.otherMessageTheme?.messageBackgroundColor,
        messageAuthor: themeData?.otherMessageTheme?.messageAuthor,
        messageMention: themeData?.otherMessageTheme?.messageMention,
        avatarTheme: defaultTheme.otherMessageTheme.avatarTheme.copyWith(
          constraints: themeData?.otherMessageTheme?.avatarTheme?.constraints,
          borderRadius: themeData?.otherMessageTheme?.avatarTheme?.borderRadius,
        ),
      ),
      accentColor: themeData?.accentColor,
      secondaryColor: themeData?.secondaryColor,
      channelPreviewTheme: defaultTheme.channelPreviewTheme.copyWith(
        avatarTheme: defaultTheme.channelPreviewTheme.avatarTheme.copyWith(
          constraints: themeData?.channelPreviewTheme?.avatarTheme?.constraints,
          borderRadius:
              themeData?.channelPreviewTheme?.avatarTheme?.borderRadius,
        ),
        title: themeData?.channelPreviewTheme?.title,
        lastMessageAt: themeData?.channelPreviewTheme?.lastMessageAt,
        subtitle: themeData?.channelPreviewTheme?.subtitle,
        unreadCounterColor: themeData?.channelPreviewTheme?.unreadCounterColor,
      ),
    );
    return theme;
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
    if (state == AppLifecycleState.paused) {
      if (client.showLocalNotification != null) {
        _newMessageSubscription = client
            .on(EventType.messageNew)
            .where((e) => e.user?.id != user.id)
            .where((e) => e.message.silent != true)
            .listen((event) async {
          var channel = client.state.channels[event.cid];

          if (channel == null) {
            channel = client.channel(
              event.type,
              id: event.cid.split(':')[1],
            );
            await channel.query();
          }

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
        if (client.wsConnectionStatus.value == ConnectionStatus.disconnected) {
          NotificationService.handleIosMessageQueue(client);
          client.connect();
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
