import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/components/avatar/stream_user_avatar.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

/// Displays the message author's avatar as the leading widget in a message
/// row.
///
/// Visibility of this widget (visible, hidden, or gone) is controlled by
/// [StreamMessageItemThemeData.avatarVisibility] in the parent
/// [DefaultStreamMessage].
///
/// See also:
///
///  * [StreamUserAvatar], which renders the avatar image.
///  * [DefaultStreamMessage], which controls when this widget is shown.
class StreamMessageLeading extends StatelessWidget {
  /// Creates a message leading widget for the given [author].
  const StreamMessageLeading({
    super.key,
    required this.author,
  });

  /// The user whose avatar to display.
  final User author;

  @override
  Widget build(BuildContext context) {
    return StreamUserAvatar(
      user: author,
      showOnlineIndicator: false,
    );
  }
}
