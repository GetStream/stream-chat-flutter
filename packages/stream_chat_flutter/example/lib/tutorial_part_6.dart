// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// Sixth step of the [tutorial](https://getstream.io/chat/flutter/tutorial/)
///
/// The Flutter SDK ships fully designed widgets that you can theme to match
/// your app. Theming works in two layers:
///
/// 1. Design tokens — a [StreamTheme] registered as a [ThemeData] extension.
///    Set a brand color here and Stream derives the rest of its semantic
///    palette from the swatch automatically.
/// 2. Per-widget overrides — a [StreamChatThemeData] passed via
///    [StreamChat.themeData]. Tweak individual components without touching
///    the rest of the theme.
///
/// First, we register a [StreamTheme] on both [MaterialApp.theme] and
/// [MaterialApp.darkTheme] with a custom green brand swatch. Message
/// bubbles, sending indicators, unread badges, the composer cursor, and
/// other accents pick up the new tone in one go.
///
/// On top of that, we build a [StreamChatThemeData] override for
/// [StreamChatThemeData.channelListItemTheme]: bold titles and a
/// light-green tile background that reuses `greenBrand.shade100`, the
/// same shade Stream uses for outgoing message bubbles, so the channel
/// list and the message list share the same green tone.
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
        backgroundColor: WidgetStateProperty.all(greenBrand.shade100),
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
