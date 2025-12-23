import 'package:flutter/material.dart';
import 'package:sample_app/pages/thread_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class ThreadListPage extends StatefulWidget {
  const ThreadListPage({super.key});

  @override
  State<ThreadListPage> createState() => _ThreadListPageState();
}

class _ThreadListPageState extends State<ThreadListPage> {
  late final controller = StreamThreadListController(
    client: StreamChat.of(context).client,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder(
          valueListenable: controller.unseenThreadIds,
          builder: (_, unreadThreads, __) => StreamUnreadThreadsBanner(
            unreadThreads: unreadThreads,
            onTap: () => controller
                .refresh(resetValue: false)
                .then((_) => controller.clearUnseenThreadIds()),
          ),
        ),
        Expanded(
          child: StreamThreadListView(
            controller: controller,
            onThreadTap: (thread) async {
              final channelCid = thread.channelCid;

              final channel = StreamChat.of(context).client.channel(
                    channelCid.split(':')[0],
                    id: channelCid.split(':')[1],
                  );

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return StreamChannel(
                      channel: channel,
                      initialMessageId: thread.draft?.parentId,
                      child: BetterStreamBuilder(
                        stream: channel.state?.messagesStream.map(
                          (messages) => messages.firstWhere(
                            (m) => m.id == thread.parentMessage!.id,
                          ),
                        ),
                        builder: (_, parentMessage) {
                          return ThreadPage(parent: parentMessage);
                        },
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
