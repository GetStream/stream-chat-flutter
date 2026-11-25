import 'package:flutter/material.dart';

import '../../../stream_chat_flutter.dart';
import '../../misc/empty_widget.dart';
import '../played_mark_label.dart';

/// Shows whether the current user's message was played.
///
/// Reads "Played" in a two-member channel and "Played by 2" elsewhere, up to
/// "Played by 99+". Shows nothing until someone plays the message, such as a
/// voice recording.
///
/// Takes its text style from the surrounding [DefaultTextStyle].
///
/// See also:
///
///  * [StreamMessageFooter], which hosts this widget.
class StreamMessagePlayedMark extends StatelessWidget {
  /// Creates a played mark for [message].
  const StreamMessagePlayedMark({
    super.key,
    required this.message,
    this.onTap,
    this.excludeFromSemantics = false,
  });

  /// The message whose played state to display.
  final Message message;

  /// Called when the mark is tapped.
  ///
  /// If null, the mark is not tappable.
  final VoidCallback? onTap;

  /// Whether the mark stays out of the semantics tree.
  ///
  /// Set when an enclosing widget already speaks its text. A tappable mark
  /// stays in the tree regardless, so a screen reader can reach it.
  final bool excludeFromSemantics;

  @override
  Widget build(BuildContext context) {
    final label = playedMarkLabel(context, message);
    if (label == null) return const Empty();

    if (onTap == null) {
      return ExcludeSemantics(
        excluding: excludeFromSemantics,
        child: Text(label),
      );
    }

    return GestureDetector(
      behavior: .opaque,
      onTap: onTap,
      child: Text(label),
    );
  }
}
