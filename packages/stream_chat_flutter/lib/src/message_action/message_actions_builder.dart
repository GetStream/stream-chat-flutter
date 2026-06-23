import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_action/message_action.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template streamMessageActionsBuilder}
/// A utility class that provides a builder for message actions
/// which can be reused across mobile platforms.
/// {@endtemplate}
class StreamMessageActionsBuilder {
  /// Private constructor to prevent instantiation
  StreamMessageActionsBuilder._();

  /// Returns a list of message actions for the "bounced with error" state.
  ///
  /// This method builds a list of [StreamContextMenuAction]s that are
  /// applicable to
  /// the given [message] when it is in the "bounced with error" state.
  ///
  /// The actions include options to retry sending the message, edit or delete
  /// the message.
  static List<StreamContextMenuAction<MessageAction>> buildBouncedErrorActions({
    required BuildContext context,
    required Message message,
  }) {
    // If the message is not bounced with an error, we don't show any actions.
    if (!message.isBouncedWithError) return [];

    final icons = context.streamIcons;

    return <StreamContextMenuAction<MessageAction>>[
      StreamContextMenuAction<MessageAction>(
        value: ResendMessage(message: message),
        label: Text(context.translations.sendAnywayLabel),
        leading: Icon(
          icons.send,
          color: context.streamColorScheme.accentPrimary,
        ),
      ),
      StreamContextMenuAction<MessageAction>(
        value: EditMessage(message: message),
        label: Text(context.translations.editMessageLabel),
        leading: Icon(icons.edit),
      ),
      StreamContextMenuAction<MessageAction>.destructive(
        value: HardDeleteMessage(message: message),
        label: Text(context.translations.deleteMessageLabel),
        leading: Icon(icons.delete),
      ),
    ];
  }

