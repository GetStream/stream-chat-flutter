import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/my_reaction_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamReactionPicker}
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/reaction_picker.png)
/// ![screenshot](https://raw.githubusercontent.com/GetStream/stream-chat-flutter/master/packages/stream_chat_flutter/screenshots/reaction_picker_paint.png)
///
/// Allows the user to select reactions to a message on mobile.
///
/// It is not recommended to use this widget directly as it's one of the
/// default widgets used by [StreamMessageWidget.onMessageActions].
/// {@endtemplate}
class StreamReactionPicker extends StatelessWidget {
  /// {@macro streamReactionPicker}
  const StreamReactionPicker({
    super.key,
    required this.message,
    this.onReactionPicked,
  });

  /// Message to attach the reaction to
  final Message message;

  /// {@macro onReactionPressed}
  final OnReactionPicked? onReactionPicked;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    final reactionIcons = StreamChatConfiguration.of(context).reactionIcons;

    final child = DecoratedBox(
      decoration: BoxDecoration(
        color: chatThemeData.colorTheme.barsBg,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: ReactionPickerIconList(
          message: message,
          reactionIcons: reactionIcons,
          onReactionPicked: onReactionPicked,
        ),
      ),
    );

    return child;
  }
}
