import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  final client = Client('qk4nn7rpcn75');

  await client.setUser(
    User(id: "wild-breeze-7"),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo',
  );

  runApp(StreamChat(
    client: client,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChannelListPage(),
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
        sort: [SortOption("last_message_at")],
        pagination: PaginationParams(
          limit: 20,
        ),
        onChannelTap: (channelClient) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ChannelPage(channelClient);
          }));
        },
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  ChannelPage(this.channelClient);

  final ChannelClient channelClient;

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channelClient: channelClient,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Expanded(child: MessageListView()),
            MessageInput(),
          ],
        ),
      ),
    );
  }
}
