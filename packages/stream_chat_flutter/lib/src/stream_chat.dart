import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/video/vlc/vlc_manager.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamChat}
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
/// {@endtemplate}
class StreamChat extends StatefulWidget {
  /// {@macro streamChat}
  const StreamChat({
    super.key,
    required this.client,
    required this.child,
    this.streamChatThemeData,
    this.streamChatConfigData,
    this.onBackgroundEventReceived,
    this.backgroundKeepAlive = const Duration(minutes: 1),
    this.connectivityStream,
  });

  /// Client to do chat operations with
  final StreamChatClient client;

  /// Child which inherits details
  final Widget? child;

  /// Theme to pass on
  final StreamChatThemeData? streamChatThemeData;

  /// Non-theme related UI configuration options.
  final StreamChatConfigurationData? streamChatConfigData;

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

  /// Gets configuration options from widget
  StreamChatConfigurationData get streamChatConfigData =>
      widget.streamChatConfigData ?? StreamChatConfigurationData();

  @override
  void initState() {
    super.initState();
    // Ensures that VLC only initializes in real desktop environments
    if (!isTestEnvironment && isDesktopVideoPlayerSupported) {
      VlcManager.instance.initialize();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme(context, widget.streamChatThemeData);
    return Portal(
      child: StreamChatConfiguration(
        data: streamChatConfigData,
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
                            '${StreamChatClient.defaultUserAgent}-'
                                'ui-${StreamChatClient.packageVersion}',
                      };
                      return widget.child ?? const Offstage();
                    },
                  ),
                ),
              );
            },
          ),
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
  User? get currentUser => widget.client.state.currentUser;

  /// The current user as a stream
  Stream<User?> get currentUserStream => widget.client.state.currentUserStream;

  @override
  void didChangeDependencies() {
    final currentLocale = Localizations.localeOf(context).toString();
    final availableLocales = Jiffy.getSupportedLocales();
    if (availableLocales.contains(currentLocale)) {
      Jiffy.setLocale(currentLocale);
    }
    super.didChangeDependencies();
  }
}
