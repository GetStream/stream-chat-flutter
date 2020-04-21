import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Second step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// Most chat applications handle more than just one single conversation.
/// Apps like Facebook Messenger, Whatsapp and Telegram allows you to have multiple one to one and group conversations.
///
/// Let’s find out how we can change our application chat screen to display the list of conversations and navigate between them.
///
/// > Note: the SDK uses Flutter’s [Navigator] to move from one route to another, this allows us to avoid any boiler-plate code.
/// > Of course you can take total control of how navigation works by customizing widgets like [Channel] and [ChannelList].
///
/// If you run the application, you will see that the first screen shows a list of conversations, you can open each by tapping and go back to the list.
///
/// Every single widget involved in this UI can be customized or swapped with your own.
///
/// The [ChannelListPage] widget retrieves the list of channels based on a custom query and ordering.
/// In this case we are showing the list of channels the current user is a member and we order them based on the time they had a new message.
/// [ChannelListView] handles pagination and updates automatically out of the box when new channels are created or when a new message is added to a channel.
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
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}
