import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sample_app/pages/channel_page.dart';
import 'package:sample_app/pages/thread_page.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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
                  child: const StreamSvgIcon(
                    size: 24,
                    icon: StreamSvgIcons.delete,
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
            child: defaultWidget,
          );
        },
        onDraftTap: (draft) {
          final client = StreamChat.of(context).client;

          final [channelType, channelId] = draft.channelCid.split(':');
          final channel = client.channel(channelType, id: channelId);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  channel: channel,
                  initialMessageId: draft.parentId,
                  child: switch (draft.parentMessage) {
                    final parent? => ThreadPage(
                      parent: parent.copyWith(draft: draft),
                    ),
                    _ => const ChannelPage(),
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
