import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final client = Client('qk4nn7rpcn75');
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
  ChannelClient _channelClient;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChannelPage(_channelClient),
    );
  }

  @override
  void initState() {
    super.initState();

    final streamChat = StreamChat.of(context);
    _channelClient = streamChat.client.channel('messaging', id: 'godevs');

    streamChat
        .setUser(
      User(id: "wild-breeze-7"),
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoid2lsZC1icmVlemUtNyJ9.VM2EX1EXOfgqa-bTH_3JzeY0T99ngWzWahSauP3dBMo',
    )
        .then((_) {
      _channelClient.watch();
    });
  }

  @override
  void dispose() {
    StreamChat.of(context).dispose();
    super.dispose();
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
