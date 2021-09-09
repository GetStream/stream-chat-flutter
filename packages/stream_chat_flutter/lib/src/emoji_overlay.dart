import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter/src/emoji/emoji.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:substring_highlight/substring_highlight.dart';

/// Overlay for displaying emoji that can be used
class EmojiOverlay extends StatelessWidget {
  /// Constructor for creating a [EmojiOverlay]
  const EmojiOverlay({
    required this.query,
    required this.onEmojiResult,
    required this.size,
    Key? key,
  }) : super(key: key);

  /// The size of the overlay
  final Size size;

  /// Query for searching emoji
  final String query;

  /// Callback called when an emoji is selected
  final ValueChanged<Emoji> onEmojiResult;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);
    final _emojiNames =
        Emoji.all().where((it) => it.name != null).map((e) => e.name!);

    final emojis = _emojiNames
        .where((e) => e.contains(query))
        .map(Emoji.byName)
        .where((e) => e != null);

    if (emojis.isEmpty) {
      return const SizedBox();
    }

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      color: _streamChatTheme.colorTheme.barsBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        constraints: BoxConstraints.loose(size),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              spreadRadius: -8,
              blurRadius: 5,
              offset: Offset(0, -4),
            ),
          ],
          color: _streamChatTheme.colorTheme.barsBg,
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          itemCount: emojis.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return Padding(
                padding: const EdgeInsets.only(left: 8, top: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: StreamSvgIcon.smile(
                        color: _streamChatTheme.colorTheme.accentPrimary,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        context.translations.emojiMatchingQueryText(
                          query,
                        ),
                        style: TextStyle(
                          color: _streamChatTheme.colorTheme.textHighEmphasis
                              .withOpacity(.5),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }

            final emoji = emojis.elementAt(i - 1)!;
            final themeData = Theme.of(context);
            return ListTile(
              title: SubstringHighlight(
                text:
                    // ignore: lines_longer_than_80_chars
                    "${emoji.char} ${emoji.name!.replaceAll('_', ' ')}",
                term: query,
                textStyleHighlight: themeData.textTheme.headline6!.copyWith(
                  fontSize: 14.5,
                  fontWeight: FontWeight.bold,
                ),
                textStyle: themeData.textTheme.headline6!.copyWith(
                  fontSize: 14.5,
                ),
              ),
              onTap: () {
                onEmojiResult(emoji);
              },
            );
          },
        ),
      ),
    );
  }
}
