import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

  /// The amount of time that will pass before disconnecting the client in the background
  final Duration backgroundKeepAlive;

  /// Handler called whenever the [client] receives a new [Event] while the app
  /// is in background. Can be used to display various notifications depending
  /// upon the [Event.type]
  final EventHandler onBackgroundEventReceived;

  StreamChat({
    Key key,
    @required this.client,
    @required this.child,
    this.streamChatThemeData,
    this.onBackgroundEventReceived,
    this.backgroundKeepAlive = const Duration(minutes: 1),
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
class StreamChatState extends State<StreamChat> {
  Client get client => widget.client;

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme(context, widget.streamChatThemeData);
    return Portal(
      child: StreamChatTheme(
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
              ),
              child: StreamChatCore(
                client: client,
                child: widget.child,
                onBackgroundEventReceived: widget.onBackgroundEventReceived,
                backgroundKeepAlive: widget.backgroundKeepAlive,
              ),
            );
          },
        ),
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
    client.state?.totalUnreadCountStream?.listen((count) {
      if (count > 0) {
        FlutterAppBadger.updateBadgeCount(count);
      } else {
        FlutterAppBadger.removeBadge();
      }
    });
  }
}
