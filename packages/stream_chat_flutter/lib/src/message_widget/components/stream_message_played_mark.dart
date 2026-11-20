import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../../stream_chat_flutter.dart';
import '../../misc/empty_widget.dart';

/// Shows whether the current user's voice recording was played.
///
/// Reads "Not played" or "Played" in a one-to-one channel and "Played by 2"
/// elsewhere, highlighted once anyone has played it. Shows nothing unless
/// [StreamChatConfigurationData.showMessageMarks] is set and [message] is the
/// current user's voice recording in a channel whose [ChannelConfig.markTypes]
/// include [MessageMarkType.played].
///
/// See also:
///
///  * [StreamMessageFooter], which hosts this widget.
class StreamMessagePlayedMark extends StatelessWidget {
  /// Creates a played mark for [message].
  const StreamMessagePlayedMark({
    super.key,
    required this.message,
    this.separator = core.StreamMessageMark.separator,
    this.onTap,
    this.excludeFromSemantics = false,
  });

  /// The message whose played state to display.
  final Message message;

  /// The widget after the label, or null when nothing follows the mark.
  final Widget? separator;

  /// Called when the mark is tapped.
  ///
  /// Ignored in a one-to-one channel and before anyone has played the message.
  final VoidCallback? onTap;

  /// Whether the mark stays out of the semantics tree.
  ///
  /// Set when an enclosing widget already speaks its text. A tappable mark
  /// stays in the tree regardless, so a screen reader can reach it.
  final bool excludeFromSemantics;

  /// Whether a played mark is shown for [message] in this [context].
  static bool isShownFor(BuildContext context, Message message) {
    final configuration = StreamChatConfiguration.maybeOf(context);
    if (configuration?.showMessageMarks != true) return false;

    final currentUserId = StreamChat.maybeOf(context)?.currentUser?.id;
    if (currentUserId == null || message.user?.id != currentUserId) return false;

    final channel = StreamChannel.maybeOf(context)?.channel;
    final markTypes = channel?.config?.markTypes ?? const [];
    if (!markTypes.contains(MessageMarkType.played)) return false;

    return message.attachments.any((it) => it.isVoiceRecording);
  }

  /// The played mark's text for [message], or null when none is shown.
  static String? labelFor(BuildContext context, Message message) {
    if (!isShownFor(context, message)) return null;

    final translations = context.translations;
    final count = _playedCount(message);

    return switch ((_isOneToOne(context), count)) {
      (true, 0) => translations.messageNotPlayedLabel,
      (true, _) => translations.messagePlayedLabel,
      (false, _) => translations.messagePlayedByLabel(count),
    };
  }

  static int _playedCount(Message message) {
    return message.markGroups?[MessageMarkType.played]?.count ?? 0;
  }

  static bool _isOneToOne(BuildContext context) {
    return StreamChannel.maybeOf(context)?.channel.isOneToOne ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final label = labelFor(context, message);
    if (label == null) return const Empty();

    final count = _playedCount(message);
    final canTap = !_isOneToOne(context) && count > 0;
    final effectiveOnTap = canTap ? onTap : null;

    return ExcludeSemantics(
      excluding: excludeFromSemantics && effectiveOnTap == null,
      child: core.StreamMessageMark(
        label: Text(label),
        highlighted: count > 0,
        separator: separator,
        onTap: effectiveOnTap,
      ),
    );
  }
}