  /// Returns a list of message actions based on the provided message and
  /// channel capabilities.
  ///
  /// This method builds a list of [StreamContextMenuAction]s that are
  /// applicable to
  /// the given [message] in the [channel], considering the permissions of the
  /// [currentUser] and the current state of the message.
  static List<StreamContextMenuAction<MessageAction>> buildActions({
    required BuildContext context,
    required Message message,
    required Channel channel,
    OwnUser? currentUser,
  }) {
    final messageState = message.state;

    // If the message is deleted, we don't show any actions.
    if (messageState.isDeleted) return [];

    final icons = context.streamIcons;

    if (messageState.isFailed) {
      return [
        if (messageState.isSendingFailed || messageState.isUpdatingFailed) ...[
          StreamContextMenuAction(
            value: ResendMessage(message: message),
            leading: Icon(icons.send),
            label: Text(
              context.translations.toggleResendOrResendEditedMessage(
                isUpdateFailed: messageState.isUpdatingFailed,
              ),
            ),
          ),
          if (messageState.isSendingFailed)
            StreamContextMenuAction.destructive(
              value: HardDeleteMessage(message: message),
              leading: Icon(icons.delete),
              label: Text(
                context.translations.toggleDeleteRetryDeleteMessageText(
                  isDeleteFailed: false,
                ),
              ),
            ),
        ],
        if (message.state.isDeletingFailed)
          StreamContextMenuAction.destructive(
            value: ResendMessage(message: message),
            leading: Icon(icons.delete),
            label: Text(
              context.translations.toggleDeleteRetryDeleteMessageText(
                isDeleteFailed: true,
              ),
            ),
          ),
      ];
    }

    final listKind = StreamMessageLayout.listKindOf(context);

    final isSentByCurrentUser = message.user?.id == currentUser?.id;
    final isInThreadView = listKind == .thread;
    final isThreadMessage = message.parentId != null;
    final isParentMessage = (message.replyCount ?? 0) > 0;
    final canShowInChannel = message.showInChannel ?? true;
    final isPrivateMessage = message.hasRestrictedVisibility;
    final repliesEnabled = channel.config?.replies ?? true;
    final canSendReply = channel.canSendReply;
    final canPinMessage = channel.canPinMessage;
    final canQuoteMessage = channel.canQuoteMessage;
    final canReceiveReadEvents = channel.canUseReadReceipts;
    final canUpdateAnyMessage = channel.canUpdateAnyMessage;
    final canUpdateOwnMessage = channel.canUpdateOwnMessage;
    final canDeleteAnyMessage = channel.canDeleteAnyMessage;
    final canDeleteOwnMessage = channel.canDeleteOwnMessage;
    final containsPoll = message.poll != null;
    final containsGiphy = message.attachments.any(
      (attachment) => attachment.type == AttachmentType.giphy,
    );

    final messageActions = <StreamContextMenuAction<MessageAction>>[];

    if (canQuoteMessage) {
      messageActions.add(
        StreamContextMenuAction(
          value: QuotedReply(message: message),
          label: Text(context.translations.replyLabel),
          leading: Icon(icons.reply),
        ),
      );
    }

    // Thread reply action is only available for parent messages that are not in a
    // thread view, as replying in a thread that is already being viewed doesn't make sense.
    // Additionally, the channel needs to support sending replies.
    if (canSendReply && repliesEnabled && !isThreadMessage && !isInThreadView) {
      messageActions.add(
        StreamContextMenuAction(
          value: ThreadReply(message: message),
          label: Text(context.translations.threadReplyLabel),
          leading: Icon(icons.thread),
        ),
      );
    }

    // Pinning a private message is not allowed, simply because pinning a
    // message is meant to bring attention to that message, that is not possible
    // with a message that is only visible to a subset of users.
    if (canPinMessage && !isPrivateMessage) {
      final isPinned = message.pinned;
      final label = context.translations.togglePinUnpinText;

      final action = switch (isPinned) {
        true => UnpinMessage(message: message),
        false => PinMessage(message: message),
      };

      messageActions.add(
        StreamContextMenuAction(
          value: action,
          label: Text(label.call(pinned: isPinned)),
          leading: Icon(icons.pin),
        ),
      );
    }

    if (message.text case final text? when text.isNotEmpty) {
      messageActions.add(
        StreamContextMenuAction(
          value: CopyMessage(message: message),
          label: Text(context.translations.copyMessageLabel),
          leading: Icon(icons.copy),
        ),
      );
    }

    // Mark unread action is only available for other users' messages.
    if (canReceiveReadEvents && !isSentByCurrentUser) {
      StreamContextMenuAction<MessageAction> markUnreadAction() {
        return StreamContextMenuAction(
          value: MarkUnread(message: message),
          label: Text(context.translations.markAsUnreadLabel),
          leading: Icon(icons.notification),
        );
      }

      // If message is a parent message, it can be marked unread independent of
      // other logic.
      if (isParentMessage) {
        messageActions.add(markUnreadAction());
      }
      // If the message is in the channel view, only other user messages can be
      // marked unread.
      else if (!isThreadMessage || canShowInChannel) {
        messageActions.add(markUnreadAction());
      }
    }

    if (!containsPoll && !containsGiphy) {
      if (canUpdateAnyMessage || (canUpdateOwnMessage && isSentByCurrentUser)) {
        messageActions.add(
          StreamContextMenuAction(
            value: EditMessage(message: message),
            label: Text(context.translations.editMessageLabel),
            leading: Icon(icons.edit),
          ),
        );
      }
    }

    if (!isSentByCurrentUser) {
      messageActions.add(
        StreamContextMenuAction(
          value: FlagMessage(message: message),
          label: Text(context.translations.flagMessageLabel),
          leading: Icon(icons.flag),
        ),
      );
    }

    if (message.user case final messageUser? when channel.config?.mutes == true && !isSentByCurrentUser) {
      final mutedUsers = currentUser?.mutes.map((mute) => mute.target.id);
      final isMuted = mutedUsers?.contains(messageUser.id) ?? false;
      final label = context.translations.toggleMuteUnmuteUserText;

      final action = switch (isMuted) {
        true => UnmuteUser(message: message, user: messageUser),
        false => MuteUser(message: message, user: messageUser),
      };

      messageActions.add(
        StreamContextMenuAction(
          value: action,
          label: Text(label.call(isMuted: isMuted)),
          leading: Icon(icons.mute),
        ),
      );
    }

    if (message.user case final messageUser? when !isSentByCurrentUser) {
      final isBlocked = currentUser?.blockedUserIds.contains(messageUser.id) ?? false;
      final label = context.translations.toggleBlockUnblockUserText;

      final action = switch (isBlocked) {
        true => UnblockUser(message: message, user: messageUser),
        false => BlockUser(message: message, user: messageUser),
      };

      messageActions.add(
        StreamContextMenuAction.destructive(
          value: action,
          label: Text(label.call(isBlocked: isBlocked)),
          leading: Icon(isBlocked ? icons.userCheck : icons.noSign),
        ),
      );
    }

    if (canDeleteAnyMessage || (canDeleteOwnMessage && isSentByCurrentUser)) {
      final label = context.translations.toggleDeleteRetryDeleteMessageText;

      messageActions.add(
        StreamContextMenuAction.destructive(
          value: DeleteMessage(message: message),
          leading: Icon(icons.delete),
          label: Text(label.call(isDeleteFailed: false)),
        ),
      );
    }

    return messageActions;
  }
}
