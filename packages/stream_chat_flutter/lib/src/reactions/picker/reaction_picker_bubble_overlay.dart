import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/reactions/picker/reaction_picker.dart';
import 'package:stream_chat_flutter/src/reactions/picker/reaction_picker_icon_list.dart';
import 'package:stream_chat_flutter/src/reactions/reaction_bubble_overlay.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

class ReactionPickerBubbleOverlay extends StatelessWidget {
  const ReactionPickerBubbleOverlay({
    super.key,
    required this.message,
    required this.child,
    this.onReactionPicked,
    this.visible = true,
    this.reverse = false,
    this.anchorOffset = Offset.zero,
    this.childSizeDelta = Offset.zero,
    this.reactionPickerBuilder = StreamReactionPicker.builder,
  });

  final bool visible;
  final bool reverse;
  final Widget child;

  /// Message to attach the reaction to.
  final Message message;

  /// {@macro onReactionPressed}
  final OnReactionPicked? onReactionPicked;

  /// {@macro reactionPickerBuilder}
  final ReactionPickerBuilder reactionPickerBuilder;

  final Offset anchorOffset;

  final Offset childSizeDelta;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    return ReactionBubbleOverlay(
      visible: visible,
      childSizeDelta: childSizeDelta,
      config: ReactionBubbleConfig(
        maskWidth: 0,
        borderWidth: 0,
        fillColor: colorTheme.barsBg,
      ),
      anchor: ReactionBubbleAnchor(
        offset: anchorOffset,
        follower: AlignmentDirectional.bottomCenter,
        target: AlignmentDirectional(reverse ? -1 : 1, -1),
      ),
      reaction: reactionPickerBuilder.call(context, message, onReactionPicked),
      child: child,
    );
  }
}
