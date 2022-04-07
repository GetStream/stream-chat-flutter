// ignore_for_file: public_member_api_docs
// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Second step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// Most chat applications handle more than just one single conversation.
/// Apps like Facebook Messenger, Whatsapp and Telegram allows you to have
/// multiple one-to-one and group conversations.
///
/// Let’s find out how we can change our application chat screen to display
/// the list of conversations and navigate between them.
///
/// > Note: the SDK uses Flutter’s [Navigator] to move from one route to
/// another. This allows us to avoid any boiler-plate code.
/// > Of course, you can take total control of how navigation works by
/// customizing widgets like [StreamChannel] and [StreamChannelListView].
///
/// If you run the application, you will see that the first screen shows a
/// list of conversations, you can open each by tapping and go back to the list.
///
/// Every single widget involved in this UI can be customized or swapped
/// with your own.
///
/// The [ChannelListPage] widget retrieves the list of channels based on a
/// custom query and ordering. In this case we are showing the list of
/// channels in which the current user is a member and we order them based
/// on the time they had a new message.
/// [StreamChannelListView] handles pagination
/// and updates automatically when new channels are created or when a new
/// message is added to a channel.
void main() async {
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
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => StreamChat(
        client: client,
        child: child,
      ),
      home: ChannelListPage(
        client: client,
      ),
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _controller = StreamChannelListController(
    client: widget.client,
    filter: Filter.in_(
      'members',
      [StreamChat.of(context).currentUser!.id],
    ),
    sort: const [SortOption('last_message_at')],
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: RefreshIndicator(
          onRefresh: _controller.refresh,
          child: StreamChannelListView(
            controller: _controller,
            onChannelTap: (channel) => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StreamChannel(
                  channel: channel,
                  child: const ChannelPage(),
                ),
              ),
            ),
          ),
        ),
      );
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const StreamChannelHeader(),
        body: Column(
          children: const <Widget>[
            Expanded(
              child: StreamMessageListView(),
            ),
            StreamMessageInput(),
          ],
        ),
      );
}
