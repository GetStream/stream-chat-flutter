import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'pages/group_info_page.dart';

/// Opens [channel], or the thread of [parent] in it when given.
///
/// [messageId] is the message the list opens on instead of the newest one —
/// inside the thread when [parent] is given.
Future<void> openChannel(
  BuildContext context,
  Channel channel, {
  String? messageId,
  Message? parent,
  bool replace = false,
}) {
  final route = MaterialPageRoute<void>(
    builder: (_) => StreamChannel(
      channel: channel,
      initialMessageId: messageId,
      openAtFirstUnread: false,
      child: switch (parent) {
        final parent? => StreamThreadPage(
          parent: parent,
          onViewInChannelTap: (message) => openChannel(context, channel, messageId: message.id, replace: true),
        ),
        _ => const StreamChannelPage(onChannelAvatarPressed: openGroupInfo),
      },
    ),
  );

  final navigator = Navigator.of(context);
  return replace ? navigator.pushReplacement(route) : navigator.push(route);
}

/// Opens the message [messageId] of [channel] on that message, inside its
/// thread when it is a reply.
Future<void> openMessage(BuildContext context, Channel channel, String messageId) async {
  final client = StreamChat.of(context).client;
  if (channel.state == null) await channel.watch();

  final message = (await client.getMessage(messageId)).message;
  final parentId = message.parentId;
  final parent = parentId == null ? null : (await client.getMessage(parentId)).message;
  if (!context.mounted) return;
  return openChannel(context, channel, messageId: messageId, parent: parent);
}

Future<void> openGroupInfo(BuildContext context, Channel channel) {
  return Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => StreamChannel(channel: channel, child: const GroupInfoPage()),
    ),
  );
}
