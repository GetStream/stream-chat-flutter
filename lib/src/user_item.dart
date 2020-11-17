import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_flutter/src/user_list_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
  const UserItem(
      {Key key,
      @required this.user,
      this.onTap,
      this.onLongPress,
      this.onImageTap})
      : super(key: key);

  /// Function called when tapping this widget
  final void Function(User) onTap;

  /// Function called when long pressing this widget
  final void Function(User) onLongPress;

  /// User displayed
  final User user;

  /// The function called when the image is tapped
  final void Function(User) onImageTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onTap != null) {
          onTap(user);
        }
      },
      onLongPress: () {
        if (onLongPress != null) {
          onLongPress(user);
        }
      },
      leading: UserAvatar(
          user: user,
          showOnlineStatus: true,
          onTap: (user) {
            if (onImageTap != null) {
              onImageTap(user);
            }
          }),
      title: Text(user.name),
      subtitle: _buildLastActive(context),
    );
  }

  Widget _buildLastActive(context) {
    return Text('Last seen ${Jiffy(user.lastActive).fromNow()}');
  }
}
