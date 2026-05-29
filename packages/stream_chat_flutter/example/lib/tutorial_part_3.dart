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
/// We're passing a custom widget
/// to [StreamChannelListView.itemBuilder];
/// this will override the default [StreamChannelListItem] and allows you
/// to create one yourself.
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
    super.key,
    required this.client,
  });

  /// Instance of [StreamChatClient] we created earlier. This contains
  /// information about our application and connection state.
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

/// Displays the list of channels for the current user.
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
    channelStateSort: const [SortOption.desc('last_message_at')],
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
        itemBuilder: _channelTileBuilder,
        onChannelTap: (channel) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return StreamChannel(
                  channel: channel,
                  child: const ChannelPage(),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _channelTileBuilder(
    BuildContext context,
    List<Channel> channels,
    int index,
    StreamChannelListItem defaultChannelListItem,
  ) {
    final channel = channels[index];
    final lastMessage = channel.state?.messages.reversed.firstWhereOrNull(
      (message) => !message.isDeleted,
    );

    final subtitle = lastMessage == null ? 'nothing yet' : lastMessage.text!;
    final unreadCount = channel.state?.unreadCount ?? 0;
    final opacity = unreadCount > 0 ? 1.0 : 0.5;

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
      leading: StreamChannelAvatar(
        channel: channel,
      ),
      title: StreamChannelName(
        channel: channel,
        textStyle: StreamChannelListItemTheme.of(context).titleStyle?.copyWith(
          color: context.streamColorScheme.textPrimary.withValues(alpha: opacity),
        ),
      ),
      subtitle: Text(subtitle),
      trailing: unreadCount > 0
          ? CircleAvatar(
              radius: 10,
              child: Text(unreadCount.toString()),
            )
          : const SizedBox(),
    );
  }
}

/// Displays the list of messages inside the channel.
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
          const Expanded(
            child: StreamMessageListView(),
          ),
          StreamMessageComposer(),
        ],
      ),
    );
  }
}
