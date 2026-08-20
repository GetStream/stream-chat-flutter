import 'package:flutter/material.dart';
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
  bool updateShouldNotify(StreamChatConfiguration oldWidget) => data != oldWidget.data;

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
    final streamChatConfiguration = context.dependOnInheritedWidgetOfExactType<StreamChatConfiguration>();
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
    ReactionIconResolver? reactionIconResolver,
    bool? enforceUniqueReactions,
    bool draftMessagesEnabled = true,
    MessagePreviewFormatter? messagePreviewFormatter,
    StreamImageCDN imageCDN = const StreamImageCDN(),
    List<StreamAttachmentWidgetBuilder>? attachmentBuilders,
    StreamReactionsType? reactionType,
    StreamReactionsPosition? reactionPosition,
    StreamMessageTranslationConfiguration messageTranslation = const StreamMessageTranslationConfiguration(),
  }) {
    return StreamChatConfigurationData._(
      reactionIconResolver: reactionIconResolver ?? const DefaultReactionIconResolver(),
      enforceUniqueReactions: enforceUniqueReactions ?? false,
      draftMessagesEnabled: draftMessagesEnabled,
      messagePreviewFormatter: messagePreviewFormatter ?? MessagePreviewFormatter(),
      imageCDN: imageCDN,
      attachmentBuilders: attachmentBuilders,
      reactionType: reactionType,
      reactionPosition: reactionPosition,
      messageTranslation: messageTranslation,
    );
  }

  const StreamChatConfigurationData._({
    required this.reactionIconResolver,
    required this.enforceUniqueReactions,
    required this.draftMessagesEnabled,
    required this.messagePreviewFormatter,
    required this.imageCDN,
    required this.attachmentBuilders,
    required this.messageTranslation,
    this.reactionType,
    this.reactionPosition,
  });

  /// Copies the configuration options from one [StreamChatConfigurationData] to
  /// another.
  StreamChatConfigurationData copyWith({
    ReactionIconResolver? reactionIconResolver,
    bool? enforceUniqueReactions,
    bool? draftMessagesEnabled,
    MessagePreviewFormatter? messagePreviewFormatter,
    StreamImageCDN? imageCDN,
    List<StreamAttachmentWidgetBuilder>? attachmentBuilders,
    StreamReactionsType? reactionType,
    StreamReactionsPosition? reactionPosition,
    StreamMessageTranslationConfiguration? messageTranslation,
  }) {
    return StreamChatConfigurationData(
      reactionIconResolver: reactionIconResolver ?? this.reactionIconResolver,
      enforceUniqueReactions: enforceUniqueReactions ?? this.enforceUniqueReactions,
      draftMessagesEnabled: draftMessagesEnabled ?? this.draftMessagesEnabled,
      messagePreviewFormatter: messagePreviewFormatter ?? this.messagePreviewFormatter,
      imageCDN: imageCDN ?? this.imageCDN,
      attachmentBuilders: attachmentBuilders ?? this.attachmentBuilders,
      reactionType: reactionType ?? this.reactionType,
      reactionPosition: reactionPosition ?? this.reactionPosition,
      messageTranslation: messageTranslation ?? this.messageTranslation,
    );
  }

  /// If True, the user will be able to send draft messages.
  ///
  /// Defaults to False.
  final bool draftMessagesEnabled;

  /// The resolver used to convert reaction types into [StreamEmojiContent]
  /// models and to provide the list of supported/default reaction types.
  ///
  /// Defaults to [DefaultReactionIconResolver].
  final ReactionIconResolver reactionIconResolver;

  /// Whether a new reaction should replace the existing one.
  final bool enforceUniqueReactions;

  /// The formatter used for message previews throughout the application.
  ///
  /// Defaults to [MessagePreviewFormatter].
  final MessagePreviewFormatter messagePreviewFormatter;

  /// The image CDN used for generating resized image URLs and stable
  /// cache keys.
  ///
  /// Defaults to [StreamImageCDN], which supports Stream's own CDN.
  /// Extend [StreamImageCDN] to customize behavior for a custom CDN.
  final StreamImageCDN imageCDN;

  /// Custom attachment builders for rendering attachment widgets in messages.
  ///
  /// When non-null, these builders are prepended to the default builders
  /// based on the [Attachment.type], allowing custom attachment types to be
  /// rendered globally across all message widgets.
  final List<StreamAttachmentWidgetBuilder>? attachmentBuilders;

  /// The visual type of the reactions display used across all message widgets.
  ///
  /// When null, the widget resolves its own default
  /// ([StreamReactionsType.segmented]).
  final StreamReactionsType? reactionType;

  /// Where reactions appear relative to the message bubble across all
  /// message widgets.
  ///
  /// When null, the widget resolves its own default
  /// ([StreamReactionsPosition.header]).
  final StreamReactionsPosition? reactionPosition;

  /// How messages that carry a translation in [Message.i18n] are displayed.
  ///
  /// Defaults to [StreamMessageTranslationConfiguration]'s own defaults:
  /// translations are displayed automatically, without an annotation.
  final StreamMessageTranslationConfiguration messageTranslation;
}

/// {@template streamMessageTranslationConfiguration}
/// Configures how messages that carry a translation in [Message.i18n] are
/// displayed.
///
/// Pass an instance to [StreamChatConfigurationData.messageTranslation]:
///
/// ```dart
/// StreamChat(
///   client: client,
///   configData: StreamChatConfigurationData(
///     messageTranslation: const StreamMessageTranslationConfiguration(
///       annotationEnabled: true,
///     ),
///   ),
///   child: ChannelListPage(),
/// )
/// ```
/// {@endtemplate}
class StreamMessageTranslationConfiguration {
  /// {@macro streamMessageTranslationConfiguration}
  const StreamMessageTranslationConfiguration({
    this.enabled = true,
    this.annotationEnabled = false,
  });

  /// Whether a message displays its translation in place of its original
  /// text when [Message.i18n] has one for the current user's [User.language].
  ///
  /// Applies to full messages ([StreamMessageText]) as well as to the
  /// previews shown in the channel and thread lists
  /// ([StreamMessagePreviewText]).
  ///
  /// Defaults to `true`, which is what the SDK has always done. Set it to
  /// `false` to always show a message's original text, regardless of the
  /// translations available for it.
  final bool enabled;

  /// Whether a message displaying a translation shows a
  /// "Translated"/"Original" annotation, with a "Show original"/"Show
  /// translation" link that switches between the two.
  ///
  /// Ignored when [enabled] is `false` — no translation is on display, so
  /// there is nothing to annotate or switch away from.
  ///
  /// Defaults to `false`, matching the SDK's long-standing behaviour of
  /// translating messages without annotating them. Opt in to make the
  /// translation visible and reversible to the user.
  final bool annotationEnabled;

  /// Copies the configuration options from one
  /// [StreamMessageTranslationConfiguration] to another.
  StreamMessageTranslationConfiguration copyWith({
    bool? enabled,
    bool? annotationEnabled,
  }) {
    return StreamMessageTranslationConfiguration(
      enabled: enabled ?? this.enabled,
      annotationEnabled: annotationEnabled ?? this.annotationEnabled,
    );
  }
}
