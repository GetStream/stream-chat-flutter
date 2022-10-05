import 'package:ezanimation/ezanimation.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template contextMenuReactionPicker}
/// Allows the user to select reactions to a message on desktop & web via
/// context menu.
///
/// This differs slightly from [StreamReactionPicker] in order to match our
/// design spec.
///
/// Used by the `_buildContextMenu()` function found in `message_widget.dart`.
/// It is not recommended to use this widget directly.
/// {@endtemplate}
class ContextMenuReactionPicker extends StatefulWidget {
  /// {@macro contextMenuReactionPicker}
  const ContextMenuReactionPicker({
    super.key,
    required this.message,
  });

  /// The message to react to.
  final Message message;

  @override
  State<ContextMenuReactionPicker> createState() =>
      _ContextMenuReactionPickerState();
}

class _ContextMenuReactionPickerState extends State<ContextMenuReactionPicker>
    with TickerProviderStateMixin {
  List<EzAnimation> animations = [];

  Future<void> triggerAnimations() async {
    for (final a in animations) {
      a.start();
      await Future.delayed(const Duration(milliseconds: 100));
    }
  }

  Future<void> pop() async {
    for (final a in animations) {
      a.stop();
    }
    Navigator.of(context).pop();
  }

  /// Add a reaction to the message
  void sendReaction(BuildContext context, String reactionType) {
    StreamChannel.of(context).channel.sendReaction(
          widget.message,
          reactionType,
          enforceUnique:
              StreamChatConfiguration.of(context).enforceUniqueReactions,
        );
    pop();
  }

  /// Remove a reaction from the message
  void removeReaction(BuildContext context, Reaction reaction) {
    StreamChannel.of(context).channel.deleteReaction(widget.message, reaction);
    pop();
  }

  @override
  void dispose() {
    for (final a in animations) {
      a.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reactionIcons = StreamChatConfiguration.of(context).reactionIcons;

    if (animations.isEmpty && reactionIcons.isNotEmpty) {
      reactionIcons.forEach((element) {
        animations.add(
          EzAnimation.tween(
            Tween(begin: 0.0, end: 1.0),
            const Duration(milliseconds: 250),
            curve: Curves.easeInOutBack,
          ),
        );
      });

      triggerAnimations();
    }

    final child = Material(
      color: StreamChatTheme.of(context).messageListViewTheme.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      //clipBehavior: Clip.hardEdge,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          mainAxisSize: MainAxisSize.min,
          children: reactionIcons
              .map<Widget>((reactionIcon) {
                final ownReactionIndex =
                    widget.message.ownReactions?.indexWhere(
                          (reaction) => reaction.type == reactionIcon.type,
                        ) ??
                        -1;
                final index = reactionIcons.indexOf(reactionIcon);

                final child = reactionIcon.builder(
                  context,
                  ownReactionIndex != -1,
                  24,
                );

                return ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(
                    height: 24,
                    width: 24,
                  ),
                  child: RawMaterialButton(
                    elevation: 0,
                    shape: ContinuousRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    constraints: const BoxConstraints.tightFor(
                      height: 24,
                      width: 24,
                    ),
                    onPressed: () {
                      if (ownReactionIndex != -1) {
                        removeReaction(
                          context,
                          widget.message.ownReactions![ownReactionIndex],
                        );
                      } else {
                        sendReaction(
                          context,
                          reactionIcon.type,
                        );
                      }
                    },
                    child: AnimatedBuilder(
                      animation: animations[index],
                      builder: (context, child) => Transform.scale(
                        scale: animations[index].value,
                        child: child,
                      ),
                      child: child,
                    ),
                  ),
                );
              })
              .insertBetween(
                const SizedBox(
                  width: 16,
                ),
              )
              .toList(),
        ),
      ),
    );

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeInOutBack,
      duration: const Duration(milliseconds: 500),
      builder: (context, val, widget) => Transform.scale(
        scale: val,
        child: widget,
      ),
      child: child,
    );
  }
}
