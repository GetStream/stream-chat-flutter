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
  });

  /// The message to display.
  final Message message;

  /// The channel to which the message belongs.
  final ChannelModel? channel;

  /// The language to use for translations.
  final String? language;

  /// The style to use for the text.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final currentUser = StreamChat.of(context).currentUser!;
    final translationLanguage = language ?? currentUser.language ?? 'en';
    final translatedMessage = message.translate(translationLanguage);
    final previewMessage = translatedMessage.replaceMentions(linkify: false);

    final config = StreamChatConfiguration.of(context);
    final formatter = config.messagePreviewFormatter;

    final previewTextSpan = formatter.formatMessage(
      context,
      previewMessage,
      channel: channel,
      currentUser: currentUser,
      textStyle: textStyle,
    );

    return Text.rich(
      maxLines: 1,
      previewTextSpan,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
    );
  }
}
