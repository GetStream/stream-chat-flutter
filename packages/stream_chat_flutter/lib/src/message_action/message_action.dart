import 'package:flutter/widgets.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

part 'message_action_type.dart';

/// {@template streamMessageAction}
/// A class that represents an action that can be performed on a message.
///
/// This class is used to define actions that appear in message action menus
/// or option lists, providing a consistent structure for message-related
/// actions including their visual representation and behavior.
/// {@endtemplate}
class StreamMessageAction<T extends MessageAction> {
  /// {@macro streamMessageAction}
  const StreamMessageAction({
    required this.action,
    this.isDestructive = false,
    this.leading,
    this.iconColor,
    this.title,
    this.titleTextColor,
    this.titleTextStyle,
    this.backgroundColor,
  });

  /// The [MessageAction] that this item represents.
  final T action;

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
}
