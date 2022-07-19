import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/autocomplete/stream_autocomplete.dart';
import 'package:stream_chat_flutter/src/emoji/emoji.dart';
import 'package:stream_chat_flutter/src/misc/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:substring_highlight/substring_highlight.dart';

/// {@template emoji_overlay}
/// Overlay for displaying emoji that can be used
/// {@endtemplate}
class StreamEmojiAutocompleteOptions extends StatelessWidget {
  /// Constructor for creating a [StreamEmojiAutocompleteOptions]
  const StreamEmojiAutocompleteOptions({
    super.key,
    required this.query,
    this.onEmojiSelected,
  });

  /// Query for searching emoji.
  final String query;

  /// Callback called when an emoji is selected.
  final ValueSetter<Emoji>? onEmojiSelected;

  @override
  Widget build(BuildContext context) {
    final emojis = Emoji.all().where((it) {
      final normalizedQuery = query.toUpperCase();
      final normalizedShortName = it.shortName?.toUpperCase();

      if (normalizedShortName == null) return false;

      return normalizedShortName.contains(normalizedQuery);
    });

    if (emojis.isEmpty) return const SizedBox.shrink();

    final streamChatTheme = StreamChatTheme.of(context);
    final colorTheme = streamChatTheme.colorTheme;
    final textTheme = streamChatTheme.textTheme;

    return StreamAutocompleteOptions<Emoji>(
      options: emojis,
      headerBuilder: (context) {
        return ListTile(
          dense: true,
          horizontalTitleGap: 0,
          leading: StreamSvgIcon.smile(
            color: colorTheme.accentPrimary,
            size: 28,
          ),
          title: Text(
            context.translations.emojiMatchingQueryText(query),
            style: TextStyle(
              color: colorTheme.textHighEmphasis.withOpacity(0.5),
            ),
          ),
        );
      },
      optionBuilder: (context, emoji) {
        final themeData = Theme.of(context);
        return ListTile(
          dense: true,
          horizontalTitleGap: 0,
          leading: Text(
            emoji.char!,
            style: themeData.textTheme.headline6!.copyWith(
              fontSize: 24,
            ),
          ),
          title: SubstringHighlight(
            text: emoji.shortName!,
            term: query,
            textStyleHighlight: themeData.textTheme.headline6!.copyWith(
              color: Colors.yellow,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
            ),
            textStyle: themeData.textTheme.headline6!.copyWith(
              fontSize: 14.5,
            ),
          ),
          onTap: onEmojiSelected == null ? null : () => onEmojiSelected!(emoji),
        );
      },
    );
  }
}
