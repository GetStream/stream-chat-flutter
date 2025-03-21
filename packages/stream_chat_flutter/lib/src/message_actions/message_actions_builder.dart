import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/message_actions/message_action.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter/src/utils/helpers.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template onMessageActionTap}
/// Signature for a function that is called when a message action is tapped.
///
/// See also:
///   - [Message], which defines the message on which the action was performed.
///   - [StreamMessageActionType], which defines the type of message action.
/// {@endtemplate}
typedef OnMessageActionTap = void Function(Message, StreamMessageActionType);

/// {@template streamMessageActionsBuilder}
/// A utility class that provides a builder for message actions
/// which can be reused across mobile platforms.
/// {@endtemplate}
class StreamMessageActionsBuilder {
  /// Private constructor to prevent instantiation
  StreamMessageActionsBuilder._();

  //public fun canReplyToMessage(
  //     replyEnabled: Boolean,
  //     message: Message,
  //     ownCapabilities: Set<String>,
  // ): Boolean = replyEnabled && message.isSynced() && ownCapabilities.contains(ChannelCapabilities.QUOTE_MESSAGE)
  //
  // public fun canThreadReplyToMessage(
  //     threadsEnabled: Boolean,
  //     message: Message,
  //     ownCapabilities: Set<String>,
  // ): Boolean = threadsEnabled && message.isSynced() && ownCapabilities.contains(ChannelCapabilities.QUOTE_MESSAGE)
  //
  // public fun canCopyMessage(
  //     copyTextEnabled: Boolean,
  //     message: Message,
  // ): Boolean = copyTextEnabled && (message.isTextOnly() || message.hasLinks())
  //
  // public fun canEditMessage(
  //     editMessageEnabled: Boolean,
  //     currentUser: User?,
  //     message: Message,
  //     ownCapabilities: Set<String>,
  // ): Boolean = editMessageEnabled &&
  //     with(ownCapabilities) { ((message.isOwnMessage(currentUser) && canEditOwnMessage()) || canEditAnyMessage()) } &&
  //     !message.isGiphyCommand()
  //
  // public fun canDeleteMessage(
  //     deleteMessageEnabled: Boolean,
  //     currentUser: User?,
  //     message: Message,
  //     ownCapabilities: Set<String>,
  // ): Boolean = deleteMessageEnabled &&
  //     with(ownCapabilities) { ((message.isOwnMessage(currentUser) && canDeleteOwnMessage()) || canDeleteAnyMessage()) }
  //
  // public fun canFlagMessage(
  //     flagEnabled: Boolean,
  //     currentUser: User?,
  //     message: Message,
  //     ownCapabilities: Set<String>,
  // ): Boolean = flagEnabled && ownCapabilities.canFlagMessage() && !message.isOwnMessage(currentUser)
  //
  // public fun canPinMessage(
  //     pinMessageEnabled: Boolean,
  //     message: Message,
  //     ownCapabilities: Set<String>,
  // ): Boolean = pinMessageEnabled && message.isSynced() && ownCapabilities.canPinMessage()
  //
  // public fun canBlockUser(
  //     blockUserEnabled: Boolean,
  //     currentUser: User?,
  //     message: Message,
  // ): Boolean = blockUserEnabled && !message.isOwnMessage(currentUser)
  //
  // public fun canMarkAsUnread(
  //     markAsUnreadEnabled: Boolean,
  //     ownCapabilities: Set<String>,
  // ): Boolean = markAsUnreadEnabled && ownCapabilities.canMarkAsUnread()
  //
  // public fun canRetryMessage(
  //     retryMessageEnabled: Boolean,
  //     currentUser: User?,
  //     message: Message,
  // ): Boolean = retryMessageEnabled && message.isOwnMessage(currentUser) && message.isMessageFailed()

