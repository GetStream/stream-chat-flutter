import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../routes/routes.dart';
import '../widgets/split_view.dart';

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
    final openThreadId = switch (AdaptiveSplitView.isExpandedOf(context)) {
      true => GoRouterState.of(context).uri.queryParameters['pid'],
      false => null,
    };

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
        itemBuilder: (context, threads, index, defaultWidget) {
          return defaultWidget.copyWith(selected: threads[index].parentMessageId == openThreadId);
        },
        onThreadTap: (thread) {
          final [type, id] = thread.channelCid.split(':');
          final channel = StreamChat.of(context).client.channel(type, id: id);

          GoRouter.of(context).goNamed(
            Routes.CHANNEL_PAGE.name,
            pathParameters: Routes.CHANNEL_PAGE.params(channel),
            queryParameters: {'mid': thread.parentMessageId, 'pid': thread.parentMessageId},
            // The thread's parent may not be loaded in the channel yet.
            extra: thread.parentMessage,
          );
        },
      ),
    );
  }
}
