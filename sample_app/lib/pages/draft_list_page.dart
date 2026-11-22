import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../routes/routes.dart';
import '../widgets/split_view.dart';
import '../widgets/stream_draft_list_view.dart';

class DraftListPage extends StatefulWidget {
  const DraftListPage({super.key});

  @override
  State<DraftListPage> createState() => _DraftListPageState();
}

class _DraftListPageState extends State<DraftListPage> {
  late final controller = StreamDraftListController(
    client: StreamChat.of(context).client,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final openRoute = switch (AdaptiveSplitView.isExpandedOf(context)) {
      true => GoRouterState.of(context),
      false => null,
    };
    final openCid = openRoute?.pathParameters['cid'];
    final openThreadId = openRoute?.uri.queryParameters['pid'];

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: StreamDraftListView(
        controller: controller,
        itemBuilder: (context, drafts, index, defaultWidget) {
          final draft = drafts[index];

          return Slidable(
            groupTag: 'draft-actions',
            endActionPane: ActionPane(
              extentRatio: 0.20,
              motion: const BehindMotion(),
              children: [
                CustomSlidableAction(
                  backgroundColor: Colors.red,
                  child: Icon(
                    context.streamIcons.delete,
                    size: 24,
                    color: Colors.white,
                  ),
                  onPressed: (context) {
                    final client = StreamChat.of(context).client;
                    final [type, id] = draft.channelCid.split(':');
                    final parentId = draft.parentId;

                    client.deleteDraft(id, type, parentId: parentId).ignore();
                  },
                ),
              ],
            ),
            child: defaultWidget.copyWith(
              selected: draft.channelCid == openCid && draft.parentId == openThreadId,
            ),
          );
        },
        onDraftTap: (draft) {
          final client = StreamChat.of(context).client;

          final [channelType, channelId] = draft.channelCid.split(':');
          final channel = client.channel(channelType, id: channelId);

          GoRouter.of(context).goNamed(
            Routes.CHANNEL_PAGE.name,
            pathParameters: Routes.CHANNEL_PAGE.params(channel),
            queryParameters: switch (draft.parentId) {
              final parentId? => {'mid': parentId, 'pid': parentId},
              _ => const <String, String>{},
            },
            // The thread's parent may not be loaded in the channel yet.
            extra: draft.parentMessage?.copyWith(draft: draft),
          );
        },
      ),
    );
  }
}
