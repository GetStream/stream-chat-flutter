import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reactions_align.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reactions_card.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template streamMessageReactionsModal}
/// Modal widget for displaying message reactions
/// {@endtemplate}
class StreamMessageReactionsModal extends StatelessWidget {
  /// {@macro streamMessageReactionsModal}
  const StreamMessageReactionsModal({
    super.key,
    required this.message,
    required this.messageWidget,
    required this.messageTheme,
    this.showReactions,
    this.reverse = false,
    this.onUserAvatarTap,
  });

  /// Widget that shows the message
  final Widget messageWidget;

  /// Message to display reactions of
  final Message message;

  /// [StreamMessageThemeData] to apply to [message]
  final StreamMessageThemeData messageTheme;

  /// {@macro reverse}
  final bool reverse;

  /// {@macro showReactions}
  final bool? showReactions;

  /// {@macro onUserAvatarTap}
  final void Function(User)? onUserAvatarTap;

  @override
  Widget build(BuildContext context) {
    final user = StreamChat.of(context).currentUser;
    final _userPermissions = StreamChannel.of(context).channel.ownCapabilities;
    final orientation = MediaQuery.of(context).orientation;

    final hasReactionPermission =
        _userPermissions.contains(PermissionType.sendReaction);
    final fontSize = messageTheme.messageTextStyle?.fontSize;

    final child = Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if ((showReactions ?? hasReactionPermission) &&
                  message.state.isCompleted)
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Align(
                      alignment: Alignment(
                        calculateReactionsHorizontalAlignment(
                          user,
                          message,
                          constraints,
                          fontSize,
                          orientation,
                        ),
                        0,
                      ),
                      child: StreamReactionPicker(
                        message: message,
                      ),
                    );
                  },
                ),
              const SizedBox(height: 10),
              IgnorePointer(
                child: messageWidget,
              ),
              if (message.latestReactions?.isNotEmpty == true) ...[
                const SizedBox(height: 8),
                ReactionsCard(
                  currentUser: user!,
                  message: message,
                  messageTheme: messageTheme,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => Navigator.of(context).maybePop(),
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 10,
                sigmaY: 10,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: StreamChatTheme.of(context).colorTheme.overlay,
                ),
              ),
            ),
          ),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOutBack,
            builder: (context, val, widget) => Transform.scale(
              scale: val,
              child: widget,
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
