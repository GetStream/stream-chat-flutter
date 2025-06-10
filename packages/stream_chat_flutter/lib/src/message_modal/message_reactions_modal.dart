import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/src/reactions/reaction_bubble_overlay.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamMessageReactionsModal}
/// A modal that displays message reactions and allows users to add reactions.
///
/// This modal contains:
/// 1. A reaction picker (optional) that appears at the top
/// 2. The original message widget
/// 3. A display of all current reactions with user avatars
///
/// The modal uses [StreamMessageModal] as its base layout and customizes
/// both the header and content sections to display reaction-specific
/// information.
/// {@endtemplate}
class StreamMessageReactionsModal extends StatelessWidget {
  /// {@macro streamMessageReactionsModal}
  const StreamMessageReactionsModal({
    super.key,
    required this.message,
    required this.messageWidget,
    this.reverse = false,
    this.showReactionPicker = true,
    this.reactionPickerBuilder = StreamReactionPicker.builder,
    this.onReactionPicked,
    this.onUserAvatarTap,
  });

  /// The message for which to display and manage reactions.
  final Message message;

  /// The original message widget that will be displayed in the modal.
  final Widget messageWidget;

  /// Whether the message should be displayed in reverse direction.
  ///
  /// This affects how the modal and reactions are displayed and aligned.
  /// Set to `true` for right-aligned messages (typically the current user's).
  /// Set to `false` for left-aligned messages (typically other users').
  ///
  /// Defaults to `false`.
  final bool reverse;

  /// Controls whether to show the reaction picker at the top of the modal.
  ///
  /// When `true`, users can add reactions directly from the modal.
  /// When `false`, the reaction picker is hidden.
  final bool showReactionPicker;

  /// {@macro reactionPickerBuilder}
  final ReactionPickerBuilder reactionPickerBuilder;

  /// Callback triggered when a user adds or toggles a reaction.
  ///
  /// Provides the selected [Reaction] object to the callback.
  final OnMessageActionTap<SelectReaction>? onReactionPicked;

  /// Callback triggered when a user avatar is tapped in the reactions list.
  ///
  /// Provides the [User] object associated with the tapped avatar.
  final void Function(User)? onUserAvatarTap;

  @override
  Widget build(BuildContext context) {
    final theme = StreamChatTheme.of(context);

    final alignment = switch (reverse) {
      true => AlignmentDirectional.centerEnd,
      false => AlignmentDirectional.centerStart,
    };

    final onReactionPicked = switch (this.onReactionPicked) {
      null => null,
      final onPicked => (reaction) {
          return onPicked.call(
            SelectReaction(message: message, reaction: reaction),
          );
        },
    };

    return StreamMessageModal(
      spacing: 4,
      alignment: alignment,
      headerBuilder: (context) => ReactionBubbleOverlay(
        config: ReactionBubbleConfig(
          maskWidth: 0,
          borderWidth: 0,
          fillColor: theme.colorTheme.barsBg,
        ),
        anchor: ReactionBubbleAnchor(
          offset: const Offset(0, -8),
          follower: AlignmentDirectional.bottomCenter,
          target: AlignmentDirectional(reverse ? -1 : 1, -1),
        ),
        reaction: reactionPickerBuilder.call(
          context,
          message,
          onReactionPicked,
        ),
        child: IgnorePointer(child: messageWidget),
      ),
      contentBuilder: (context) {
        final reactions = message.latestReactions;
        final hasReactions = reactions != null && reactions.isNotEmpty;
        if (!hasReactions) return const Empty();

        return FractionallySizedBox(
          widthFactor: 0.78,
          child: StreamUserReactions(
            message: message,
            onUserAvatarTap: onUserAvatarTap,
          ),
        );
      },
    );
  }
}
