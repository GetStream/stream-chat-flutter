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

  /// Use this method to get the current [StreamChatThemeData] instance
  static StreamChatConfigurationData of(BuildContext context) {
    final streamChatConfiguration =
        context.dependOnInheritedWidgetOfExactType<StreamChatConfiguration>();

    assert(
      streamChatConfiguration != null,
      '''
You must have a StreamChatConfigurationProvider widget at the top of your widget tree''',
    );

    return streamChatConfiguration!.data;
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
  }) {
    return StreamChatConfigurationData._(
      loadingIndicator: loadingIndicator,
      defaultUserImage: defaultUserImage ?? _defaultUserImage,
      placeholderUserImage: placeholderUserImage,
      reactionIcons: reactionIcons ?? StreamReactionIcon.defaultReactions,
      enforceUniqueReactions: enforceUniqueReactions ?? true,
      draftMessagesEnabled: draftMessagesEnabled,
    );
  }

  const StreamChatConfigurationData._({
    required this.loadingIndicator,
    required this.defaultUserImage,
    required this.placeholderUserImage,
    required this.reactionIcons,
    required this.enforceUniqueReactions,
    required this.draftMessagesEnabled,
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
  }) {
    return StreamChatConfigurationData(
      reactionIcons: reactionIcons ?? this.reactionIcons,
      defaultUserImage: defaultUserImage ?? this.defaultUserImage,
      placeholderUserImage: placeholderUserImage ?? this.placeholderUserImage,
      loadingIndicator: loadingIndicator ?? this.loadingIndicator,
      enforceUniqueReactions:
          enforceUniqueReactions ?? this.enforceUniqueReactions,
      draftMessagesEnabled: draftMessagesEnabled ?? this.draftMessagesEnabled,
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
