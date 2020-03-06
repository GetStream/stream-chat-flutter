import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Third step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// So far you’ve learned how to use the default widgets.
/// The library has been designed with composition in mind and to allow all common customizations to be very easy.
/// This means that you can change any component in your application by swapping the default widgets with the ones you build yourself.
///
/// Let’s see how we can make some changes to the SDK’s UI components.
/// We start by changing how channel previews are shown in the channel list and include the number of unread messages for each.
///
/// We're passing a custom widget to [ChannelListView.channelPreviewBuilder], this will override the default [ChannelPreview] and allows you to create one yourself.
///
/// There are a couple interesting things we do in this widget:
///
/// - Instead of creating a whole new style for the channel name, we inherit the text style from the parent theme ([StreamChatTheme.of]) and only change the color attribute
///
/// - We loop over the list of channel messages to search for the first not deleted message ([Channel.state.messages])
///
/// - We retrieve the count of unread messages from [Channel.state]
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
      body: ChannelListView(
        filter: {
          'members': {
            '\$in': [StreamChat.of(context).user.id],
          },
        },
        channelPreviewBuilder: _channelPreviewBuilder,
        sort: [SortOption('last_message_at')],
        pagination: PaginationParams(
          limit: 20,
        ),
        channelWidget: ChannelPage(),
      ),
    );
  }

  Widget _channelPreviewBuilder(BuildContext context, Channel channel) {
    final lastMessage = channel.state.messages.reversed.firstWhere(
      (message) => message.type != "deleted",
      orElse: () => null,
    );

    final subtitle = (lastMessage == null ? "nothing yet" : lastMessage.text);
    final opacity = channel.state.unreadCount > .0 ? 1.0 : 0.5;

    return ListTile(
      leading: ChannelImage(),
      title: ChannelName(
        textStyle:
            StreamChatTheme.of(context).channelPreviewTheme.title.copyWith(
                  color: Colors.black.withOpacity(opacity),
                ),
      ),
      subtitle: Text(subtitle),
      trailing: channel.state.unreadCount > 0
          ? CircleAvatar(
              radius: 10,
              child: Text(channel.state.unreadCount.toString()),
            )
          : SizedBox(),
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
