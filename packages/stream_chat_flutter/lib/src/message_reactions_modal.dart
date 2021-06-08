import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/src/reaction_picker.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Modal widget for displaying message reactions
class MessageReactionsModal extends StatelessWidget {
  /// Constructor for creating a [MessageReactionsModal] reactions
  const MessageReactionsModal({
    Key? key,
    required this.message,
    required this.messageTheme,
    this.showReactions = true,
    this.messageShape,
    this.attachmentShape,
    this.reverse = false,
    this.showUserAvatar = DisplayWidget.show,
    this.onUserAvatarTap,
    this.attachmentBorderRadiusGeometry,
    this.textBuilder,
  }) : super(key: key);

  /// Message to display reactions of
  final Message message;

  /// [MessageTheme] to apply to [message]
  final MessageTheme messageTheme;

  /// Flag to reverse message
  final bool reverse;

  /// Flag to show reactions on message
  final bool showReactions;

  /// Enum to change user avatar config
  final DisplayWidget showUserAvatar;

  /// [ShapeBorder] to apply to message
  final ShapeBorder? messageShape;

  /// [ShapeBorder] to apply to attachment
  final ShapeBorder? attachmentShape;

  /// Callback when user avatar is tapped
  final void Function(User)? onUserAvatarTap;

  /// [BorderRadius] to apply to attachments
  final BorderRadius? attachmentBorderRadiusGeometry;

  /// Customize the MessageWidget textBuilder
  final Widget Function(BuildContext context, Message message)? textBuilder;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = StreamChat.of(context).user;

    final roughMaxSize = 2 * size.width / 3;
    var messageTextLength = message.text!.length;
    if (message.quotedMessage != null) {
      var quotedMessageLength = message.quotedMessage!.text!.length + 40;
      if (message.quotedMessage!.attachments.isNotEmpty == true) {
        quotedMessageLength += 40;
      }
      if (quotedMessageLength > messageTextLength) {
        messageTextLength = quotedMessageLength;
      }
    }
    final roughSentenceSize =
        messageTextLength * (messageTheme.messageText?.fontSize ?? 1) * 1.2;
    final divFactor = message.attachments.isNotEmpty == true
        ? 1
        : (roughSentenceSize == 0 ? 1 : (roughSentenceSize / roughMaxSize));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOutBack,
      builder: (context, val, snapshot) {
        final hasFileAttachment =
            message.attachments.any((it) => it.type == 'file') == true;
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => Navigator.maybePop(context),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                  child: Container(
                    color: StreamChatTheme.of(context).colorTheme.overlay,
                  ),
                ),
              ),
              Transform.scale(
                scale: val,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (showReactions &&
                              (message.status == MessageSendingStatus.sent))
                            Align(
                              alignment: Alignment(
                                  user!.id == message.user!.id
                                      ? (divFactor >= 1.0
                                          ? -0.2
                                          : (1.2 - divFactor))
                                      : (divFactor >= 1.0
                                          ? 0.2
                                          : -(1.2 - divFactor)),
                                  0),
                              child: ReactionPicker(
                                message: message,
                              ),
                            ),
                          const SizedBox(height: 8),
                          IgnorePointer(
                            child: MessageWidget(
                              key: const Key('MessageWidget'),
                              reverse: reverse,
                              message: message.copyWith(
                                text: message.text!.length > 200
                                    ? '${message.text!.substring(0, 200)}...'
                                    : message.text,
                              ),
                              messageTheme: messageTheme,
                              showReactions: false,
                              showUsername: false,
                              showUserAvatar: showUserAvatar,
                              showTimestamp: false,
                              translateUserAvatar: false,
                              showSendingIndicator: false,
                              shape: messageShape,
                              attachmentShape: attachmentShape,
                              padding: const EdgeInsets.all(0),
                              attachmentBorderRadiusGeometry:
                                  attachmentBorderRadiusGeometry
                                      ?.mirrorBorderIfReversed(
                                          reverse: !reverse),
                              attachmentPadding: EdgeInsets.all(
                                hasFileAttachment ? 4 : 2,
                              ),
                              textPadding: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal:
                                    message.text!.isOnlyEmoji ? 0 : 16.0,
                              ),
                              showReactionPickerIndicator: showReactions &&
                                  (message.status == MessageSendingStatus.sent),
                              textBuilder: textBuilder,
                              showPinHighlight: false,
                            ),
                          ),
                          if (message.latestReactions?.isNotEmpty == true) ...[
                            const SizedBox(height: 8),
                            _buildReactionCard(context),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReactionCard(BuildContext context) {
    final currentUser = StreamChat.of(context).user;
    final chatThemeData = StreamChatTheme.of(context);
    return Card(
      color: chatThemeData.colorTheme.white,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Message Reactions',
              style: chatThemeData.textTheme.headlineBold,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: message.latestReactions!
                      .map((e) => _buildReaction(
                            e,
                            currentUser!,
                            context,
                          ))
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReaction(
    Reaction reaction,
    User currentUser,
    BuildContext context,
  ) {
    final isCurrentUser = reaction.user?.id == currentUser.id;
    final chatThemeData = StreamChatTheme.of(context);
    return ConstrainedBox(
      constraints: BoxConstraints.loose(const Size(
        64,
        98,
      )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              UserAvatar(
                onTap: onUserAvatarTap,
                user: reaction.user!,
                constraints: const BoxConstraints.tightFor(
                  height: 64,
                  width: 64,
                ),
                onlineIndicatorConstraints: const BoxConstraints.tightFor(
                  height: 12,
                  width: 12,
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              Positioned(
                bottom: 6,
                left: isCurrentUser ? -3 : null,
                right: isCurrentUser ? -3 : null,
                child: Align(
                  alignment:
                      reverse ? Alignment.centerRight : Alignment.centerLeft,
                  child: ReactionBubble(
                    reactions: [reaction],
                    flipTail: !reverse,
                    borderColor:
                        messageTheme.reactionsBorderColor ?? Colors.transparent,
                    backgroundColor: messageTheme.reactionsBackgroundColor ??
                        Colors.transparent,
                    maskColor: chatThemeData.colorTheme.white,
                    tailCirclesSpacing: 1,
                    highlightOwnReactions: false,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reaction.user!.name.split(' ')[0],
            style: chatThemeData.textTheme.footnoteBold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
