import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  final client = Client(
    'qk4nn7rpcn75',
    logLevel: Level.INFO,
  );

  await client.setUser(
    User(id: 'wild-breeze-7'),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo',
  );

  final channel = client.channel('messaging', id: 'godevs');

  // ignore: unawaited_futures
  channel.watch();

  runApp(
    StreamChat(
      client: client,
      child: MaterialApp(
        home: StreamChannel(
          channel: channel,
          child: ChannelPage(),
        ),
      ),
    ),
  );
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