  //  if (error && isMyMessage) {
  //     actions.push(retry);
  //   }
  //
  //   if (ownCapabilities.quoteMessage && !isThreadMessage && !error) {
  //     actions.push(quotedReply);
  //   }
  //
  //   if (ownCapabilities.sendReply && !isThreadMessage && !error) {
  //     actions.push(threadReply);
  //   }
  //
  //   if (
  //     (isMyMessage && ownCapabilities.updateOwnMessage) ||
  //     (!isMyMessage && ownCapabilities.updateAnyMessage)
  //   ) {
  //     actions.push(editMessage);
  //   }
  //
  //   if (ownCapabilities.readEvents && !error && !isThreadMessage) {
  //     actions.push(markUnread);
  //   }
  //
  //   if (isClipboardAvailable() && message.text && !error) {
  //     actions.push(copyMessage);
  //   }
  //
  //   if (!isMyMessage && ownCapabilities.flagMessage) {
  //     actions.push(flagMessage);
  //   }
  //
  //   if (ownCapabilities.pinMessage && !message.pinned) {
  //     actions.push(pinMessage);
  //   }
  //
  //   if (ownCapabilities.pinMessage && message.pinned) {
  //     actions.push(unpinMessage);
  //   }
  //
  //   if (!isMyMessage && ownCapabilities.banChannelMembers) {
  //     actions.push(banUser);
  //   }
  //
  //   if (
  //     (isMyMessage && ownCapabilities.deleteOwnMessage) ||
  //     (!isMyMessage && ownCapabilities.deleteAnyMessage)
  //   ) {
  //     actions.push(deleteMessage);
  //   }
  //
  //   return actions;
  // };

  static Set<StreamMessageAction> buildActions({
    required BuildContext context,
    required Message message,
    required Channel channel,
    Iterable<StreamMessageAction>? customActions,
    OnMessageActionTap? onActionTap,
  }) {
    // If the message is deleted, we don't show any actions.
    if (message.isDeleted) return {};

    // if (message.state.isFailed) {
    //   return [
    //     if (message.state.isSendingFailed || message.state.isUpdatingFailed)
    //       ResendMessageButton(
    //         isUpdateFailed: message.state.isUpdatingFailed,
    //         onTap: () {},
    //       ),
    //     EditMessageButton(
    //       onTap: () {},
    //     ),
    //     DeleteMessageButton(
    //       isDeleteFailed: message.state.isDeletingFailed,
    //       onTap: () {},
    //     ),
    //   ];
    // }

    final currentUser = channel.client.state.currentUser;
    final isSentByCurrentUser = message.user?.id == currentUser?.id;
    final isThreadMessage = message.parentId != null;
    final isParentMessage = (message.replyCount ?? 0) > 0;
    final canShowInChannel = message.showInChannel ?? true;
    final canSendReply = channel.canSendReply;
    final canPinMessage = channel.canPinMessage;
    final canQuoteMessage = channel.canQuoteMessage;
    final canReceiveReadEvents = channel.canReceiveReadEvents;
    final canUpdateAnyMessage = channel.canUpdateAnyMessage;
    final canUpdateOwnMessage = channel.canUpdateOwnMessage;
    final canDeleteAnyMessage = channel.canDeleteAnyMessage;
    final canDeleteOwnMessage = channel.canDeleteOwnMessage;
    final containsPoll = message.poll != null;
    final containsGiphy = message.attachments.any(
      (attachment) => attachment.type == AttachmentType.giphy,
    );

    final messageActions = <StreamMessageAction>{};

    if (canQuoteMessage) {
      const actionType = StreamMessageActionType.quotedReply;

      messageActions.add(
        StreamMessageAction(
          type: actionType,
          title: Text(context.translations.replyLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.reply),
          onTap: switch (onActionTap) {
            final onTap? => (message) => onTap(message, actionType),
            _ => null,
          },
        ),
      );
    }

    if (canSendReply && !isThreadMessage) {
      const actionType = StreamMessageActionType.threadReply;

      messageActions.add(
        StreamMessageAction(
          type: actionType,
          title: Text(context.translations.threadReplyLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.threadReply),
          onTap: switch (onActionTap) {
            final onTap? => (message) => onTap(message, actionType),
            _ => null,
          },
        ),
      );
    }

    if (canReceiveReadEvents) {
      StreamMessageAction markUnreadAction() {
        const actionType = StreamMessageActionType.markUnread;

        return StreamMessageAction(
          type: actionType,
          title: Text(context.translations.markAsUnreadLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.messageUnread),
          onTap: switch (onActionTap) {
            final onTap? => (message) => onTap(message, actionType),
            _ => null,
          },
        );
      }

      // If message is a parent message, it can be marked unread independent of
      // other logic.
      if (isParentMessage) {
        messageActions.add(markUnreadAction());
      }
      // If the message is in the channel view, only other user messages can be
      // marked unread.
      else if (!isSentByCurrentUser && (!isThreadMessage || canShowInChannel)) {
        messageActions.add(markUnreadAction());
      }
    }

    if (message.text case final text? when text.isNotEmpty) {
      const actionType = StreamMessageActionType.copyMessage;

      messageActions.add(
        StreamMessageAction(
          type: actionType,
          title: Text(context.translations.copyMessageLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.copy),
          onTap: switch (onActionTap) {
            final onTap? => (message) => onTap(message, actionType),
            _ => null,
          },
        ),
      );
    }

    if (!containsPoll && !containsGiphy) {
      if (canUpdateAnyMessage || (canUpdateOwnMessage && isSentByCurrentUser)) {
        const actionType = StreamMessageActionType.editMessage;

        messageActions.add(
          StreamMessageAction(
            type: actionType,
            title: Text(context.translations.editMessageLabel),
            leading: const StreamSvgIcon(icon: StreamSvgIcons.edit),
            onTap: switch (onActionTap) {
              final onTap? => (message) => onTap(message, actionType),
              _ => null,
            },
          ),
        );
      }
    }

    // TODO: Add check for bounced messages.
    if (canPinMessage) {
      final isPinned = message.pinned;
      final label = context.translations.togglePinUnpinText;
      final actionType = switch (isPinned) {
        true => StreamMessageActionType.unpinMessage,
        false => StreamMessageActionType.pinMessage,
      };

      messageActions.add(
        StreamMessageAction(
          type: actionType,
          title: Text(label.call(pinned: isPinned)),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.pin),
          onTap: switch (onActionTap) {
            final onTap? => (message) => onTap(message, actionType),
            _ => null,
          },
        ),
      );
    }

