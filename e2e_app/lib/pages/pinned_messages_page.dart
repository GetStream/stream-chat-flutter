import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The channel's pinned messages, found through message search.
class PinnedMessagesPage extends StatefulWidget {
  const PinnedMessagesPage({super.key});

  @override
  State<PinnedMessagesPage> createState() => _PinnedMessagesPageState();
}

class _PinnedMessagesPageState extends State<PinnedMessagesPage> {
  late final _controller = StreamMessageSearchListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('cid', [StreamChannel.of(context).channel.cid!]),
    messageFilter: Filter.equal('pinned', true),
    sort: const [SortOption.asc('created_at')],
    limit: 20,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pinned Messages')),
      body: StreamMessageSearchListView(
        controller: _controller,
        emptyBuilder: (_) => const Center(child: Text('No pinned messages')),
      ),
    );
  }
}
