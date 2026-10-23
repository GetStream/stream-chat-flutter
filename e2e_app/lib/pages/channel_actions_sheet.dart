import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../navigation.dart';

/// The sheet a long press (or the swipe's "more" action) opens on a channel.
Future<void> showChannelActionsSheet(BuildContext context, Channel channel) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: _ChannelActions(channel: channel, hostContext: context),
    ),
  );
}

class _ChannelActions extends StatelessWidget {
  const _ChannelActions({required this.channel, required this.hostContext});

  final Channel channel;

  /// The page the sheet was opened from, which outlives the sheet.
  final BuildContext hostContext;

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    final currentUserId = StreamChat.of(context).currentUser?.id;
    final otherMember = channel.isOneToOne
        ? channel.state?.members.where((it) => it.userId != currentUserId).firstOrNull?.user
        : null;

    void run(Future<void> Function() action) {
      Navigator.of(context).pop();
      action().ignore();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(title: const Text('View Info'), onTap: () => run(() => openGroupInfo(hostContext, channel))),
        BetterStreamBuilder<bool>(
          stream: channel.isPinnedStream,
          initialData: channel.isPinned,
          builder: (context, isPinned) => ListTile(
            title: Text(isPinned ? 'Unpin Chat' : 'Pin Chat'),
            onTap: () => run(isPinned ? channel.unpin : channel.pin),
          ),
        ),
        if (otherMember case final user?) ...[
          ListTile(title: const Text('Mute User'), onTap: () => run(() => client.muteUser(user.id))),
          ListTile(title: const Text('Block User'), onTap: () => run(() => client.blockUser(user.id))),
        ] else
          ListTile(
            title: const Text('Leave Group'),
            onTap: () => run(() => _leave(hostContext, channel, currentUserId)),
          ),
        ListTile(
          title: Text(channel.isOneToOne ? 'Delete Chat' : 'Delete Group'),
          onTap: () => run(() => _delete(hostContext, channel)),
        ),
        // Debug: opens the message whose id "Copy Message ID" put on the clipboard.
        ListTile(
          title: const Text('Open Message by ID'),
          onTap: () => run(() async {
            final messageId = (await Clipboard.getData(Clipboard.kTextPlain))?.text;
            if (messageId == null || messageId.isEmpty || !hostContext.mounted) return;
            return openMessage(hostContext, channel, messageId);
          }),
        ),
      ],
    );
  }
}

Future<void> _leave(BuildContext context, Channel channel, String? userId) async {
  if (userId == null) return;
  final confirmed = await _confirm(
    context,
    title: 'Leave group',
    content: 'Are you sure you want to leave this group?',
    confirmLabel: 'Leave',
  );
  if (confirmed) await channel.removeMembers([userId]);
}

Future<void> _delete(BuildContext context, Channel channel) async {
  final subject = channel.isOneToOne ? 'conversation' : 'group';
  final confirmed = await _confirm(
    context,
    title: 'Delete $subject',
    content: 'Are you sure you want to delete this $subject?',
    confirmLabel: 'Delete',
  );
  if (confirmed) await channel.delete();
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String content,
  required String confirmLabel,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
        TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(confirmLabel)),
      ],
    ),
  );
  return confirmed ?? false;
}
