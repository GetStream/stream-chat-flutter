import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/mlv_utils.dart';
import 'package:stream_chat_flutter/src/misc/swipeable.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template messageBuilder}
/// Builds a message for display via [MessageListView].
///
/// Not intended for use outside of [MessageListView].
/// {@endtemplate}
class MessageBuilderWidget extends StatelessWidget {
  /// {@macro messageBuilder}
  const MessageBuilderWidget({
    Key? key,
    required this.message,
    this.systemMessageBuilder,
    this.onSystemMessageTap,
    required this.index,
    required this.messages,
    required this.isThreadConversation,
    this.scrollController,
    this.channelState,
    this.onQuotedMessageTap,
    this.onThreadTap,
    this.onMessageSwiped,
    this.onMessageTap,
    required this.pinPermissions,
    this.messageBuilder,
    required this.initialMessageHighlightComplete,
    required this.highlightInitialMessage,
    this.messageHighlightColor,
    required this.onTweenEnd,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final Message message;

  // ignore: public_member_api_docs
  final SystemMessageBuilder? systemMessageBuilder;

  // ignore: public_member_api_docs
  final OnMessageTap? onSystemMessageTap;

  // ignore: public_member_api_docs
  final int index;

  // ignore: public_member_api_docs
  final List<Message> messages;

  // ignore: public_member_api_docs
  final bool isThreadConversation;

  // ignore: public_member_api_docs
  final ItemScrollController? scrollController;

  // ignore: public_member_api_docs
  final StreamChannelState? channelState;

  // ignore: public_member_api_docs
  final OnQuotedMessageTap? onQuotedMessageTap;

  // ignore: public_member_api_docs
  final void Function(Message)? onThreadTap;

  // ignore: public_member_api_docs
  final OnMessageSwiped? onMessageSwiped;

  // ignore: public_member_api_docs
  final OnMessageTap? onMessageTap;

  // ignore: public_member_api_docs
  final List<String> pinPermissions;

  // ignore: public_member_api_docs
  final MessageBuilder? messageBuilder;

  // ignore: public_member_api_docs
  final bool initialMessageHighlightComplete;

  // ignore: public_member_api_docs
  final bool highlightInitialMessage;

  // ignore: public_member_api_docs
  final Color? messageHighlightColor;

  // ignore: public_member_api_docs
  final VoidCallback onTweenEnd;

  @override
  Widget build(BuildContext context) {
    if ((message.type == 'system' || message.type == 'error') &&
        message.text?.isNotEmpty == true) {
      return systemMessageBuilder?.call(context, message) ??
          StreamSystemMessage(
            message: message,
            onMessageTap: (message) {
              if (onSystemMessageTap != null) {
                onSystemMessageTap!(message);
              }
              FocusScope.of(context).unfocus();
            },
          );
    }

    final userId = StreamChat.of(context).currentUser!.id;
    final isMyMessage = message.user?.id == userId;
    final nextMessage = index - 1 >= 0 ? messages[index - 1] : null;
    final isNextUserSame =
        nextMessage != null && message.user!.id == nextMessage.user!.id;

    num timeDiff = 0;
    if (nextMessage != null) {
      timeDiff = Jiffy(nextMessage.createdAt.toLocal()).diff(
        message.createdAt.toLocal(),
        Units.MINUTE,
      );
    }

    final hasFileAttachment =
        message.attachments.any((it) => it.type == 'file');

    final isThreadMessage =
        message.parentId != null && message.showInChannel == true;

    final hasReplies = message.replyCount! > 0;

    final attachmentBorderRadius = hasFileAttachment ? 12.0 : 14.0;

    final showTimeStamp = (!isThreadMessage || isThreadConversation) &&
        !hasReplies &&
        (timeDiff >= 1 || !isNextUserSame);

    final showUsername = !isMyMessage &&
        (!isThreadMessage || isThreadConversation) &&
        !hasReplies &&
        (timeDiff >= 1 || !isNextUserSame);

    final showUserAvatar = isMyMessage
        ? DisplayWidget.gone
        : (timeDiff >= 1 || !isNextUserSame)
            ? DisplayWidget.show
            : DisplayWidget.hide;

    final showSendingIndicator =
        isMyMessage && (index == 0 || timeDiff >= 1 || !isNextUserSame);

    final showInChannelIndicator = !isThreadConversation && isThreadMessage;
    final showThreadReplyIndicator = !isThreadConversation && hasReplies;
    final isOnlyEmoji = message.text?.isOnlyEmoji ?? false;

    final hasUrlAttachment =
        message.attachments.any((it) => it.titleLink != null);

    final borderSide =
        isOnlyEmoji || hasUrlAttachment || (isMyMessage && !hasFileAttachment)
            ? BorderSide.none
            : null;

    final currentUser = StreamChat.of(context).currentUser;
    final members = StreamChannel.of(context).channel.state?.members ?? [];
    final currentUserMember =
        members.firstWhereOrNull((e) => e.user!.id == currentUser!.id);

    final _streamTheme = StreamChatTheme.of(context);

    Widget messageWidget = StreamMessageWidget(
      message: message,
      reverse: isMyMessage,
      showReactions: !message.isDeleted,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      showInChannelIndicator: showInChannelIndicator,
      showThreadReplyIndicator: showThreadReplyIndicator,
      showUsername: showUsername,
      showTimestamp: showTimeStamp,
      showSendingIndicator: showSendingIndicator,
      showUserAvatar: showUserAvatar,
      onQuotedMessageTap: onQuotedMessageTap,
      showEditMessage: isMyMessage,
      showDeleteMessage: isMyMessage,
      showThreadReplyMessage: !isThreadMessage,
      showFlagButton: !isMyMessage,
      borderSide: borderSide,
      onThreadTap: onThreadTap,
      attachmentBorderRadiusGeometry: BorderRadius.only(
        topLeft: Radius.circular(attachmentBorderRadius),
        bottomLeft: isMyMessage
            ? Radius.circular(attachmentBorderRadius)
            : Radius.circular(
                (timeDiff >= 1 || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage || hasFileAttachment)
                    ? 0
                    : attachmentBorderRadius,
              ),
        topRight: Radius.circular(attachmentBorderRadius),
        bottomRight: isMyMessage
            ? Radius.circular(
                (timeDiff >= 1 || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage || hasFileAttachment)
                    ? 0
                    : attachmentBorderRadius,
              )
            : Radius.circular(attachmentBorderRadius),
      ),
      attachmentPadding: EdgeInsets.all(hasFileAttachment ? 4 : 2),
      borderRadiusGeometry: BorderRadius.only(
        topLeft: const Radius.circular(16),
        bottomLeft: isMyMessage
            ? const Radius.circular(16)
            : Radius.circular(
                (timeDiff >= 1 || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage)
                    ? 0
                    : 16,
              ),
        topRight: const Radius.circular(16),
        bottomRight: isMyMessage
            ? Radius.circular(
                (timeDiff >= 1 || !isNextUserSame) &&
                        !(hasReplies || isThreadMessage)
                    ? 0
                    : 16,
              )
            : const Radius.circular(16),
      ),
      textPadding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: isOnlyEmoji ? 0 : 16.0,
      ),
      messageTheme: isMyMessage
          ? _streamTheme.ownMessageTheme
          : _streamTheme.otherMessageTheme,
      onReturnAction: (action) {
        switch (action) {
          case ReturnActionType.none:
            break;
          case ReturnActionType.reply:
            FocusScope.of(context).unfocus();
            onMessageSwiped?.call(message);
            break;
        }
      },
      onMessageTap: (message) {
        if (onMessageTap != null) {
          onMessageTap!(message);
        }
        FocusScope.of(context).unfocus();
      },
      showPinButton: currentUserMember != null &&
          pinPermissions.contains(currentUserMember.role),
    );

    if (messageBuilder != null) {
      messageWidget = messageBuilder!(
        context,
        MessageDetails(
          userId,
          message,
          messages,
          index,
        ),
        messages,
        messageWidget as StreamMessageWidget,
      );
    }

    var child = messageWidget;
    if (!message.isDeleted &&
        !message.isSystem &&
        !message.isEphemeral &&
        onMessageSwiped != null) {
      child = Container(
        decoration: const BoxDecoration(),
        clipBehavior: Clip.hardEdge,
        child: Swipeable(
          onSwipeEnd: () {
            FocusScope.of(context).unfocus();
            onMessageSwiped?.call(message);
          },
          backgroundIcon: StreamSvgIcon.reply(
            color: _streamTheme.colorTheme.accentPrimary,
          ),
          child: child,
        ),
      );
    }

    if (!initialMessageHighlightComplete &&
        highlightInitialMessage &&
        isInitialMessage(message.id, channelState)) {
      final colorTheme = _streamTheme.colorTheme;
      final highlightColor = messageHighlightColor ?? colorTheme.highlight;
      child = TweenAnimationBuilder<Color?>(
        tween: ColorTween(
          begin: highlightColor,
          end: colorTheme.barsBg.withOpacity(0),
        ),
        duration: const Duration(seconds: 3),
        onEnd: onTweenEnd,
        builder: (_, color, child) => Container(
          color: color,
          child: child,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: child,
        ),
      );
    }
    return child;
  }
}
