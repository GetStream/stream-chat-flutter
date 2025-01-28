import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';

/// {@template giphy_chip}
/// Simple widget which displays a Giphy attribution chip.
/// {@endtemplate}
class GiphyChip extends StatelessWidget {
  /// {@macro giphy_chip}
  const GiphyChip({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = StreamChatTheme.of(context).colorTheme;
    return Container(
      decoration: BoxDecoration(
        color: colorTheme.overlayDark,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
      child: Row(
        children: [
          StreamSvgIcon(
            size: 16,
            icon: StreamSvgIcons.lightning,
            color: colorTheme.barsBg,
          ),
          Text(
            context.translations.giphyLabel.toUpperCase(),
            style: TextStyle(
              color: StreamChatTheme.of(context).colorTheme.barsBg,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
