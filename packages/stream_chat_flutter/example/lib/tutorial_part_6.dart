// ignore_for_file: public_member_api_docs
// ignore_for_file: prefer_expression_function_bodies

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Sixth step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// The Flutter SDK comes with a fully designed set of widgets which you can
/// customize to fit with your application style and typography.
/// Changing the theme of Chat widgets works in a very similar way that
/// [MaterialApp] and [Theme] do.
///
/// All chat widgets use their own default styling out of the box. There are
/// two ways to change the styling:
///
/// 1. Initialize the [StreamChatTheme] from your existing [MaterialApp] style
/// 2. Construct a custom theme and provide all the customizations needed
///
/// First, we create a new Material [Theme] and pick [Colors.green] as the
/// swatch color. The theme is then passed to [MaterialApp] as usual.
///
/// Then, we create a new [StreamChatTheme] from the green theme we just
/// created. After saving the app you will see that several widgets have
/// been updated with the new color.
///
/// We also change the message color posted by the current user.
///
/// You can perform these more granular style changes using
/// [StreamChatTheme.copyWith].
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
  Widget build(BuildContext context) {
    final themeData = ThemeData(primarySwatch: Colors.green);
    final defaultTheme = StreamChatThemeData.fromTheme(themeData);
    final colorTheme = defaultTheme.colorTheme;
    final customTheme = defaultTheme.merge(StreamChatThemeData(
      channelPreviewTheme: StreamChannelPreviewThemeData(
        avatarTheme: StreamAvatarThemeData(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      messageListViewTheme: const StreamMessageListViewThemeData(
        backgroundColor: Colors.grey,
        backgroundImage: DecorationImage(
          image: AssetImage('assets/background_doodle.png'),
          fit: BoxFit.cover,
        ),
      ),
      otherMessageTheme: StreamMessageThemeData(
        messageBackgroundColor: colorTheme.textHighEmphasis,
        messageTextStyle: TextStyle(
          color: colorTheme.barsBg,
        ),
        avatarTheme: StreamAvatarThemeData(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ));

    return MaterialApp(
      theme: themeData,
      builder: (context, child) => StreamChat(
        client: client,
        streamChatThemeData: customTheme,
        child: child,
      ),
      home: const ChannelListPage(),
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    Key? key,
  }) : super(key: key);

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
  Widget build(BuildContext context) => Scaffold(
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

class ChannelPage extends StatelessWidget {
  const ChannelPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const StreamChannelHeader(),
        body: Column(
          children: <Widget>[
            Expanded(
              child: StreamMessageListView(
                threadBuilder: (_, parentMessage) => ThreadPage(
                  parent: parentMessage,
                ),
              ),
            ),
            const StreamMessageInput(),
          ],
        ),
      );
}

class ThreadPage extends StatelessWidget {
  const ThreadPage({
    Key? key,
    this.parent,
  }) : super(key: key);

  final Message? parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamThreadHeader(
        parent: parent!,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: parent,
            ),
          ),
          StreamMessageInput(
            messageInputController: MessageInputController(
              message: Message(parentId: parent!.id),
            ),
          ),
        ],
      ),
    );
  }
}
