// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Fifth step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// Customizing how messages are rendered is another very common use-case that
/// the SDK supports easily.
///
/// Replacing the built-in message component with your own is done by passing
/// it as a builder function to the [StreamMessageListView] widget.
///
/// The message builder function will get the usual [BuildContext] argument
/// as well as the [Message] object and its position inside the list.
///
/// If you look at the code you can see that we use [StreamChat.of] to
/// retrieve the current user so that we can style messages in a different way.
///
/// Since custom widgets and builders are always children of [StreamChat] or
/// part of a [Channel], you can use [StreamChat.of], [StreamChannel.of],
/// and [StreamChatTheme.of] to use the API client directly or to retrieve
/// outer scope needed such as messages from the [Channel.state].
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
      home: const ChannelListPage(),
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    super.key,
  });

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
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamChannelListView(
        controller: _listController,
        onChannelTap: (channel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => StreamChannel(
                channel: channel,
                child: const ChannelPage(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              messageBuilder: _messageBuilder,
            ),
          ),
          const StreamMessageInput(),
        ],
      ),
    );
  }

  Widget _messageBuilder(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
    StreamMessageWidget _,
  ) {
    final message = details.message;
    final isCurrentUser =
        StreamChat.of(context).currentUser!.id == message.user!.id;
    final textAlign = isCurrentUser ? TextAlign.right : TextAlign.left;
    final color = isCurrentUser ? Colors.blueGrey : Colors.blue;

    return Padding(
      padding: const EdgeInsets.all(5),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(5),
          ),
        ),
        child: ListTile(
          title: Text(
            message.text!,
            textAlign: textAlign,
          ),
          subtitle: Text(
            message.user!.name,
            textAlign: textAlign,
          ),
        ),
      ),
    );
  }
}
