import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/reaction_bubble.dart';
import 'package:stream_chat_flutter/src/reaction_picker.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/user_avatar.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'extension.dart';
import 'message_widget.dart';
import 'stream_chat_theme.dart';

class MessageReactionsModal extends StatelessWidget {
  final Widget Function(BuildContext, Message) editMessageInputBuilder;
  final void Function(Message) onThreadTap;
  final Message message;
  final MessageTheme messageTheme;
  final bool reverse;
  final bool showReactions;
  final DisplayWidget showUserAvatar;
  final ShapeBorder messageShape;
  final ShapeBorder attachmentShape;
  final void Function(User) onUserAvatarTap;
  final BorderRadius attachmentBorderRadiusGeometry;

  const MessageReactionsModal({
    Key key,
    @required this.message,
    @required this.messageTheme,
    this.showReactions = true,
    this.onThreadTap,
    this.editMessageInputBuilder,
    this.messageShape,
    this.attachmentShape,
    this.reverse = false,
    this.showUserAvatar = DisplayWidget.show,
    this.onUserAvatarTap,
    this.attachmentBorderRadiusGeometry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = StreamChat.of(context).user;

    final roughMaxSize = 2 * size.width / 3;
    var messageTextLength = message.text.length;
    if (message.quotedMessage != null) {
      var quotedMessageLength = message.quotedMessage.text.length + 40;
      if (message.quotedMessage.attachments?.isNotEmpty == true) {
        quotedMessageLength += 40;
      }
      if (quotedMessageLength > messageTextLength) {
        messageTextLength = quotedMessageLength;
      }
    }
    final roughSentenceSize =
        messageTextLength * messageTheme.messageText.fontSize * 1.2;
    final divFactor = message.attachments?.isNotEmpty == true
        ? 1
        : (roughSentenceSize == 0 ? 1 : (roughSentenceSize / roughMaxSize));

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOutBack,
      builder: (context, val, snapshot) {
        final hasFileAttachment =
            message.attachments?.any((it) => it.type == 'file') == true;
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
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          if (showReactions &&
                              (message.status == MessageSendingStatus.sent ||
                                  message.status == null))
                            Align(
                              alignment: Alignment(
                                  user.id == message.user.id
                                      ? (divFactor > 1.0
                                          ? 0.0
                                          : (1.0 - divFactor))
                                      : (divFactor > 1.0
                                          ? 0.0
                                          : -(1.0 - divFactor)),
                                  0.0),
                              child: ReactionPicker(
                                message: message,
                                messageTheme: messageTheme,
                              ),
                            ),
                          const SizedBox(height: 8),
                          IgnorePointer(
                            child: MessageWidget(
                              key: Key('MessageWidget'),
                              reverse: reverse,
                              message: message.copyWith(
                                text: message.text.length > 200
                                    ? '${message.text.substring(0, 200)}...'
                                    : message.text,
                              ),
                              messageTheme: messageTheme,
                              showReactions: false,
                              showUsername: false,
                              showUserAvatar: showUserAvatar,
                              showThreadReplyIndicator: false,
                              showTimestamp: false,
                              translateUserAvatar: false,
                              showSendingIndicator: false,
                              shape: messageShape,
                              attachmentShape: attachmentShape,
                              padding: const EdgeInsets.all(0),
                              attachmentBorderRadiusGeometry:
                                  attachmentBorderRadiusGeometry,
                              attachmentPadding: EdgeInsets.all(
                                hasFileAttachment ? 4 : 2,
                              ),
                              showInChannelIndicator: false,
                              textPadding: EdgeInsets.symmetric(
                                vertical: 8.0,
                                horizontal: message.text.isOnlyEmoji ? 0 : 16.0,
                              ),
                              showReactionPickerIndicator: showReactions &&
                                  (message.status ==
                                          MessageSendingStatus.sent ||
                                      message.status == null),
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
    return Card(
      color: StreamChatTheme.of(context).colorTheme.white,
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
              style: StreamChatTheme.of(context).textTheme.headlineBold,
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.start,
                  children: message.latestReactions
                      .map((e) => _buildReaction(
                            e,
                            currentUser,
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
    final isCurrentUser = reaction.user.id == currentUser.id;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(
        64,
        98,
      )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              UserAvatar(
                onTap: onUserAvatarTap,
                user: reaction.user,
                constraints: BoxConstraints.tightFor(
                  height: 64,
                  width: 64,
                ),
                onlineIndicatorConstraints: BoxConstraints.tightFor(
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
                    borderColor: messageTheme.reactionsBorderColor,
                    backgroundColor: messageTheme.reactionsBackgroundColor,
                    maskColor: StreamChatTheme.of(context).colorTheme.white,
                    tailCirclesSpacing: 1,
                    highlightOwnReactions: false,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            reaction.user.name.split(' ')[0],
            style: StreamChatTheme.of(context).textTheme.footnoteBold,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
