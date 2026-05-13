import 'package:flutter/material.dart';
import 'package:jiffy/jiffy.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_sending_status.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/src/stream_chat.dart';
import 'package:stream_chat_flutter/src/utils/extensions.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart' as core;

/// Displays the row below the message bubble containing the author name,
/// sending status, creation timestamp, and an edited indicator.
///
/// The footer can show up to four pieces depending on the message:
///
///  * **Username** — for messages from other users.
///  * **Sending status** — for the current user's own messages.
///  * **Timestamp** — always shown, formatted as a short time string.
///  * **Edited label** — when the message text has been updated.
///
/// See also:
///
///  * [StreamMessageHeader], the symmetric slot above the message bubble.
///  * [StreamMessageSendingStatus], which renders the sent/delivered/read
///    indicator.
///  * [DefaultStreamMessageItem], which controls footer visibility.
class StreamMessageFooter extends StatelessWidget {
  /// Creates a message footer for the given [message].
  const StreamMessageFooter({super.key, required this.message});

  /// The message whose metadata to display.
  final Message message;

  @override
  Widget build(BuildContext context) {
    final currentUser = StreamChat.of(context).currentUser;
    final channelKind = core.StreamMessageLayout.channelKindOf(context);

    Widget? usernameWidget;
    if (message.user case final user? when channelKind == .group && user.id != currentUser?.id) {
      usernameWidget = Text(user.name, maxLines: 1, overflow: .ellipsis);
    }

    Widget? statusWidget;
    if (message.user case final user? when user.id == currentUser?.id) {
      statusWidget = StreamMessageSendingStatus(message: message);
    }

    final Widget timestampWidget;
    if (message.createdAt case final createdAt) {
      timestampWidget = StreamTimestamp(
        date: createdAt.toLocal(),
        formatter: (context, date) => Jiffy.parseFromDateTime(date).jm,
      );
    }

    Widget? editedWidget;
    if (message.messageTextUpdatedAt != null) {
      editedWidget = Text(context.translations.editedMessageLabel);
    }

    return core.StreamMessageMetadata(
      username: usernameWidget,
      status: statusWidget,
      timestamp: timestampWidget,
      edited: editedWidget,
    );
  }
}
