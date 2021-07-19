import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/stream_chat_theme.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Widget used to provide information about the chat to the widget tree
///
/// class MyApp extends StatelessWidget {
///   final StreamChatClient client;
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
  /// Constructor for creating a [StreamChat] widget
  const StreamChat({
    Key? key,
    required this.client,
    required this.child,
    this.streamChatThemeData,
    this.onBackgroundEventReceived,
    this.backgroundKeepAlive = const Duration(minutes: 1),
    this.connectivityStream,
  }) : super(key: key);

  /// Client to do chat ops with
  final StreamChatClient client;

  /// Child which inherits details
  final Widget? child;

  /// Theme to pass on
  final StreamChatThemeData? streamChatThemeData;

  /// The amount of time that will pass before disconnecting the client
  /// in the background
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
  StreamChatState createState() => StreamChatState();

  /// Use this method to get the current [StreamChatState] instance
  static StreamChatState of(BuildContext context) {
    StreamChatState? streamChatState;

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
  /// Gets client from widget
  StreamChatClient get client => widget.client;

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
                accentColor: streamTheme.colorTheme.accentPrimary,
              ),
              child: StreamChatCore(
                client: client,
                onBackgroundEventReceived: widget.onBackgroundEventReceived,
                backgroundKeepAlive: widget.backgroundKeepAlive,
                connectivityStream: widget.connectivityStream,
                child: widget.child ?? const Offstage(),
              ),
            );
          },
        ),
      ),
    );
  }

  StreamChatThemeData _getTheme(
    BuildContext context,
    StreamChatThemeData? themeData,
  ) {
    final appBrightness = Theme.of(context).brightness;
    final defaultTheme = StreamChatThemeData(brightness: appBrightness);
    return defaultTheme.merge(themeData);
  }

  /// The current user
  User? get user => widget.client.state.user;

  /// The current user as a stream
  Stream<User?> get userStream => widget.client.state.userStream;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final locale = ui.window.locale;
    Jiffy.locale(locale.languageCode);
    super.didChangeDependencies();
  }
}
