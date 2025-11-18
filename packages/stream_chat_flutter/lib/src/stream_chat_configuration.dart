import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/indicators/loading_indicator.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamChatConfiguration}
/// Inherited widget providing the [StreamChatConfigurationData]
/// to the widget tree
/// {@endtemplate}
class StreamChatConfiguration extends InheritedWidget {
  /// {@macro streamChatConfiguration}
  const StreamChatConfiguration({
    super.key,
    required this.data,
    required super.child,
  });

  /// {@macro streamChatConfigurationData}
  final StreamChatConfigurationData data;

  @override
  bool updateShouldNotify(StreamChatConfiguration oldWidget) =>
      data != oldWidget.data;

  /// Finds the [StreamChatConfigurationData] from the closest
  /// [StreamChatConfiguration] ancestor that encloses the given context.
  ///
  /// This will throw a [FlutterError] if no [StreamChatConfiguration] is found
  /// in the widget tree above the given context.
  ///
  /// Typical usage:
  ///
  /// ```dart
  /// final config = StreamChatConfiguration.of(context);
  /// ```
  ///
  /// If you're calling this in the same `build()` method that creates the
  /// `StreamChatConfiguration`, consider using a `Builder` or refactoring into
  /// a separate widget to obtain a context below the [StreamChatConfiguration].
  ///
  /// If you want to return null instead of throwing, use [maybeOf].
  static StreamChatConfigurationData of(BuildContext context) {
    final result = maybeOf(context);
    if (result != null) return result;

    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'StreamChatConfiguration.of() called with a context that does not '
        'contain a StreamChatConfiguration.',
      ),
      ErrorDescription(
        'No StreamChatConfiguration ancestor could be found starting from the '
        'context that was passed to StreamChatConfiguration.of(). This usually '
        'happens when the context used comes from the widget that creates the '
        'StreamChatConfiguration itself.',
      ),
      ErrorHint(
        'To fix this, ensure that you are using a context that is a descendant '
        'of the StreamChatConfiguration. You can use a Builder to get a new '
        'context that is under the StreamChatConfiguration:\n\n'
        '  Builder(\n'
        '    builder: (context) {\n'
        '      final config = StreamChatConfiguration.of(context);\n'
        '      ...\n'
        '    },\n'
        '  )',
      ),
      ErrorHint(
        'Alternatively, split your build method into smaller widgets so that '
        'you get a new BuildContext that is below the StreamChatConfiguration '
        'in the widget tree.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  /// Finds the [StreamChatConfigurationData] from the closest
  /// [StreamChatConfiguration] ancestor that encloses the given context.
  ///
  /// Returns null if no such ancestor exists.
  ///
  /// See also:
  ///  * [of], which throws if no [StreamChatConfiguration] is found.
  static StreamChatConfigurationData? maybeOf(BuildContext context) {
    final streamChatConfiguration =
        context.dependOnInheritedWidgetOfExactType<StreamChatConfiguration>();
    return streamChatConfiguration?.data;
  }
}

/// {@template streamChatConfigurationData}
/// Provides global, user-configurable, non-theme related configuration
/// options to Flutter applications that use Stream Chat.
///
/// In order to set these configuration options, you must pass an instance of
/// this class to the [StreamChat] widget, or wrap a subtree using
/// the [StreamChatConfiguration] inherited widget.
///
/// If you need to access the configuration directly at a later point in your
/// application, you can use the [StreamChatConfiguration.of] method
/// to retrieve it.
///
/// If no [StreamChatConfigurationData] is provided, the
/// [StreamChatConfiguration.defaults] factory constructor is used to provide a
/// default configuration.
///
/// If you want to keep some of the default values, but not others, you can use
/// the [StreamChatConfigurationData.copyWith] method to override the values in
/// question.
///
/// Example 1:
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({
///     required this.client,
///   });
///
///   final StreamChatClient client;
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Container(
///         child: StreamChat(
///           client: client,
///           // No configuration provided, so the defaults are used.
///           child: ChannelListPage(),
///         ),
///       ),
///     );
///   }
/// }
/// ```
///
/// Example 2:
/// ```dart
/// class MyApp extends StatelessWidget {
///   const MyApp({
///     required this.client,
///   });
///
///   final StreamChatClient client;
///
///   @override
///   Widget build(BuildContext context) {
///     return MaterialApp(
///       home: Container(
///         child: StreamChat(
///           client: client,
///           config: StreamChatConfiguration.defaults().copyWith(
///             // Override a specific default value here
///           ),
///           child: ChannelListPage(),
///         ),
///       ),
///     );
///   }
/// }
/// ```
/// {@endtemplate}
class StreamChatConfigurationData {
  /// {@macro streamChatConfigurationData}
  factory StreamChatConfigurationData({
    Widget loadingIndicator = const StreamLoadingIndicator(),
    Widget Function(BuildContext, User)? defaultUserImage,
    Widget Function(BuildContext, User)? placeholderUserImage,
    List<StreamReactionIcon>? reactionIcons,
    bool? enforceUniqueReactions,
    bool draftMessagesEnabled = false,
    MessagePreviewFormatter? messagePreviewFormatter,
  }) {
    return StreamChatConfigurationData._(
      loadingIndicator: loadingIndicator,
      defaultUserImage: defaultUserImage ?? _defaultUserImage,
      placeholderUserImage: placeholderUserImage,
      reactionIcons: reactionIcons ?? StreamReactionIcon.defaultReactions,
      enforceUniqueReactions: enforceUniqueReactions ?? true,
      draftMessagesEnabled: draftMessagesEnabled,
      messagePreviewFormatter:
          messagePreviewFormatter ?? MessagePreviewFormatter(),
    );
  }

  const StreamChatConfigurationData._({
    required this.loadingIndicator,
    required this.defaultUserImage,
    required this.placeholderUserImage,
    required this.reactionIcons,
    required this.enforceUniqueReactions,
    required this.draftMessagesEnabled,
    required this.messagePreviewFormatter,
  });

  /// Copies the configuration options from one [StreamChatConfigurationData] to
  /// another.
  StreamChatConfigurationData copyWith({
    Widget? loadingIndicator,
    Widget Function(BuildContext, User)? defaultUserImage,
    Widget Function(BuildContext, User)? placeholderUserImage,
    List<StreamReactionIcon>? reactionIcons,
    bool? enforceUniqueReactions,
    bool? draftMessagesEnabled,
    MessagePreviewFormatter? messagePreviewFormatter,
  }) {
    return StreamChatConfigurationData(
      reactionIcons: reactionIcons ?? this.reactionIcons,
      defaultUserImage: defaultUserImage ?? this.defaultUserImage,
      placeholderUserImage: placeholderUserImage ?? this.placeholderUserImage,
      loadingIndicator: loadingIndicator ?? this.loadingIndicator,
      enforceUniqueReactions:
          enforceUniqueReactions ?? this.enforceUniqueReactions,
      draftMessagesEnabled: draftMessagesEnabled ?? this.draftMessagesEnabled,
      messagePreviewFormatter:
          messagePreviewFormatter ?? this.messagePreviewFormatter,
    );
  }

  /// If True, the user will be able to send draft messages.
  ///
  /// Defaults to False.
  final bool draftMessagesEnabled;

  /// The widget that will be shown to indicate loading.
  final Widget loadingIndicator;

  /// The widget that will be built when the user image is unavailable.
  final Widget Function(BuildContext, User) defaultUserImage;

  /// The widget that will be built when the user image is loading.
  final Widget Function(BuildContext, User)? placeholderUserImage;

  /// Assets used for rendering reactions.
  final List<StreamReactionIcon> reactionIcons;

  /// Whether a new reaction should replace the existing one.
  final bool enforceUniqueReactions;

  /// The formatter used for message previews throughout the application.
  ///
  /// Defaults to [MessagePreviewFormatter].
  final MessagePreviewFormatter messagePreviewFormatter;

  static Widget _defaultUserImage(
    BuildContext context,
    User user,
  ) {
    return Center(
      child: StreamGradientAvatar(
        name: user.name,
        userId: user.id,
      ),
    );
  }
}
