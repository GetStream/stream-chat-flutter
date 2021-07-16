// ignore_for_file: public_member_api_docs
import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Third step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// So far you’ve learned how to use the default widgets.
/// The library has been designed with composition in mind and to allow all
/// common customizations to be very easy.
/// This means that you can change any component in your application by
/// swapping the default widgets with the ones you build yourself.
///
/// Let’s see how we can make some changes to the SDK’s UI components.
/// We start by changing how channel previews are shown in the channel list
/// and include the number of unread messages for each.
///
/// We're passing a custom widget to [ChannelListView.channelPreviewBuilder];
/// this will override the default [ChannelPreview] and allows you to create
/// one yourself.
///
/// There are a couple interesting things we do in this widget:
///
/// - Instead of creating a whole new style for the channel name, we inherit
/// the text style from the parent theme ([StreamChatTheme.of]) and only
/// change the color attribute
///
/// - We loop over the list of channel messages to search for the first not
/// deleted message ([Channel.state.messages])
///
/// - We retrieve the count of unread messages from [Channel.state]
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
    Key? key,
    required this.client,
  }) : super(key: key);

  final StreamChatClient client;

  @override
  // ignore: prefer_expression_function_bodies
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

class ChannelListPage extends StatelessWidget {
  const ChannelListPage({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChannelsBloc(
        child: ChannelListView(
          filter: Filter.in_(
            'members',
            [StreamChat.of(context).user!.id],
          ),
          channelPreviewBuilder: _channelPreviewBuilder,
          // sort: [SortOption('last_message_at')],
          pagination: const PaginationParams(
            limit: 20,
          ),
          channelWidget: const ChannelPage(),
        ),
      ),
    );
  }

  Widget _channelPreviewBuilder(BuildContext context, Channel channel) {
    final lastMessage = channel.state?.messages.reversed.firstWhereOrNull(
      (message) => !message.isDeleted,
    );

    final subtitle = lastMessage == null ? 'nothing yet' : lastMessage.text!;
    final opacity = (channel.state?.unreadCount ?? 0) > 0 ? 1.0 : 0.5;

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StreamChannel(
              channel: channel,
              child: const ChannelPage(),
            ),
          ),
        );
      },
      leading: ChannelAvatar(
        channel: channel,
      ),
      title: ChannelName(
        textStyle:
            StreamChatTheme.of(context).channelPreviewTheme.title!.copyWith(
                  color: StreamChatTheme.of(context)
                      .colorTheme
                      .textHighEmphasis
                      .withOpacity(opacity),
                ),
      ),
      subtitle: Text(subtitle),
      trailing: channel.state!.unreadCount > 0
          ? CircleAvatar(
              radius: 10,
              child: Text(channel.state!.unreadCount.toString()),
            )
          : const SizedBox(),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ChannelHeader(),
      body: Column(
        children: const <Widget>[
          Expanded(
            child: MessageListView(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}
