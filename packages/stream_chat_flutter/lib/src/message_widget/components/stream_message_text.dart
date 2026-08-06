import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter/src/utils/device_segmentation.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart' as core;

/// Displays the translated markdown message text, reacting to the current
/// user's language preference.
///
/// The message text is translated into the current user's language, mention
/// syntax is replaced with display names, and the result is rendered as
/// markdown. Pass [showOriginalText] to display the original text instead,
/// even when a translation is available. Automatic translation can be
/// turned off SDK-wide via
/// [StreamChatConfigurationData.translationDisplayEnabled].
///
/// The widget rebuilds automatically when the current user's language
/// changes, ensuring the displayed text stays in sync.
///
/// On desktop and web the text is selectable; on mobile it is not.
///
/// See also:
///
///  * [StreamMessageScaffold], which hosts this widget inside a message bubble.
class StreamMessageText extends StatelessWidget {
  /// Creates a message text widget for the given [message].
  const StreamMessageText({
    super.key,
    required this.message,
    this.onLinkTap,
    this.onMentionTap,
    this.onAnyMentionTap,
    this.showOriginalText = false,
  });

  /// The message whose text to display.
  final Message message;

  /// Whether to display [message]'s original text instead of a translation,
  /// when [Message.i18n] has one for the current user's language.
  final bool showOriginalText;

  /// Called when a link in the rendered markdown is tapped.
  ///
  /// If null, tapping a link has no effect.
  final MarkdownTapLinkCallback? onLinkTap;

  /// Called when a user `@mention` in the rendered markdown is tapped.
  ///
  /// Only fires for user-type mentions; broadcast / role / group mentions are
  /// non-tappable when only this callback is set. To handle every mention
  /// kind, use [onAnyMentionTap] instead. When both are provided,
  /// [onAnyMentionTap] takes precedence.
  ///
  /// If null, tapping a user mention has no effect.
  final core.MarkdownTapMentionCallback? onMentionTap;

  /// Called when a mention of any kind is tapped.
  ///
  /// Receives the [core.StreamMentionType] decoded from the URL scheme along with
  /// the display text and the URL-decoded id payload. Takes precedence over
  /// [onMentionTap] when both are set.
  ///
  /// If null, falls back to [onMentionTap] for user mentions only.
  final core.MarkdownTapAnyMentionCallback? onAnyMentionTap;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    final deviceLanguage = Localizations.localeOf(context).languageCode;
    final translationDisplayEnabled = StreamChatConfiguration.of(context).translationDisplayEnabled;

    return BetterStreamBuilder<String>(
      initialData: _resolveLanguage(streamChat.currentUser?.language, deviceLanguage),
      stream: streamChat.currentUserStream.map((it) => _resolveLanguage(it?.language, deviceLanguage)),
      builder: (context, language) {
        final translated = (showOriginalText || !translationDisplayEnabled) ? message : message.translate(language);
        final messageText = translated.replaceMentions().text?.replaceAll('\n', '\n\n').trim();

        if (messageText == null || messageText.trim().isEmpty) return const Empty();

        return core.StreamMessageText(
          messageText,
          selectable: isDesktopDeviceOrWeb,
          onTapLink: onLinkTap,
          onTapMention: onMentionTap,
          onTapAnyMention: onAnyMentionTap,
        );
      },
    );
  }
}

// Stream's API defaults `User.language` to `''` rather than omitting it, so
// an empty string must fall back the same way a missing value does.
String _resolveLanguage(String? language, String fallback) => switch (language) {
  null || '' => fallback,
  final language => language,
};
