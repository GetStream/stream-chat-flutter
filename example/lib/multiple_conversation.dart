import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  final client = Client('s2dxdhpxd94g', logLevel: Level.INFO);

  await client.setUser(
    User(id: 'still-resonance-3'),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3RpbGwtcmVzb25hbmNlLTMifQ.e6BGSX21gLZYpls_rFX8PB2SfGlfdpvv00pQiVW70VQ',
  );

  runApp(MyApp(client));
}

class MyApp extends StatelessWidget {
  final Client client;

  MyApp(this.client);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        child: StreamChat(
          client: client,
          child: ChannelListPage(),
        ),
      ),
    );
  }
}

class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChannelListView(
        filter: {
          'members': {
            '\$in': [StreamChat.of(context).user.id],
          }
        },
        sort: [SortOption('last_message_at')],
        pagination: PaginationParams(
          limit: 20,
        ),
        channelWidget: ChannelPage(),
      ),
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
      appBar: ChannelHeader(),
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
