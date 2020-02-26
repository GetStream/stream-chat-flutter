import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  final client = Client('qk4nn7rpcn75');

  await client.setUser(
    User(id: 'wild-breeze-7'),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo',
  );

  runApp(
    StreamChat(
      client: client,
      child: MaterialApp(
        home: ChannelListPage(),
      ),
    ),
  );
}

class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChannelListView(
        filter: {
          'members': {
            '\$in': [StreamChat.of(context).user.id],
          },
        },
        channelPreviewBuilder: _channelPreviewBuilder,
        sort: [SortOption('last_message_at')],
        pagination: PaginationParams(
          limit: 20,
        ),
        channelWidget: ChannelPage(),
      ),
    );
  }

  Widget _channelPreviewBuilder(BuildContext context, Channel channel) {
    return ListTile(
      leading: ChannelImage(
        channel: channel,
      ),
      title: ChannelName(
        channel: channel,
      ),
      trailing: channel.state.unreadCount > 0
          ? CircleAvatar(
              radius: 10,
              child: Text(channel.state.unreadCount.toString()),
            )
          : SizedBox(),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}
