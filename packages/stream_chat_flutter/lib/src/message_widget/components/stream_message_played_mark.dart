import 'package:flutter/material.dart';
import 'package:stream_core_flutter/chat.dart' as core;

import '../../../stream_chat_flutter.dart';
import '../../misc/empty_widget.dart';

/// Shows that the current user's voice recording or video was played.
///
/// Reads "Played" in a two-member channel and "Played by 2" elsewhere, up to
/// "Played by 99+". Shows nothing until someone plays the message.
/// Requires [StreamChatConfigurationData.showMessageMarks] and a channel whose
/// [ChannelConfig.markTypes] include [MessageMarkType.played].
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
  /// Ignored in a two-member channel.
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

    if (!message.attachments.any((it) => it.isVoiceRecording || it.isVideo)) return false;

    return _playedCount(message) > 0;
  }

  /// The played mark's text for [message], or null when none is shown.
  static String? labelFor(BuildContext context, Message message) {
    if (!isShownFor(context, message)) return null;

    final translations = context.translations;
    if (_isTwoMember(context)) return translations.messagePlayedLabel;

    return translations.messagePlayedByLabel(_playedCount(message));
  }

  static int _playedCount(Message message) {
    return message.markGroups?[MessageMarkType.played]?.count ?? 0;
  }

  static bool _isTwoMember(BuildContext context) {
    return StreamChannel.maybeOf(context)?.channel.memberCount == 2;
  }

  @override
  Widget build(BuildContext context) {
    final label = labelFor(context, message);
    if (label == null) return const Empty();

    final effectiveOnTap = _isTwoMember(context) ? null : onTap;

    return ExcludeSemantics(
      excluding: excludeFromSemantics && effectiveOnTap == null,
      child: core.StreamMessageMark(
        label: Text(label),
        highlighted: true,
        separator: separator,
        onTap: effectiveOnTap,
      ),
    );
  }
}
