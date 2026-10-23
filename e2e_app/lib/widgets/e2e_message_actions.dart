import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The id the last "Copy Message ID" copied.
///
/// "Open Message by ID" reads it from here rather than from the system clipboard,
/// which Android may refuse to read back (an app without input focus gets nothing).
/// The id still goes on the clipboard for manual use.
String? lastCopiedMessageId;

/// Adds the message actions the native test apps offer and the SDK does not:
///
///  * "Hard Delete Message", for the user's own messages — the SDK only
///    offers a hard delete for a message that failed to send.
///  * "Copy Message ID", so a test can open the message later by its id.
Widget e2eMessageItemBuilder(BuildContext context, StreamMessageItemProps props) {
  final message = props.message;

  return DefaultStreamMessageItem(
    props: props.copyWith(
      actionsBuilder: (context, defaultActions) {
        final currentUser = StreamChat.of(context).currentUser;
        final isOwn = message.user?.id == currentUser?.id;
        final canHardDelete = isOwn && !message.isDeleted && !message.state.isFailed;

        return StreamContextMenuAction.partitioned(
          items: [
            ...defaultActions,
            if (canHardDelete)
              StreamContextMenuAction.destructive(
                label: const Text('Hard Delete Message'),
                leading: Icon(context.streamIcons.delete),
                onTap: () => StreamChannel.of(context).channel.deleteMessage(message, hard: true).ignore(),
              ),
            StreamContextMenuAction(
              label: const Text('Copy Message ID'),
              leading: Icon(context.streamIcons.copy),
              onTap: () {
                lastCopiedMessageId = message.id;
                Clipboard.setData(ClipboardData(text: message.id)).ignore();
              },
            ),
          ],
        );
      },
    ),
  );
}
