import 'package:ezanimation/ezanimation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

import '../stream_chat_flutter.dart';

/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/reaction_picker.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/screenshots/reaction_picker_paint.png)
///
/// It shows a reaction picker
///
/// Usually you don't use this widget as it's one of the default widgets used by [MessageWidget.onMessageActions].

class ReactionPicker extends StatefulWidget {
  const ReactionPicker({
    Key key,
    @required this.message,
    @required this.messageTheme,
  }) : super(key: key);

  final Message message;
  final MessageTheme messageTheme;

  @override
  _ReactionPickerState createState() => _ReactionPickerState();
}

class _ReactionPickerState extends State<ReactionPicker> {
  List<EzAnimation> animations = [];

  @override
  Widget build(BuildContext context) {
    final reactionIcons = StreamChatTheme.of(context).reactionIcons;

    if (animations.isEmpty && reactionIcons.isNotEmpty) {
      reactionIcons.forEach((element) {
        animations.add(
          EzAnimation.sequence([
            SequenceItem(0.0, 1.4),
            SequenceItem(1.4, 1.0),
          ], Duration(milliseconds: 500)),
        );
      });

      triggerAnimations();
    }

    return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeInOutExpo,
        duration: Duration(milliseconds: 500),
        builder: (context, val, wid) {
          return Transform.scale(
            scale: val,
            child: Material(
              color: widget.messageTheme.reactionsBackgroundColor,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: reactionIcons.map((reactionIcon) {
                  final ownReactionIndex = widget.message.ownReactions
                          ?.indexWhere((reaction) =>
                              reaction.type == reactionIcon.type) ??
                      -1;
                  var index = reactionIcons.indexOf(reactionIcon);

                  return IconButton(
                    iconSize: 24,
                    icon: AnimatedBuilder(
                        animation: animations[index],
                        builder: (context, val) {
                          return Transform(
                            transform: Matrix4.identity()
                              ..scale(animations[index].value,
                                  animations[index].value)
                              ..rotateZ(1.0 - animations[index].value),
                            child: Icon(
                              reactionIcon.iconData,
                              size: animations[index].value * 24.0,
                              color: ownReactionIndex != -1
                                  ? StreamChatTheme.of(context).accentColor
                                  : Theme.of(context)
                                      .iconTheme
                                      .color
                                      .withOpacity(.5),
                            ),
                          );
                        }),
                    onPressed: () {
                      if (ownReactionIndex != -1) {
                        removeReaction(
                          context,
                          widget.message.ownReactions[ownReactionIndex],
                        );
                      } else {
                        sendReaction(
                          context,
                          reactionIcon.type,
                        );
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          );
        });
  }

  void triggerAnimations() async {
    for (var a in animations) {
      a.start();
      await Future.delayed(Duration(milliseconds: 100));
    }
  }

  void pop() async {
    for (var a in animations) {
      a.stop();
      a.dispose();
    }
    Navigator.of(context).pop();
  }

  /// Add a reaction to the message
  void sendReaction(BuildContext context, String reactionType) {
    StreamChannel.of(context)
        .channel
        .sendReaction(widget.message, reactionType);
    pop();
  }

  /// Remove a reaction from the message
  void removeReaction(BuildContext context, Reaction reaction) {
    StreamChannel.of(context).channel.deleteReaction(widget.message, reaction);
    pop();
  }
}
