import '../../stream_chat_flutter.dart';

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
