import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

/// {@template messageActionsBuilder}
/// Signature for a builder that customizes the list of message actions shown
/// in the long-press context menu.
///
/// [defaultActions] are the pre-built actions already filtered by the widget's
/// `show*` flags. Return a modified list to add, remove, or reorder actions.
///
/// The return type is [List<Widget>] so any widget — including
/// [StreamContextMenuSeparator] or fully custom items — can be mixed in
/// alongside the default [StreamContextMenuAction] items.
/// {@endtemplate}
typedef MessageActionsBuilder<T extends MessageAction> =
    List<Widget> Function(
      BuildContext context,
      List<StreamContextMenuAction<T>> defaultActions,
    );

/// {@template messageAction}
/// A sealed class that represents different actions that can be performed on a
/// message.
/// {@endtemplate}
sealed class MessageAction {
  /// {@macro messageAction}
  const MessageAction({required this.message});

  /// The message this action applies to.
  final Message message;
}

/// Action to show reaction selector for adding reactions to a message
final class SelectReaction extends MessageAction {
  /// Create a new select reaction action
  const SelectReaction({
    required super.message,
    required this.reaction,
    this.enforceUnique = false,
  });

  /// The reaction to be added or removed from the message.
  final Reaction reaction;

  /// Whether to enforce unique reactions.
  final bool enforceUnique;
}

/// Action to copy message content to clipboard
final class CopyMessage extends MessageAction {
  /// Create a new copy message action
  const CopyMessage({required super.message});
}

/// Action to delete a message from the conversation
final class DeleteMessage extends MessageAction {
  /// Create a new delete message action
  const DeleteMessage({required super.message});
}

/// Action to hard delete a message permanently from the conversation
final class HardDeleteMessage extends MessageAction {
  /// Create a new hard delete message action
  const HardDeleteMessage({required super.message});
}

/// Action to modify content of an existing message
final class EditMessage extends MessageAction {
  /// Create a new edit message action
  const EditMessage({required super.message});
}

/// Action to flag a message for moderator review
final class FlagMessage extends MessageAction {
  /// Create a new flag message action
  const FlagMessage({required super.message});
}

/// Action to mark a message as unread for later viewing
final class MarkUnread extends MessageAction {
  /// Create a new mark unread action
  const MarkUnread({required super.message});
}

/// Action to mute a user to prevent notifications from their messages
final class MuteUser extends MessageAction {
  /// Create a new mute user action
  const MuteUser({
    required super.message,
    required this.user,
  });

  /// The user to be muted.
  final User user;
}

/// Action to unmute a user to receive notifications from their messages
final class UnmuteUser extends MessageAction {
  /// Create a new unmute user action
  const UnmuteUser({
    required super.message,
    required this.user,
  });

  /// The user to be unmuted.
  final User user;
}

/// Action to block a user, preventing direct messages from them
final class BlockUser extends MessageAction {
  /// Create a new block user action
  const BlockUser({
    required super.message,
    required this.user,
  });

  /// The user to be blocked.
  final User user;
}

/// Action to unblock a previously blocked user
final class UnblockUser extends MessageAction {
  /// Create a new unblock user action
  const UnblockUser({
    required super.message,
    required this.user,
  });

  /// The user to be unblocked.
  final User user;
}

/// Action to pin a message to make it prominently visible in the channel
final class PinMessage extends MessageAction {
  /// Create a new pin message action
  const PinMessage({required super.message});
}

/// Action to remove a previously pinned message
final class UnpinMessage extends MessageAction {
  /// Create a new unpin message action
  const UnpinMessage({required super.message});
}

/// Action to attempt to resend a message that failed to send
final class ResendMessage extends MessageAction {
  /// Create a new resend message action
  const ResendMessage({required super.message});
}

/// Action to create a reply with quoted original message content
final class QuotedReply extends MessageAction {
  /// Create a new quoted reply action
  const QuotedReply({required super.message});
}

/// Action to start a threaded conversation from a message
final class ThreadReply extends MessageAction {
  /// Create a new thread reply action
  const ThreadReply({required super.message});
}
