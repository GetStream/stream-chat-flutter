import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Displays the leading slot of a message item — by default the author's
/// avatar shown to the side of the message bubble.
///
/// Returns `null` when [Message.user] is null, allowing the parent layout to
/// collapse the slot and skip spacing automatically.
///
/// See also:
///
///  * [StreamMessageHeader], the annotation slot above the bubble.
///  * [StreamMessageFooter], the metadata slot below the bubble.
///  * [DefaultStreamMessageItem], which controls leading visibility.
class StreamMessageLeading extends core.NullableStatelessWidget {
  /// Creates a message leading slot for the given [message].
  const StreamMessageLeading({super.key, required this.message});

  /// The message whose author avatar to display.
  final Message message;

  @override
  Widget? nullableBuild(BuildContext context) {
    final user = message.user;
    if (user == null) return null;

    final theme = core.StreamMessageItemTheme.of(context);
    final avatarSize = theme.avatarSize ?? StreamAvatarSize.md;

    return core.StreamAvatarTheme(
      data: .new(size: avatarSize),
      child: StreamUserAvatar(user: user, showOnlineIndicator: false),
    );
  }
}
