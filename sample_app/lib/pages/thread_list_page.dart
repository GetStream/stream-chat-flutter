import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_app/routes/routes.dart';
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
    return ValueListenableBuilder<Set<String>>(
      valueListenable: controller.unseenThreadIds,
      builder: (context, unseenThreadIds, child) => StreamUnreadThreadsBanner(
        enabled: unseenThreadIds.isNotEmpty,
        unreadThreads: unseenThreadIds,
        onRefresh: () async {
          await controller.refresh(resetValue: false);
          controller.clearUnseenThreadIds();
        },
        child: child,
      ),
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
                  child: BetterStreamBuilder<Message>(
                    initialData: thread.parentMessage,
                    stream: channel.state?.messagesStream
                        .map(
                          (messages) => messages.firstWhereOrNull(
                            (m) => m.id == thread.parentMessage?.id,
                          ),
                        )
                        .where((msg) => msg != null)
                        .cast<Message>(),
                    builder: (_, parentMessage) {
                      return StreamThreadPage(
                        parent: parentMessage,
                        onViewInChannelTap: (message) {
                          GoRouter.of(context).goNamed(
                            Routes.CHANNEL_PAGE.name,
                            pathParameters: Routes.CHANNEL_PAGE.params(channel),
                            queryParameters: {'mid': message.id},
                          );
                        },
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
