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
            onThreadTap: (thread) {
              GoRouter.of(context).pushNamed(
                Routes.THREAD_PAGE.name,
                extra: thread,
              );
            },
          ),
        ),
      ],
    );
  }
}
