import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// ignore: public_member_api_docs
class ParentMessageWidget extends StatelessWidget {
  // ignore: public_member_api_docs
  const ParentMessageWidget({
    Key? key,
    this.parentMessageBuilder,
    required this.parentMessage,
    this.onMessageSwiped,
    this.onMessageTap,
    required this.pinPermissions,
  }) : super(key: key);

  // ignore: public_member_api_docs
  final ParentMessageBuilder? parentMessageBuilder;

  // ignore: public_member_api_docs
  final Message parentMessage;

  // ignore: public_member_api_docs
  final OnMessageSwiped? onMessageSwiped;

  // ignore: public_member_api_docs
  final OnMessageTap? onMessageTap;

  // ignore: public_member_api_docs
  final List<String> pinPermissions;

  @override
  Widget build(BuildContext context) {
    final isMyMessage =
        parentMessage.user!.id == StreamChat.of(context).currentUser!.id;
    final isOnlyEmoji = parentMessage.text?.isOnlyEmoji ?? false;
    final currentUser = StreamChat.of(context).currentUser;
    final members = StreamChannel.of(context).channel.state?.members ?? [];
    final currentUserMember =
        members.firstWhereOrNull((e) => e.user!.id == currentUser!.id);
    final _streamTheme = StreamChatTheme.of(context);

    final defaultMessageWidget = StreamMessageWidget(
      showReplyMessage: false,
      showResendMessage: false,
      showThreadReplyMessage: false,
      showCopyMessage: false,
      showDeleteMessage: false,
      showEditMessage: false,
      message: parentMessage,
      reverse: isMyMessage,
      showUsername: !isMyMessage,
      padding: const EdgeInsets.all(8),
      showSendingIndicator: false,
      borderRadiusGeometry: BorderRadius.only(
        topLeft: const Radius.circular(16),
        bottomLeft:
            isMyMessage ? const Radius.circular(16) : const Radius.circular(2),
        topRight: const Radius.circular(16),
        bottomRight:
            isMyMessage ? const Radius.circular(2) : const Radius.circular(16),
      ),
      textPadding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: isOnlyEmoji ? 0 : 16.0,
      ),
      borderSide: isMyMessage || isOnlyEmoji ? BorderSide.none : null,
      showUserAvatar: isMyMessage ? DisplayWidget.gone : DisplayWidget.show,
      messageTheme: isMyMessage
          ? _streamTheme.ownMessageTheme
          : _streamTheme.otherMessageTheme,
      onReturnAction: (action) {
        switch (action) {
          case ReturnActionType.none:
            break;
          case ReturnActionType.reply:
            FocusScope.of(context).unfocus();
            onMessageSwiped?.call(parentMessage);
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

    if (parentMessageBuilder != null) {
      return parentMessageBuilder!
          .call(context, parentMessage, defaultMessageWidget);
    }

    return defaultMessageWidget;
  }
}
