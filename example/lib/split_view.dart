import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() async {
  final client = Client(
    's2dxdhpxd94g',
    logLevel: Level.INFO,
  );

  await client.setUser(
    User(id: 'super-band-9'),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A',
  );

  runApp(MyApp(client));
}

class MyApp extends StatelessWidget {
  final Client client;

  MyApp(this.client);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => StreamChat(
        child: child,
        client: client,
      ),
      home: SplitView(),
    );
  }
}

class SplitView extends StatefulWidget {
  @override
  _SplitViewState createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  Channel selectedChannel;

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
          flex: 1,
        ),
        Flexible(
          child: selectedChannel != null
              ? StreamChannel(
                  key: ValueKey(selectedChannel.cid),
                  child: ChannelPage(),
                  channel: selectedChannel,
                )
              : Scaffold(
                  body: Center(
                    child: Text(
                      'Pick a channel to show the messages 💬',
                      style: Theme.of(context).textTheme.headline,
                    ),
                  ),
                ),
          flex: 2,
        ),
      ],
    );
  }
}

class ChannelListPage extends StatelessWidget {
  final void Function(Channel) onTap;

  ChannelListPage({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChannelsBloc(
        child: ChannelListView(
          onChannelTap: onTap != null
              ? (channel, _) {
                  onTap(channel);
                }
              : null,
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
      appBar: ChannelHeader(
        showBackButton: false,
      ),
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
