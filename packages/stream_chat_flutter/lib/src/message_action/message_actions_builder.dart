import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/message_action/message_action.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
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

  /// Returns a set of message actions for the "bounced with error" state.
  ///
  /// This method builds a set of [StreamMessageAction]s that are applicable to
  /// the given [message] when it is in the "bounced with error" state.
  ///
  /// The actions include options to retry sending the message, edit or delete
  /// the message.
  static Set<StreamMessageAction> buildBouncedErrorActions({
    required BuildContext context,
    required Message message,
    OnMessageActionTap? onActionTap,
  }) {
    // If the message is not bounced with an error, we don't show any actions.
    if (!message.isBouncedWithError) return {};

    return <StreamMessageAction>{
      StreamMessageAction(
        type: StreamMessageActionType.resendMessage,
        iconColor: StreamChatTheme.of(context).colorTheme.accentPrimary,
        title: Text(context.translations.sendAnywayLabel),
        leading: const StreamSvgIcon(icon: StreamSvgIcons.circleUp),
        onTap: switch (onActionTap) {
          final onTap? => (message) =>
              onTap(message, StreamMessageActionType.resendMessage),
          _ => null,
        },
      ),
      StreamMessageAction(
        type: StreamMessageActionType.editMessage,
        title: Text(context.translations.editMessageLabel),
        leading: const StreamSvgIcon(icon: StreamSvgIcons.edit),
        onTap: switch (onActionTap) {
          final onTap? => (message) =>
              onTap(message, StreamMessageActionType.editMessage),
          _ => null,
        },
      ),
      StreamMessageAction(
        isDestructive: true,
        type: StreamMessageActionType.hardDeleteMessage,
        title: Text(context.translations.deleteMessageLabel),
        leading: const StreamSvgIcon(icon: StreamSvgIcons.delete),
        onTap: switch (onActionTap) {
          final onTap? => (message) =>
              onTap(message, StreamMessageActionType.hardDeleteMessage),
          _ => null,
        },
      ),
    };
  }

  /// Returns a set of message actions based on the provided message and channel
  /// capabilities.
  ///
  /// This method builds a set of [StreamMessageAction]s that are applicable to
  /// the given [message] in the [channel], considering the permissions of the
  /// [currentUser] and the current state of the message.
  static Set<StreamMessageAction> buildActions({
    required BuildContext context,
    required Message message,
    required Channel channel,
    OwnUser? currentUser,
    Iterable<StreamMessageAction>? customActions,
    OnMessageActionTap? onActionTap,
  }) {
    // If the message is deleted, we don't show any actions.
    if (message.isDeleted) return {};

    final messageState = message.state;
    if (messageState.isFailed) {
      const actionType = StreamMessageActionType.resendMessage;

      final retryMessage = switch (onActionTap) {
        final onTap? => (Message message) => onTap(message, actionType),
        _ => null,
      };

      return {
        if (messageState.isSendingFailed || messageState.isUpdatingFailed) ...[
          StreamMessageAction(
            type: actionType,
            leading: const StreamSvgIcon(icon: StreamSvgIcons.circleUp),
            iconColor: StreamChatTheme.of(context).colorTheme.accentPrimary,
            title: Text(
              context.translations.toggleResendOrResendEditedMessage(
                isUpdateFailed: messageState.isUpdatingFailed,
              ),
            ),
            onTap: retryMessage,
          ),
        ],
        if (message.state.isDeletingFailed)
          StreamMessageAction(
            type: actionType,
            isDestructive: true,
            leading: const StreamSvgIcon(icon: StreamSvgIcons.delete),
            title: Text(
              context.translations.toggleDeleteRetryDeleteMessageText(
                isDeleteFailed: true,
              ),
            ),
            onTap: retryMessage,
          ),
      };
    }

    final isSentByCurrentUser = message.user?.id == currentUser?.id;
    final isThreadMessage = message.parentId != null;
    final isParentMessage = (message.replyCount ?? 0) > 0;
    final canShowInChannel = message.showInChannel ?? true;
    final isPrivateMessage = message.hasRestrictedVisibility;
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

    // Pinning a private message is not allowed, simply because pinning a
    // message is meant to bring attention to that message, that is not possible
    // with a message that is only visible to a subset of users.
    if (canPinMessage && !isPrivateMessage) {
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
      final mutedUsers = currentUser?.mutes.map((mute) => mute.target.id);
      final isMuted = mutedUsers?.contains(message.user?.id) ?? false;
      final label = context.translations.toggleMuteUnmuteUserText;

      final actionType = switch (isMuted) {
        true => StreamMessageActionType.unmuteUser,
        false => StreamMessageActionType.muteUser,
      };

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
