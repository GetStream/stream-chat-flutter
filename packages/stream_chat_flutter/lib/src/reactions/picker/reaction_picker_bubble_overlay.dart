import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/reactions/picker/reaction_picker.dart';
import 'package:stream_chat_flutter/src/reactions/reaction_bubble_overlay.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template reactionPickerBubbleOverlay}
/// A widget that displays a reaction picker bubble overlay attached to a
/// [child] widget. Typically used with the [MessageWidget] as the child.
///
/// It positions the reaction picker relative to the provided [child] widget,
/// using the given [anchorOffset] and [childSizeDelta] for fine-tuned placement
/// {@endtemplate}
class ReactionPickerBubbleOverlay extends StatelessWidget {
  /// {@macro reactionPickerBubbleOverlay}
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

  /// Whether the overlay should be visible.
  final bool visible;

  /// Whether to reverse the alignment of the overlay.
  final bool reverse;

  /// The widget to which the overlay is anchored.
  final Widget child;

  /// The message to attach the reaction to.
  final Message message;

  /// Callback triggered when a reaction is picked.
  final OnReactionPicked? onReactionPicked;

  /// Builder for the reaction picker widget.
  final ReactionPickerBuilder reactionPickerBuilder;

  /// The offset to apply to the anchor position.
  final Offset anchorOffset;

  /// The additional size delta to apply to the child widget for positioning.
  final Offset childSizeDelta;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);
    final colorTheme = theme.colorTheme;

    return ReactionBubbleOverlay(
      visible: visible,
      childSizeDelta: childSizeDelta,
      config: ReactionBubbleConfig(
        fillColor: colorTheme.barsBg,
        maskColor: Colors.transparent,
        borderColor: Colors.transparent,
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
