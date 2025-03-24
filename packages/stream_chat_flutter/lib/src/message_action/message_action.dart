import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// {@template streamMessageAction}
/// A class that represents an action that can be performed on a message.
///
/// This class is used to define actions that appear in message action menus
/// or option lists, providing a consistent structure for message-related
/// actions including their visual representation and behavior.
/// {@endtemplate}
class StreamMessageAction {
  /// {@macro streamMessageAction}
  const StreamMessageAction({
    this.type,
    this.isDestructive = false,
    this.leading,
    this.iconColor,
    this.title,
    this.titleTextColor,
    this.titleTextStyle,
    this.backgroundColor,
    this.onTap,
  });

  /// Type of the action performed.
  ///
  /// {@macro streamMessageActionType}
  final StreamMessageActionType? type;

  /// Whether the action is destructive.
  ///
  /// Destructive actions are typically displayed with a red color to indicate
  /// that they will remove or delete content.
  ///
  /// Defaults to `false`.
  final bool isDestructive;

  /// A widget to display before the title.
  ///
  /// Typically an [Icon] or a [CircleAvatar] widget.
  final Widget? leading;

  /// The color for the [leading] icon.
  ///
  /// If this property is null, the icon will use the default color provided by
  /// the theme or parent widget.
  final Color? iconColor;

  /// The primary content of the action item.
  ///
  /// Typically a [Text] widget.
  ///
  /// This should not wrap. To enforce the single line limit, use
  /// [Text.maxLines].
  final Widget? title;

  /// The color for the text in the [title].
  ///
  /// If this property is null, the text will use the default color provided by
  /// the theme or parent widget.
  final Color? titleTextColor;

  /// The text style for the [title].
  ///
  /// If this property is null, the title will use the default text style
  /// provided by the theme or parent widget.
  final TextStyle? titleTextStyle;

  /// Defines the background color of the action item.
  final Color? backgroundColor;

  /// Called when the user taps this action item.
  ///
  /// This callback provides the tap handling for the action item, and is
  /// typically used to execute the associated action or dismiss menus.
  final ValueSetter<Message>? onTap;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StreamMessageAction && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}

/// {@template streamMessageActionType}
/// A type that represents the various actions that can be performed on a
/// message.
///
/// This extension type provides strongly typed constants for message actions,
/// Each constant represents a specific action that can be taken on a message.
/// {@endtemplate}
extension type const StreamMessageActionType(String type) implements String {
  /// Shows reaction selector for adding reactions to a message
  static const selectReaction = StreamMessageActionType('selectReaction');

  /// Bans a user from the channel (requires moderator permissions)
  static const banUser = StreamMessageActionType('banUser');

  /// Blocks a user from sending direct messages to the current user
  static const blockUser = StreamMessageActionType('blockUser');

  /// Copies message content to clipboard
  static const copyMessage = StreamMessageActionType('copyMessage');

  /// Deletes a message from the conversation
  static const deleteMessage = StreamMessageActionType('deleteMessage');

  /// Modifies content of an existing message
  static const editMessage = StreamMessageActionType('editMessage');

  /// Flags a message for moderator review
  static const flagMessage = StreamMessageActionType('flagMessage');

  /// Marks a message as unread for later viewing
  static const markUnread = StreamMessageActionType('markUnread');

  /// Mutes a user to prevent notifications from their messages
  static const muteUser = StreamMessageActionType('muteUser');

  /// Pins a message to make it prominently visible in the channel
  static const pinMessage = StreamMessageActionType('pinMessage');

  /// Removes a previously pinned message
  static const unpinMessage = StreamMessageActionType('unpinMessage');

  /// Creates a standard reply to a message
  static const reply = StreamMessageActionType('reply');

  /// Attempts to resend a message that failed to send
  static const retry = StreamMessageActionType('retry');

  /// Creates a reply with quoted original message content
  static const quotedReply = StreamMessageActionType('quotedReply');

  /// Starts a threaded conversation from a message
  static const threadReply = StreamMessageActionType('threadReply');
}
