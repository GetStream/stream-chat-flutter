import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter/src/icons/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/message_action/message_action.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamMessageActionsBuilder}
/// A utility class that provides a builder for message actions
/// which can be reused across mobile platforms.
/// {@endtemplate}
class StreamMessageActionsBuilder {
  /// Private constructor to prevent instantiation
  StreamMessageActionsBuilder._();

  /// Returns a list of message actions for the "bounced with error" state.
  ///
  /// This method builds a list of [StreamMessageAction]s that are applicable to
  /// the given [message] when it is in the "bounced with error" state.
  ///
  /// The actions include options to retry sending the message, edit or delete
  /// the message.
  static List<StreamMessageAction> buildBouncedErrorActions({
    required BuildContext context,
    required Message message,
  }) {
    // If the message is not bounced with an error, we don't show any actions.
    if (!message.isBouncedWithError) return [];

    return <StreamMessageAction>[
      StreamMessageAction(
        action: ResendMessage(message: message),
        iconColor: StreamChatTheme.of(context).colorTheme.accentPrimary,
        title: Text(context.translations.sendAnywayLabel),
        leading: const StreamSvgIcon(icon: StreamSvgIcons.circleUp),
      ),
      StreamMessageAction(
        action: EditMessage(message: message),
        title: Text(context.translations.editMessageLabel),
        leading: const StreamSvgIcon(icon: StreamSvgIcons.edit),
      ),
      StreamMessageAction(
        isDestructive: true,
        action: HardDeleteMessage(message: message),
        title: Text(context.translations.deleteMessageLabel),
        leading: const StreamSvgIcon(icon: StreamSvgIcons.delete),
      ),
    ];
  }

  /// Returns a list of message actions based on the provided message and
  /// channel capabilities.
  ///
  /// This method builds a list of [StreamMessageAction]s that are applicable to
  /// the given [message] in the [channel], considering the permissions of the
  /// [currentUser] and the current state of the message.
  static List<StreamMessageAction> buildActions({
    required BuildContext context,
    required Message message,
    required Channel channel,
    OwnUser? currentUser,
    Iterable<StreamMessageAction>? customActions,
  }) {
    final messageState = message.state;

    // If the message is deleted, we don't show any actions.
    if (messageState.isDeleted) return [];

    if (messageState.isFailed) {
      return [
        if (messageState.isSendingFailed || messageState.isUpdatingFailed) ...[
          StreamMessageAction(
            action: ResendMessage(message: message),
            leading: const StreamSvgIcon(icon: StreamSvgIcons.circleUp),
            iconColor: StreamChatTheme.of(context).colorTheme.accentPrimary,
            title: Text(
              context.translations.toggleResendOrResendEditedMessage(
                isUpdateFailed: messageState.isUpdatingFailed,
              ),
            ),
          ),
        ],
        if (message.state.isDeletingFailed)
          StreamMessageAction(
            isDestructive: true,
            action: ResendMessage(message: message),
            leading: const StreamSvgIcon(icon: StreamSvgIcons.delete),
            title: Text(
              context.translations.toggleDeleteRetryDeleteMessageText(
                isDeleteFailed: true,
              ),
            ),
          ),
      ];
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

    final messageActions = <StreamMessageAction>[];

    if (canQuoteMessage) {
      messageActions.add(
        StreamMessageAction(
          action: QuotedReply(message: message),
          title: Text(context.translations.replyLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.reply),
        ),
      );
    }

    if (canSendReply && !isThreadMessage) {
      messageActions.add(
        StreamMessageAction(
          action: ThreadReply(message: message),
          title: Text(context.translations.threadReplyLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.threadReply),
        ),
      );
    }

    if (canReceiveReadEvents) {
      StreamMessageAction markUnreadAction() {
        return StreamMessageAction(
          action: MarkUnread(message: message),
          title: Text(context.translations.markAsUnreadLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.messageUnread),
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
      messageActions.add(
        StreamMessageAction(
          action: CopyMessage(message: message),
          title: Text(context.translations.copyMessageLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.copy),
        ),
      );
    }

    if (!containsPoll && !containsGiphy) {
      if (canUpdateAnyMessage || (canUpdateOwnMessage && isSentByCurrentUser)) {
        messageActions.add(
          StreamMessageAction(
            action: EditMessage(message: message),
            title: Text(context.translations.editMessageLabel),
            leading: const StreamSvgIcon(icon: StreamSvgIcons.edit),
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

      final action = switch (isPinned) {
        true => UnpinMessage(message: message),
        false => PinMessage(message: message)
      };

      messageActions.add(
        StreamMessageAction(
          action: action,
          title: Text(label.call(pinned: isPinned)),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.pin),
        ),
      );
    }

    if (canDeleteAnyMessage || (canDeleteOwnMessage && isSentByCurrentUser)) {
      final label = context.translations.toggleDeleteRetryDeleteMessageText;

      messageActions.add(
        StreamMessageAction(
          isDestructive: true,
          action: DeleteMessage(message: message),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.delete),
          title: Text(label.call(isDeleteFailed: false)),
        ),
      );
    }

    if (!isSentByCurrentUser) {
      messageActions.add(
        StreamMessageAction(
          action: FlagMessage(message: message),
          title: Text(context.translations.flagMessageLabel),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.flag),
        ),
      );
    }

    if (message.user case final messageUser?
        when channel.config?.mutes == true && !isSentByCurrentUser) {
      final mutedUsers = currentUser?.mutes.map((mute) => mute.target.id);
      final isMuted = mutedUsers?.contains(messageUser.id) ?? false;
      final label = context.translations.toggleMuteUnmuteUserText;

      final action = switch (isMuted) {
        true => UnmuteUser(message: message, user: messageUser),
        false => MuteUser(message: message, user: messageUser),
      };

      messageActions.add(
        StreamMessageAction(
          action: action,
          title: Text(label.call(isMuted: isMuted)),
          leading: const StreamSvgIcon(icon: StreamSvgIcons.mute),
        ),
      );
    }

    // Add all the remaining custom actions if provided.
    if (customActions case final actions?) messageActions.addAll(actions);

    return messageActions;
  }
}