    if (canDeleteAnyMessage || (canDeleteOwnMessage && isSentByCurrentUser)) {
      const actionType = StreamMessageActionType.deleteMessage;
      final label = context.translations.toggleDeleteRetryDeleteMessageText;

      messageActions.add(
        StreamMessageAction(
          type: actionType,
          isDestructive: true,
          leading: const StreamSvgIcon(icon: StreamSvgIcons.delete),
          title: Text(label.call(isDeleteFailed: false)),
          onTap: switch (onActionTap) {
            final onTap? => (message) => onTap(message, actionType),
            _ => null,
          },
        ),
      );
    }

    if (!isSentByCurrentUser) {
      const actionType = StreamMessageActionType.flagMessage;

      messageActions.add(
        StreamMessageAction(
          type: actionType,
          title: Text(context.translations.flagMessageLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.flag),
          onTap: switch (onActionTap) {
            final onTap? => (message) => onTap(message, actionType),
            _ => null,
          },
        ),
      );
    }

    if (channel.config?.mutes == true && !isSentByCurrentUser) {
      final currentMutedUsers = currentUser?.mutes.map((mute) => mute.user.id);
      final isMuted = currentMutedUsers?.contains(message.user?.id) ?? false;

      const actionType = StreamMessageActionType.muteUser;
      final label = context.translations.toggleMuteUnmuteUserText;

      messageActions.add(
        StreamMessageAction(
          type: actionType,
          title: Text(label.call(isMuted: isMuted)),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.mute),
          onTap: switch (onActionTap) {
            final onTap? => (message) => onTap(message, actionType),
            _ => null,
          },
        ),
      );
    }

    // Add all the remaining custom actions if provided.
    if (customActions case final actions?) messageActions.addAll(actions);

    return messageActions;
  }
}
