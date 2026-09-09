// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// The entry screen from Step 4 of the
/// [Flutter Chat tutorial](https://getstream.io/chat/sdk/flutter/tutorial/).
///
/// [StreamChannelListController] owns the query, pagination, and live updates;
/// [StreamChannelListView] renders it. Tapping a channel pushes
/// [StreamChannelPage], the SDK's ready-made conversation screen - it wires up
/// the header, message list, composer, and threads for you.
///
/// Shared by all three `main_step*.dart` entry points.
class ChannelListPage extends StatefulWidget {
  const ChannelListPage({super.key});

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  /// Queries channels the current user belongs to, newest activity first.
  /// The controller owns pagination and live updates.
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_('members', [StreamChat.of(context).currentUser!.id]),
    channelStateSort: const [SortOption.desc('last_message_at')],
    limit: 20,
  );

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.streamColorScheme.backgroundApp,
      appBar: const StreamChannelListHeader(),
      body: StreamChannelListView(
        controller: _listController,
        onChannelTap: (channel) => Navigator.of(context).push(
          MaterialPageRoute(
            /// `StreamChannel` scopes the tapped channel to the subtree and
            /// calls `watch()` on it, so `StreamChannelPage` needs no arguments.
            builder: (_) => StreamChannel(
              channel: channel,
              child: const StreamChannelPage(),
            ),
          ),
        ),
      ),
    );
  }
}
