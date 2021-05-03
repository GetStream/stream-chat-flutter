import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/stream_svg_icon.dart';
import 'package:stream_chat_flutter/src/user_list_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

import 'stream_chat_theme.dart';

///
/// It shows the current [User] preview.
///
/// The widget uses a [StreamBuilder] to render the user information image as soon as it updates.
///
/// Usually you don't use this widget as it's the default user preview used by [UserListView].
///
/// The widget renders the ui based on the first ancestor of type [StreamChatTheme].
/// Modify it to change the widget appearance.
class UserItem extends StatelessWidget {
  /// Instantiate a new UserItem
  const UserItem({
    Key? key,
    required this.user,
    this.onTap,
    this.onLongPress,
    this.onImageTap,
    this.selected = false,
    this.showLastOnline = true,
  }) : super(key: key);

  /// Function called when tapping this widget
  final void Function(User)? onTap;

  /// Function called when long pressing this widget
  final void Function(User)? onLongPress;

  /// User displayed
  final User user;

  /// The function called when the image is tapped
  final void Function(User)? onImageTap;

  /// If true the [UserItem] will show a trailing checkmark
  final bool selected;

  /// If true the [UserItem] will show the last seen
  final bool showLastOnline;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onTap != null) {
          onTap!(user);
        }
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress!(user);
        }
      },
      leading: UserAvatar(
        user: user,
        showOnlineStatus: true,
        onTap: (user) {
          if (onImageTap != null) {
            onImageTap!(user);
          }
        },
        constraints: BoxConstraints.tightFor(
          height: 40,
          width: 40,
        ),
      ),
      trailing: selected
          ? StreamSvgIcon.checkSend(
              color: StreamChatTheme.of(context).colorTheme.accentBlue,
            )
          : null,
      title: Text(
        user.name,
        style: StreamChatTheme.of(context).textTheme.bodyBold,
      ),
      subtitle: showLastOnline ? _buildLastActive(context) : null,
    );
  }

  Widget _buildLastActive(context) {
    return Text(
      user.online == true
          ? 'Online'
          : 'Last online ${Jiffy(user.lastActive).fromNow()}',
      style: StreamChatTheme.of(context).textTheme.footnote.copyWith(
          color: StreamChatTheme.of(context).colorTheme.black.withOpacity(.5)),
    );
  }
}
