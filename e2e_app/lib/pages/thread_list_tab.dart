import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../navigation.dart';

/// The user's threads, opened on their latest reply.
class ThreadListTab extends StatefulWidget {
  const ThreadListTab({super.key});

  @override
  State<ThreadListTab> createState() => _ThreadListTabState();
}

class _ThreadListTabState extends State<ThreadListTab> {
  late final _controller = StreamThreadListController(client: StreamChat.of(context).client);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamThreadListView(
      controller: _controller,
      onThreadTap: (thread) async {
        final client = StreamChat.of(context).client;
        final [type, id] = thread.channelCid.split(':');
        final channel = client.channel(type, id: id);
        if (channel.state == null) await channel.watch();
        final parent = thread.parentMessage ?? (await client.getMessage(thread.parentMessageId)).message;
        if (!context.mounted) return;
        return openChannel(context, channel, parent: parent);
      },
    );
  }
}
