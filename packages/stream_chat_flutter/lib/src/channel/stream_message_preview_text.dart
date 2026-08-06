import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that renders a preview of the message text.
///
/// The preview is translated into the current user's language when
/// [Message.i18n] has one, unless disabled SDK-wide via
/// [StreamChatConfigurationData.translationDisplayEnabled] — matching the
/// same opt-out [StreamMessageText] respects for the full message bubble.
class StreamMessagePreviewText extends StatelessWidget {
  /// Creates a new instance of [StreamMessagePreviewText].
  const StreamMessagePreviewText({
    super.key,
    required this.message,
    this.channel,
    this.language,
    this.textStyle,
    this.showCaption = true,
  });

  /// The message to display.
  final Message message;

  /// The channel to which the message belongs.
  final ChannelModel? channel;

  /// The language to use for translations.
  final String? language;

  /// The style to use for the text.
  final TextStyle? textStyle;

  /// Whether to include the message text caption alongside the type label.
  ///
  /// Set to `false` for tight previews (e.g. quoted / edit headers) where
  /// only the attachment type label should be shown.
  final bool showCaption;

  @override
  Widget build(BuildContext context) {
    final currentUser = StreamChat.maybeOf(context)?.currentUser;
    // Stream's API defaults `User.language` to `''` rather than omitting
    // it, so an empty string must fall back the same way a missing value
    // does.
    final translationLanguage =
        language ??
        switch (currentUser?.language) {
          null || '' => Localizations.localeOf(context).languageCode,
          final userLanguage => userLanguage,
        };
    final config = StreamChatConfiguration.of(context);
    final translatedMessage = config.translationDisplayEnabled ? message.translate(translationLanguage) : message;
    final previewMessage = translatedMessage.replaceMentions(linkify: false);

    final formatter = config.messagePreviewFormatter;

    final previewTextSpan = formatter.formatMessage(
      context,
      previewMessage,
      channel: channel,
      currentUser: currentUser,
      showCaption: showCaption,
    );

    // Prefer a hand-crafted a11y label when the formatter opts into
    // [AccessibleMessagePreviewFormatter]; fall back to the visual
    // TextSpan stripped of inline icon placeholders so custom formatters
    // that only implement [MessagePreviewFormatter] still get a
    // reasonable — if less rich — screen-reader announcement.
    final a11yLabel = switch (formatter) {
      final AccessibleMessagePreviewFormatter it => it.formatMessageSemanticsLabel(
        context,
        previewMessage,
        channel: channel,
        currentUser: currentUser,
        showCaption: showCaption,
      ),
      _ => previewTextSpan.toPlainText(includePlaceholders: false),
    };

    return Text.rich(
      maxLines: 1,
      previewTextSpan,
      style: textStyle,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      semanticsLabel: a11yLabel,
    );
  }
}
