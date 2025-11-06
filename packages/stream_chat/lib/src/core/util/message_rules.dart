import 'package:stream_chat/src/client/channel.dart';
import 'package:stream_chat/src/core/models/message.dart';
import 'package:stream_chat/src/core/models/own_user.dart';

/// Provides validation rules for message operations.
///
/// Determines whether messages can be sent, counted as unread, marked as
/// delivered, or update channel timestamps based on business rules.
class MessageRules {
  const MessageRules._();

  /// Whether the [message] is valid for upload (sending or updating).
  ///
  /// Returns `true` if the message has at least one of the following:
  ///
  /// * Non-empty text content
  /// * At least one attachment
  /// * A quoted message reference
  /// * A poll
  static bool canUpload(Message message) {
    final hasText = message.text?.trim().isNotEmpty == true;
    final hasAttachments = message.attachments.isNotEmpty;
    final hasQuotedMessage = message.quotedMessageId != null;
    final hasPoll = message.pollId != null;

    return hasText || hasAttachments || hasQuotedMessage || hasPoll;
  }

  /// Whether the [message] can update the channel's last message timestamp.
  ///
  /// Returns `false` for error, shadowed, ephemeral, or restricted messages,
  /// and system messages when the channel config skips them.
  ///
  /// See: https://github.com/GetStream/chat/blob/9245c2b3f7e679267d57ee510c60e93de051cb8e/types/channel.go#L1136-L1150
  static bool canUpdateChannelLastMessageAt(
    Message message,
    Channel channel,
  ) {
    if (message.isError) return false;
    if (message.shadowed) return false;
    if (message.isEphemeral) return false;

    final config = channel.state?.channelState.channel?.config;
    if (message.isSystem && config?.skipLastMsgUpdateForSystemMsgs == true) {
      return false;
    }

    final currentUserId = channel.client.state.currentUser?.id;
    if (currentUserId case final userId? when message.isNotVisibleTo(userId)) {
      return false;
    }

    return true;
  }

  /// Whether the [message] can be counted as unread in the given [channel].
  ///
  /// Returns `false` for the current user's own messages, messages from muted
  /// users, silent/shadowed/ephemeral messages, thread-only replies, restricted
  /// messages, and messages already read. Also returns `false` if the channel
  /// is muted or doesn't support read events.
  static bool canCountAsUnread(
    Message message,
    Channel channel,
  ) {
    // Don't count if the current user is not set.
    final currentUser = channel.client.state.currentUser;
    if (currentUser == null) return false;

    // Don't count if the user has disabled read receipts.
    if (!currentUser.isReadReceiptsEnabled) return false;

    // Don't count if the channel doesn't support read receipts.
    if (!channel.canUseReadReceipts) return false;

    // Don't count if the channel is muted.
    if (channel.isMuted) return false;

    // Don't count if the message is silent, shadowed, or ephemeral.
    if (message.silent) return false;
    if (message.shadowed) return false;
    if (message.isEphemeral) return false;

    // Don't count thread-only messages towards channel unread count.
    if (message.parentId != null && message.showInChannel != true) {
      return false;
    }

    // Don't count if the message doesn't have a sender.
    final messageUser = message.user;
    if (messageUser == null) return false;

    // Don't count the current user's own messages.
    if (messageUser.id == currentUser.id) return false;

    // Don't count restricted messages.
    if (message.isNotVisibleTo(currentUser.id)) return false;

    // Don't count messages from muted users.
    final isMuted = currentUser.mutes.any((it) => it.user.id == messageUser.id);
    if (isMuted) return false;

    final currentUserRead = channel.state?.currentUserRead;
    if (currentUserRead == null) return true;

    final lastRead = currentUserRead.lastRead;
    // Don't count messages at or before the last read time.
    if (!message.createdAt.isAfter(lastRead)) return false;

    final lastReadMessageId = currentUserRead.lastReadMessageId;
    // Don't count if this is the last read message.
    if (lastReadMessageId case final id? when message.id == id) return false;

    return true;
  }

  /// Whether the [message] can be marked as delivered in the given [channel].
  ///
  /// Returns `false` if any of the following conditions are met:
  ///
  /// * The message is ephemeral
  /// * The message is a thread reply not shown in the channel
  /// * The message has no sender
  /// * There is no current user
  /// * The message was sent by the current user
  /// * The message is restricted (not visible to the current user)
  /// * The message was created before or at the last read time
  /// * The message is the last read message (already marked as read)
  /// * The message was created before or at the last delivered time
  /// * The message is the last delivered message (already marked as delivered)
  static bool canMarkAsDelivered(
    Message message,
    Channel channel,
  ) {
    // Don't deliver receipts if the current user is not set.
    final currentUser = channel.client.state.currentUser;
    if (currentUser == null) return false;

    // Don't deliver receipts if the user has disabled delivery receipts.
    if (!currentUser.isDeliveryReceiptsEnabled) return false;

    // Don't deliver receipts if the channel doesn't support delivery receipts.
    if (!channel.canUseDeliveryReceipts) return false;

    // Don't deliver receipts if the channel is muted.
    if (channel.isMuted) return false;

    // Don't deliver receipts for ephemeral messages.
    if (message.isEphemeral) return false;

    // Don't deliver receipts for thread-only messages.
    if (message.parentId != null && message.showInChannel != true) {
      return false;
    }

    // Don't deliver receipts if the message doesn't have a sender.
    final messageUser = message.user;
    if (messageUser == null) return false;

    // Don't deliver receipts for the current user's own messages.
    if (messageUser.id == currentUser.id) return false;

    // Don't deliver receipts for restricted messages.
    if (message.isNotVisibleTo(currentUser.id)) return false;

    final currentUserRead = channel.state?.currentUserRead;
    if (currentUserRead == null) return true;

    final lastRead = currentUserRead.lastRead;
    // Don't deliver receipts for messages at or before the last read time.
    if (!message.createdAt.isAfter(lastRead)) return false;

    final lastReadMessageId = currentUserRead.lastReadMessageId;
    // Don't deliver receipts if this is the last read message.
    if (lastReadMessageId case final id? when message.id == id) return false;

    final lastDelivered = currentUserRead.lastDeliveredAt;
    // Don't deliver receipts for messages at or before the last delivered time.
    if (lastDelivered case final last? when !message.createdAt.isAfter(last)) {
      return false;
    }

    final lastDeliveredMessageId = currentUserRead.lastDeliveredMessageId;
    // Don't deliver receipts if this is the last delivered message.
    if (lastDeliveredMessageId case final id? when message.id == id) {
      return false;
    }

    return true;
  }
}
