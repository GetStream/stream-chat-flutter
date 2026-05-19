import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

/// {@template giphy_chip}
/// Simple widget which displays a Giphy attribution chip.
/// {@endtemplate}
class GiphyChip extends StatelessWidget {
  /// {@macro giphy_chip}
  const GiphyChip({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.backgroundOverlayDark,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
      child: Row(
        children: [
          Icon(
            context.streamIcons.bolt,
            size: 16,
            color: colorScheme.backgroundElevation1,
          ),
          Text(
            context.translations.giphyLabel.toUpperCase(),
            style: TextStyle(
              color: colorScheme.backgroundElevation1,
              fontWeight: FontWeight.bold,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}
