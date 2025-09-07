import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
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
  final Stream<List<ConnectivityResult>>? connectivityStream;

  @override
  StreamChatState createState() => StreamChatState();

  /// Finds the [StreamChatState] from the closest [StreamChat] ancestor
  /// that encloses the given [context].
  ///
  /// This will throw a [FlutterError] if no [StreamChat] is found in the
  /// widget tree above the given context.
  ///
  /// Typical usage:
  ///
  /// ```dart
  /// final chatState = StreamChat.of(context);
  /// ```
  ///
  /// If you're calling this in the same `build()` method that creates the
  /// `StreamChat`, consider using a `Builder` or refactoring into a
  /// separate widget to obtain a context below the [StreamChat].
  ///
  /// If you want to return null instead of throwing, use [maybeOf].
  static StreamChatState of(BuildContext context) {
    final result = maybeOf(context);
    if (result != null) return result;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'StreamChat.of() called with a context that does not contain a '
        'StreamChat.',
      ),
      ErrorDescription(
        'No StreamChat ancestor could be found starting from the context '
        'that was passed to StreamChat.of(). This usually happens when the '
        'context used comes from the widget that creates the StreamChat '
        'itself.',
      ),
      ErrorHint(
        'To fix this, ensure that you are using a context that is a descendant '
        'of the StreamChat. You can use a Builder to get a new context that '
        'is under the StreamChat:\n\n'
        '  Builder(\n'
        '    builder: (context) {\n'
        '      final chatState = StreamChat.of(context);\n'
        '      ...\n'
        '    },\n'
        '  )',
      ),
      ErrorHint(
        'Alternatively, split your build method into smaller widgets so that '
        'you get a new BuildContext that is below the StreamChat in the '
        'widget tree.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Finds the [StreamChatState] from the closest [StreamChat] ancestor
  /// that encloses the given context.
  ///
  /// Returns null if no such ancestor exists.
  ///
  /// See also:
  ///  * [of], which throws if no [StreamChat] is found.
  static StreamChatState? maybeOf(BuildContext context) {
    return context.findAncestorStateOfType<StreamChatState>();
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
                      return widget.child ?? const Empty();
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
    final currentLocale = Localizations.localeOf(context).toString().toLowerCase();
    final availableLocales = Jiffy.getSupportedLocales();
    if (availableLocales.contains(currentLocale)) {
      Jiffy.setLocale(currentLocale);
    }
    super.didChangeDependencies();
  }
}
