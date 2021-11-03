import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/version.dart';
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
        'You must have a StreamChat widget at the top of your widget tree',
      );
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
                colorScheme: materialTheme.colorScheme.copyWith(
                  secondary: streamTheme.colorTheme.accentPrimary,
                ),
              ),
              child: StreamChatCore(
                client: client,
                onBackgroundEventReceived: widget.onBackgroundEventReceived,
                backgroundKeepAlive: widget.backgroundKeepAlive,
                connectivityStream: widget.connectivityStream,
                child: Builder(
                  builder: (context) {
                    StreamChatClient.additionalHeaders = {
                      'X-Stream-Client':
                          '${StreamChatClient.defaultUserAgent}-${Package.ui}',
                    };
                    return widget.child ?? const Offstage();
                  },
                ),
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

  // coverage:ignore-start

  /// The current user
  @Deprecated('Use `.currentUser` instead, Will be removed in future releases')
  User? get user => widget.client.state.currentUser;

  /// The current user as a stream
  @Deprecated(
    'Use `.currentUserStream` instead, Will be removed in future releases',
  )
  Stream<User?> get userStream => widget.client.state.currentUserStream;

  // coverage:ignore-end

  /// The current user
  User? get currentUser => widget.client.state.currentUser;

  /// The current user as a stream
  Stream<User?> get currentUserStream => widget.client.state.currentUserStream;

  @override
  void didChangeDependencies() {
    final currentLocale = Localizations.localeOf(context);
    final languageCode = currentLocale.languageCode;
    final availableLocales = Jiffy.getAllAvailableLocales();
    if (availableLocales.contains(languageCode)) {
      Jiffy.locale(languageCode);
    }
    super.didChangeDependencies();
  }
}
