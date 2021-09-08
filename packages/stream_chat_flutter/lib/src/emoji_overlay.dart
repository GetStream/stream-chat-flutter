import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter/src/emoji/emoji.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:substring_highlight/substring_highlight.dart';

class EmojiOverlay extends StatelessWidget {
  final BuildContext context;
  final String query;
  final ValueChanged<Emoji> onEmojiResult;

  const EmojiOverlay(
    this.context, {
    required this.query,
    required this.onEmojiResult,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext otherContext) {
    var _streamChatTheme = StreamChatTheme.of(context);
    var _emojiNames =
        Emoji.all().where((it) => it.name != null).map((e) => e.name!);

    final emojis = _emojiNames
        .where((e) => e.contains(query))
        .map(Emoji.byName)
        .where((e) => e != null);

    if (emojis.isEmpty) {
      return const SizedBox();
    }

    // ignore: cast_nullable_to_non_nullable
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 2,
      color: _streamChatTheme.colorTheme.barsBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        constraints: BoxConstraints.loose(Size(size.width - 16, 200)),
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
