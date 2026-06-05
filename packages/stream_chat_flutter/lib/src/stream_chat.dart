import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/video/vlc/vlc_manager.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Provides chat state and configuration to the descendant widget tree.
///
/// Wrap your app (or a chat-bearing subtree) with [StreamChat] to expose the
/// [StreamChatClient], theme, and configuration to chat widgets below. Access
/// the state from descendants with [StreamChat.of] or [StreamChat.maybeOf].
///
/// {@tool snippet}
///
/// ```dart
/// MaterialApp(
///   home: StreamChat(
///     client: client,
///     child: const ChannelListPage(),
///   ),
/// )
/// ```
/// {@end-tool}
///
/// See also:
///
///  * [themeData], which controls chat widget styling via [StreamChatThemeData].
///  * [configData], which controls non-theme UI behaviour via [StreamChatConfigurationData].
///  * [StreamChatCore], the non-UI logic wrapper mounted below this widget.
class StreamChat extends StatefulWidget {
  /// Creates a [StreamChat] that exposes [client] and chat configuration to
  /// the descendant widget tree.
  const StreamChat({
    super.key,
    required this.client,
    required this.child,
    this.themeData,
    this.configData,
    this.componentBuilders,
    this.onBackgroundEventReceived,
    this.backgroundKeepAlive = const Duration(seconds: 15),
    this.connectivityStream,
  });

  /// The [StreamChatClient] used by descendant widgets to perform chat
  /// operations.
  final StreamChatClient client;

  /// The subtree below this widget.
  ///
  /// May be `null` when [StreamChat] is mounted without UI — for example in
  /// tests or when the chat client should run in the background only.
  final Widget? child;

  /// Theme overrides applied to descendant chat widgets.
  ///
  /// If `null`, a default [StreamChatThemeData] is used.
  final StreamChatThemeData? themeData;

  /// Non-theme UI configuration options for descendant chat widgets.
  ///
  /// If `null`, a default [StreamChatConfigurationData] is used.
  final StreamChatConfigurationData? configData;

  /// Custom component builders for overriding default UI components.
  ///
  /// When provided, a [StreamComponentFactory] is inserted into the widget
  /// tree below the theme and above [StreamChatCore], allowing all descendant
  /// widgets to resolve custom builders.
  ///
  /// {@tool snippet}
  ///
  /// Override the default message item with a custom builder:
  ///
  /// ```dart
  /// StreamChat(
  ///   client: client,
  ///   componentBuilders: StreamComponentBuilders(
  ///     extensions: streamChatComponentBuilders(
  ///       messageItem: (context, props) {
  ///         return DefaultStreamMessageItem(
  ///           props: props.copyWith(
  ///             actionsBuilder: myActionsBuilder,
  ///           ),
  ///         );
  ///       },
  ///     ),
  ///   ),
  ///   child: MyApp(),
  /// )
  /// ```
  /// {@end-tool}
  final StreamComponentBuilders? componentBuilders;

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
  StreamChatConfigurationData get configData => widget.configData ?? StreamChatConfigurationData();

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
    Widget child = StreamChatCore(
      client: client,
      onBackgroundEventReceived: widget.onBackgroundEventReceived,
      backgroundKeepAlive: widget.backgroundKeepAlive,
      connectivityStream: widget.connectivityStream,
      child: widget.child ?? const Empty(),
    );

    final theme = widget.themeData ?? StreamChatThemeData();
    child = StreamChatTheme(data: theme, child: child);

    final streamTheme = StreamTheme.of(context);
    child = Theme(data: Theme.of(context).withExtension(streamTheme), child: child);

    if (widget.componentBuilders case final builders?) {
      child = StreamComponentFactory(builders: builders, child: child);
    }

    return StreamStateScope(
      state: this,
      child: Portal(
        child: StreamChatConfiguration(data: configData, child: child),
      ),
    );
  }

  /// The current user
  User? get currentUser => widget.client.state.currentUser;

  /// The current user as a stream
  Stream<User?> get currentUserStream => widget.client.state.currentUserStream;

  @override
  void didChangeDependencies() {
    final currentLocale = Localizations.localeOf(context).toString().toLowerCase();
    final availableLocales = Jiffy.getSupportedLocales();
    if (availableLocales.contains(currentLocale)) Jiffy.setLocale(currentLocale);
    super.didChangeDependencies();
  }
}

extension on ThemeData {
  /// Returns a copy of this [ThemeData] with [extension] added, replacing any
  /// existing extension of the same runtime [Type].
  ThemeData withExtension(ThemeExtension<dynamic> extension) {
    // Trailing position is load-bearing: ThemeData.copyWith rebuilds the
    // extensions map keyed by Type with last-wins semantics, so [extension]
    // must come after the spread to win its slot when one is already present.
    return copyWith(extensions: [...extensions.values, extension]);
  }
}
