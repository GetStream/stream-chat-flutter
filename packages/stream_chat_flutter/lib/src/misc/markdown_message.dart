import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:stream_chat_flutter/src/ai_assistant/streaming_message_view.dart';
import 'package:stream_chat_flutter/src/theme/message_theme.dart';

import 'package:stream_chat_flutter/src/utils/device_segmentation.dart';

/// {@template streamMarkdownMessage}
/// A widget that displays a markdown message. This widget uses the markdown
/// package to parse the markdown data and display it.
///
/// This widget is used by [StreamMessageText] and [StreamingMessageView] to
/// display the message text.
/// {@endtemplate}
class StreamMarkdownMessage extends StatelessWidget {
  /// {@macro streamMarkdownMessage}
  const StreamMarkdownMessage({
    super.key,
    required this.data,
    this.selectable,
    this.onTapLink,
    this.messageTheme,
    this.styleSheet,
    this.syntaxHighlighter,
    this.builders = const {},
    this.paddingBuilders = const {},
  });

  /// The markdown data to display.
  final String data;

  /// Whether the text is selectable.
  final bool? selectable;

  /// Called when the user taps a link.
  final MarkdownTapLinkCallback? onTapLink;

  /// The theme to apply to the message text.
  final StreamMessageThemeData? messageTheme;

  /// Optional style sheet to customize the markdown output.
  ///
  /// When provided, it will be merged with the default one.
  final MarkdownStyleSheet? styleSheet;

  /// The syntax highlighter used to color text in `pre` elements.
  ///
  /// If null, the [MarkdownStyleSheet.code] style is used for `pre` elements.
  final SyntaxHighlighter? syntaxHighlighter;

  /// Render certain tags, usually used with [extensionSet]
  ///
  /// For example, we will add support for `sub` tag:
  ///
  /// ```dart
  /// builders: {
  ///   'sub': SubscriptBuilder(),
  /// }
  /// ```
  ///
  /// The `SubscriptBuilder` is a subclass of [MarkdownElementBuilder].
  final Map<String, MarkdownElementBuilder> builders;

  /// Add padding for different tags (use only for block elements and img)
  ///
  /// For example, we will add padding for `img` tag:
  ///
  /// ```dart
  /// paddingBuilders: {
  ///   'img': ImgPaddingBuilder(),
  /// }
  /// ```
  ///
  /// The `ImgPaddingBuilder` is a subclass of [MarkdownPaddingBuilder].
  final Map<String, MarkdownPaddingBuilder> paddingBuilders;

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);

    return MarkdownBody(
      data: data,
      selectable: selectable ?? isDesktopDeviceOrWeb,
      onTapText: () {},
      onSelectionChanged: (val, selection, cause) {},
      onTapLink: onTapLink,
      syntaxHighlighter: syntaxHighlighter,
      builders: builders,
      paddingBuilders: paddingBuilders,
      styleSheet:
          MarkdownStyleSheet.fromTheme(
                themeData.copyWith(
                  textTheme: themeData.textTheme.apply(
                    bodyColor: messageTheme?.messageTextStyle?.color,
                    decoration: messageTheme?.messageTextStyle?.decoration,
                    decorationColor: messageTheme?.messageTextStyle?.decorationColor,
                    decorationStyle: messageTheme?.messageTextStyle?.decorationStyle,
                    fontFamily: messageTheme?.messageTextStyle?.fontFamily,
                  ),
                ),
              )
              .copyWith(
                a: messageTheme?.messageLinksStyle,
                p: messageTheme?.messageTextStyle,
              )
              .merge(styleSheet),
    );
  }
}
