import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Fifth step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// Customizing how messages are rendered is another very common use-case that the SDK supports easily.
///
/// Replace the built-in message component with your own is done by passing it as a builder function to the [MessageListView] widget.
///
/// The message builder function will get the usual [BuildContext] argument as well as the [Message] object and its position inside the list.
///
/// If you look at the code you can see that we use [StreamChat.of] to retrieve the current user so that we can style messages own messages in a different way.
///
/// Since custom widgets and builders are always children of [StreamChat] or part of a [Channel],
/// you can use [StreamChat.of], [StreamChannel.of] and [StreamChatTheme.of] to use the API client directly
/// or to retrieve outer scope needed such as messages from the [Channel.state].
void main() async {
  final client = Client(
    'b67pax5b2wdq',
    logLevel: Level.INFO,
  );

  await client.setUser(
    User(id: 'falling-mountain-7'),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiZmFsbGluZy1tb3VudGFpbi03In0.AKgRXHMQQMz6vJAKszXdY8zMFfsAgkoUeZHlI-Szz9E',
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
      home: ChannelListPage(),
    );
  }
}

class ChannelListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChannelsBloc(
        child: ChannelListView(
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
      appBar: ChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              messageBuilder: _messageBuilder,
            ),
          ),
          MessageInput(),
        ],
      ),
    );
  }

  Widget _messageBuilder(
    BuildContext context,
    MessageDetails details,
    List<Message> messages,
  ) {
    final message = details.message;
    final isCurrentUser = StreamChat.of(context).user.id == message.user.id;
    final textAlign = isCurrentUser ? TextAlign.right : TextAlign.left;
    final color = isCurrentUser ? Colors.blueGrey : Colors.blue;

    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: ListTile(
          title: Text(
            message.text,
            textAlign: textAlign,
          ),
          subtitle: Text(
            message.user.extraData['name'],
            textAlign: textAlign,
          ),
        ),
      ),
    );
  }
}
