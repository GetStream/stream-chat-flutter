// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Sixth step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// The Flutter SDK comes with a fully designed set of widgets which you can customize to fit with your application style and typography.
/// Changing the theme of Chat widgets works in a very similar way that [MaterialApp] and [Theme] do.
///
/// Out of the box all chat widgets use their own default styling, there are two ways to change the styling:
///
/// 1. Initialize the [StreamChatTheme] from your existing [MaterialApp] style
/// 2. Construct a custom theme and provide all the customizations needed
///
/// First we create a new Material [Theme] and pick [Colors.green] as swatch color. The theme is then passed to [MaterialApp] as usual.
///
/// Then we create a new [StreamChatTheme] from the green theme we just created.
/// After saving the app you will see the UI will update several widgets to match with the new color.
///
/// We also change the message color posted by the current user.
/// You can perform these more granular style changes using [StreamChatTheme.copyWith].
void main() async {
  final client = StreamChatClient(
    's2dxdhpxd94g',
    logLevel: Level.INFO,
  );

  await client.connectUser(
    User(id: 'super-band-9'),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A',
  );

  runApp(MyApp(client));
}

class MyApp extends StatelessWidget {
  final StreamChatClient client;

  MyApp(this.client);

  @override
  Widget build(BuildContext context) {
    final themeData = ThemeData(primarySwatch: Colors.green);
    final defaultTheme = StreamChatThemeData.fromTheme(themeData);
    final colorTheme = defaultTheme.colorTheme;
    final customTheme = defaultTheme.merge(StreamChatThemeData(
      channelPreviewTheme: ChannelPreviewTheme(
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      otherMessageTheme: MessageTheme(
        messageBackgroundColor: colorTheme.textHighEmphasis,
        messageText: TextStyle(
          color: colorTheme.barsBg,
        ),
        avatarTheme: AvatarTheme(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ));

    return MaterialApp(
      theme: themeData,
      builder: (context, child) {
        return StreamChat(
          client: client,
          streamChatThemeData: customTheme,
          child: child,
        );
      },
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
          filter: Filter.in_(
            'members',
            [StreamChat.of(context).user!.id],
          ),
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              threadBuilder: (_, parentMessage) {
                return ThreadPage(
                  parent: parentMessage,
                );
              },
            ),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}

class ThreadPage extends StatelessWidget {
  final Message? parent;

  ThreadPage({
    Key? key,
    this.parent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThreadHeader(
        parent: parent!,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: MessageListView(
              parentMessage: parent,
            ),
          ),
          MessageInput(
            parentMessage: parent,
          ),
        ],
      ),
    );
  }
}
