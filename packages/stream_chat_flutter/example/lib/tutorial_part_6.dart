// ignore_for_file: public_member_api_docs
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
    'b67pax5b2wdq',
    logLevel: Level.INFO,
  );

  await client.connectUser(
    User(id: 'tutorial-flutter'),
    '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoidHV0b3JpYWwtZmx1dHRlciJ9.S-MJpoSwDiqyXpUURgO5wVqJ4vKlIVFLSEyrFYCOE1c''',
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
    final greenBrand = StreamColorSwatch.fromColor(Colors.green);
    final greenBrandDark = StreamColorSwatch.fromColor(Colors.green, brightness: Brightness.dark);
    final customTheme = StreamChatThemeData(
      channelListItemTheme: StreamChannelListItemThemeData(
        titleStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.green.shade100;
          }
          return null;
        }),
      ),
    );

    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        extensions: [
          StreamTheme(
            brightness: Brightness.light,
            colorScheme: StreamColorScheme.light(brand: greenBrand),
          ),
        ],
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: [
          StreamTheme(
            brightness: Brightness.dark,
            colorScheme: StreamColorScheme.dark(brand: greenBrandDark),
          ),
        ],
      ),
      builder: (context, child) => StreamChat(
        client: client,
        themeData: customTheme,
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
    final colorScheme = context.streamColorScheme;

    return Scaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: const StreamChannelListHeader(),
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

/// Displays the list of messages inside the channel.
class ChannelPage extends StatelessWidget {
  const ChannelPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return Scaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: const StreamChannelHeader(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              threadBuilder: (_, parentMessage) => ThreadPage(
                parent: parentMessage!,
              ),
            ),
          ),
          StreamMessageComposer(),
        ],
      ),
    );
  }
}

/// Displays the thread replies for a parent message.
class ThreadPage extends StatefulWidget {
  const ThreadPage({
    super.key,
    required this.parent,
  });

  /// The root message this thread is replying to.
  final Message parent;

  @override
  State<ThreadPage> createState() => _ThreadPageState();
}

class _ThreadPageState extends State<ThreadPage> {
  late final _controller = StreamMessageComposerController(
    message: Message(parentId: widget.parent.id),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.streamColorScheme;

    return Scaffold(
      backgroundColor: colorScheme.backgroundApp,
      appBar: StreamThreadHeader(
        parent: widget.parent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: widget.parent,
            ),
          ),
          StreamMessageComposer(
            messageComposerController: _controller,
          ),
        ],
      ),
    );
  }
}
