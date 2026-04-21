import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that renders a preview of the message text.
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
    final translationLanguage = language ?? currentUser?.language ?? 'en';
    final translatedMessage = message.translate(translationLanguage);
    final previewMessage = translatedMessage.replaceMentions(linkify: false);

    final config = StreamChatConfiguration.of(context);
    final formatter = config.messagePreviewFormatter;

    final previewTextSpan = formatter.formatMessage(
      context,
      previewMessage,
      channel: channel,
      currentUser: currentUser,
      showCaption: showCaption,
    );

    return Text.rich(
      maxLines: 1,
      previewTextSpan,
      style: textStyle,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}
