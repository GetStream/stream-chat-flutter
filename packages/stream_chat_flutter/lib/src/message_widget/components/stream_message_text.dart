import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../misc/empty_widget.dart';
import '../../stream_chat.dart';
import '../../stream_chat_configuration.dart';
import '../../utils/device_segmentation.dart';
import '../../utils/extensions.dart';

/// Displays the translated markdown message text, reacting to the current
/// user's language preference.
///
/// The message text is translated into the current user's language, mention
/// syntax is replaced with display names, and the result is rendered as
/// markdown. Pass `showTranslatedText: false` to display the original text
/// even when a translation is available. Automatic translation can be
/// turned off SDK-wide via [StreamMessageTranslationConfiguration.enabled].
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
    this.showTranslatedText = true,
    this.onSelectionChanged,
  });

  /// The message whose text to display.
  final Message message;

  /// Whether to display the translation of [message] when [Message.i18n] has
  /// one for the current user's language.
  ///
  /// Set to `false` to display the original text instead. Defaults to `true`.
  final bool showTranslatedText;

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

  /// Called when the selected content changes.
  final ValueChanged<SelectedContent?>? onSelectionChanged;

  @override
  Widget build(BuildContext context) {
    final streamChat = StreamChat.of(context);
    final translationConfig = StreamChatConfiguration.of(context).messageTranslation;

    // An unset language arrives from the API as `''` anyway, and `translate`
    // treats it the same as null, so it stands in for "no language" here —
    // `BetterStreamBuilder`'s type parameter can't be nullable.
    return BetterStreamBuilder<String>(
      initialData: streamChat.currentUser?.language ?? '',
      stream: streamChat.currentUserStream.map((it) => it?.language ?? ''),
      builder: (context, language) {
        final translated = (showTranslatedText && translationConfig.enabled) ? message.translate(language) : message;
        final messageText = translated.replaceMentions().text?.replaceAll('\n', '\n\n').trim();

        if (messageText == null || messageText.trim().isEmpty) return const Empty();

        final streamMessageText = core.StreamMessageText(
          messageText,
          selectable: false,
          onTapLink: onLinkTap,
          onTapMention: onMentionTap,
          onTapAnyMention: onAnyMentionTap,
        );

        if (isDesktopDeviceOrWeb) {
          return SelectionArea(
            // Rebuilding a live selection area after the browser context menu
            // toggles throws on web; the key replaces it instead.
            // TODO(flutter): Remove once the minimum Flutter has flutter/flutter#186459.
            key: ValueKey(BrowserContextMenu.enabled),
            onSelectionChanged: onSelectionChanged,
            child: streamMessageText,
          );
        }

        return streamMessageText;
      },
    );
  }
}
