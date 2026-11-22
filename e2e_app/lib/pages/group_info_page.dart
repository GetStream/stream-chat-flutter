import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'pinned_messages_page.dart';

/// The channel's info screen, reached from the channel actions sheet or the
/// channel header's avatar.
class GroupInfoPage extends StatelessWidget {
  const GroupInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final channel = StreamChannel.of(context).channel;
    return Scaffold(
      appBar: AppBar(title: const Text('Group Info')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(context.streamIcons.pin),
            title: const Text('Pinned Messages'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => StreamChannel(channel: channel, child: const PinnedMessagesPage()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
