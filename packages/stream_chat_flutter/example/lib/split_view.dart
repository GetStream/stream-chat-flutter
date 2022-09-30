// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Future<void> main() async {
  final client = StreamChatClient(
    's2dxdhpxd94g',
    logLevel: Level.INFO,
  );

  await client.connectUser(
    User(id: 'super-band-9'),
    '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A''',
  );

  runApp(
    MyApp(
      client: client,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.client,
  });

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
      ),
      home: const SplitView(),
    );
  }
}

class SplitView extends StatefulWidget {
  const SplitView({
    super.key,
  });

  @override
  _SplitViewState createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  Channel? selectedChannel;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Flexible(
          child: ChannelListPage(
            onTap: (channel) {
              setState(() {
                selectedChannel = channel;
              });
            },
          ),
        ),
        Flexible(
          flex: 2,
          child: Scaffold(
            body: selectedChannel != null
                ? StreamChannel(
                    key: ValueKey(selectedChannel!.cid),
                    channel: selectedChannel!,
                    child: const ChannelPage(),
                  )
                : Center(
                    child: Text(
                      'Pick a channel to show the messages 💬',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    super.key,
    this.onTap,
  });

  final void Function(Channel)? onTap;

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _listController = StreamChannelListController(
    client: StreamChat.of(context).client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    sort: const [SortOption('last_message_at')],
    limit: 20,
  );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamChannelListView(
          onChannelTap: widget.onTap,
          controller: _listController,
        ),
      );
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: const StreamChannelHeader(
              showBackButton: false,
            ),
            body: Column(
              children: const <Widget>[
                Expanded(
                  child: StreamMessageListView(),
                ),
                StreamMessageInput(),
              ],
            ),
          ),
        ),
      );
}
