import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/extension.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@macro user_item}
@Deprecated("Use 'StreamUserItem' instead")
typedef UserItem = StreamUserItem;

/// {@template user_item}
/// It shows the current [User] preview.
///
/// The widget uses a [StreamBuilder] to render the user information
/// image as soon as it updates.
///
/// Usually you don't use this widget as it's the default user preview used
/// by [StreamUserListView].
///
/// The widget renders the ui based on the first ancestor of type
/// [StreamChatTheme].
/// Modify it to change the widget appearance.
/// {@endtemplate}
class StreamUserItem extends StatelessWidget {
  /// Instantiate a new UserItem
  const StreamUserItem({
    super.key,
    required this.user,
    this.onTap,
    this.onLongPress,
    this.onImageTap,
    this.selected = false,
    this.showLastOnline = true,
  });

  /// Function called when tapping this widget
  final void Function(User)? onTap;

  /// Function called when long pressing this widget
  final void Function(User)? onLongPress;

  /// User displayed
  final User user;

  /// The function called when the image is tapped
  final void Function(User)? onImageTap;

  /// If true the [StreamUserItem] will show a trailing checkmark
  final bool selected;

  /// If true the [StreamUserItem] will show the last seen
  final bool showLastOnline;

  @override
  Widget build(BuildContext context) {
    final chatThemeData = StreamChatTheme.of(context);
    return ListTile(
      onTap: onTap == null ? null : () => onTap!(user),
      onLongPress: onLongPress == null ? null : () => onLongPress!(user),
      leading: StreamUserAvatar(
        user: user,
        onTap: onImageTap,
        constraints: const BoxConstraints.tightFor(
          height: 40,
          width: 40,
        ),
      ),
      trailing: selected
          ? StreamSvgIcon.checkSend(
              color: chatThemeData.colorTheme.accentPrimary,
            )
          : null,
      title: Text(
        user.name,
        style: chatThemeData.textTheme.bodyBold,
      ),
      subtitle: showLastOnline ? _buildLastActive(context) : null,
    );
  }

  Widget _buildLastActive(BuildContext context) {
    final chatTheme = StreamChatTheme.of(context);
    return Text(
      user.online
          ? context.translations.userOnlineText
          : '${context.translations.userLastOnlineText} '
              '${Jiffy(user.lastActive).fromNow()}',
      style: chatTheme.textTheme.footnote.copyWith(
        color: chatTheme.colorTheme.textHighEmphasis.withOpacity(0.5),
      ),
    );
  }
}
