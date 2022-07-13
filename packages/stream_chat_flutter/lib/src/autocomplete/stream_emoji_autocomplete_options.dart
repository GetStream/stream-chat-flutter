import 'package:flutter/material.dart';
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
    final _streamChatTheme = StreamChatTheme.of(context);

    final emojis = Emoji.all().where((it) {
      final normalizedQuery = query.toUpperCase();
      final normalizedShortName = it.shortName?.toUpperCase();

      if (normalizedShortName == null) return false;

      return normalizedShortName.contains(normalizedQuery);
    });

    if (emojis.isEmpty) return const SizedBox.shrink();

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      color: _streamChatTheme.colorTheme.barsBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            dense: true,
            horizontalTitleGap: 0,
            leading: StreamSvgIcon.smile(
              color: _streamChatTheme.colorTheme.accentPrimary,
              size: 28,
            ),
            title: Text(
              context.translations.emojiMatchingQueryText(query),
              style: TextStyle(
                color: _streamChatTheme.colorTheme.textHighEmphasis
                    .withOpacity(0.5),
              ),
            ),
          ),
          const Divider(height: 0),
          LimitedBox(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: emojis.length,
              itemBuilder: (context, i) {
                final emoji = emojis.elementAt(i);
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
                  onTap: onEmojiSelected == null
                      ? null
                      : () => onEmojiSelected!(emoji),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
