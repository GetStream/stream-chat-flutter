import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_chat_localizations/stream_chat_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Create a new instance of [StreamChatClient] passing the apikey obtained
  /// from your project dashboard.
  final client = StreamChatClient(
    's2dxdhpxd94g',
    logLevel: Level.INFO,
  );

  /// Set the current user and connect the websocket. In a production
  /// scenario, this should be done using a backend to generate a user token
  /// using our server SDK.
  ///
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
  await client.connectUser(
    User(id: 'super-band-9'),
    '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoic3VwZXItYmFuZC05In0.0L6lGoeLwkz0aZRUcpZKsvaXtNEDHBcezVTZ0oPq40A''',
  );

  final channel = client.channel('messaging', id: 'godevs');

  await channel.watch();

  runApp(
    MyApp(
      client: client,
      channel: channel,
    ),
  );
}

/// Example application using Stream Chat Flutter widgets.
///
/// Stream Chat Flutter is a set of Flutter widgets which provide full chat
/// functionalities for building Flutter applications using Stream. If you'd
/// prefer using minimal wrapper widgets for your app, please see our other
/// package, `stream_chat_flutter_core`.
class MyApp extends StatelessWidget {
  /// Example using Stream's Flutter package.
  ///
  /// If you'd prefer using minimal wrapper widgets for your app, please see
  /// our other package, `stream_chat_flutter_core`.
  const MyApp({
    super.key,
    required this.client,
    required this.channel,
  });

  /// Instance of Stream Client.
  ///
  /// Stream's [StreamChatClient] can be used to connect to our servers and
  /// set the default user for the application. Performing these actions
  /// trigger a websocket connection allowing for real-time updates.
  final StreamChatClient client;

  /// Instance of the Channel
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('fr'),
        Locale('it'),
        Locale('es'),
      ],
      localizationsDelegates: GlobalStreamChatLocalizations.delegates,
      builder: (context, widget) => StreamChat(
        client: client,
        child: widget,
      ),
      home: StreamChannel(
        channel: channel,
        child: const ResponsiveChat(),
      ),
    );
  }
}

// ignore: public_member_api_docs
class ResponsiveChat extends StatelessWidget {
  // ignore: public_member_api_docs
  const ResponsiveChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final initialChannel = StreamChannel.of(context).channel;
    return ScreenTypeLayout(
      breakpoints: const ScreenBreakpoints(
        desktop: 550,
        tablet: 550,
        watch: 300,
      ),
      desktop: DesktopLayout(
        initialChannel: initialChannel,
      ),
      mobile: ChannelPage(
        channel: initialChannel,
      ),
    );
  }
}

// ignore: public_member_api_docs
class DesktopLayout extends StatefulWidget {
  // ignore: public_member_api_docs
  const DesktopLayout({
    super.key,
    required this.initialChannel,
  });

  // ignore: public_member_api_docs
  final Channel initialChannel;

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout> {
  late Widget _page;
  late StreamChannelListController controller;

  @override
  void initState() {
    super.initState();
    _page = ChannelPage(
      channel: widget.initialChannel,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final client = StreamChat.of(context).client;
    controller = StreamChannelListController(
      client: client,
      filter: Filter.in_(
        'members',
        [
          StreamChat.of(context).currentUser!.id,
        ],
      ),
      sort: const [SortOption('last_message_at')],
      limit: 20,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 250,
            child: Column(
              children: [
                const SizedBox(height: 40),
                Expanded(
                  child: StreamChannelListView(
                    controller: controller,
                    onChannelTap: (channel) {
                      setState(() => _page = ChannelPage(channel: channel));
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _page,
          ),
        ],
      ),
    );
  }
}

/// A list of messages sent in the current channel.
///
/// This is implemented using [StreamMessageListView],
/// a widget that provides query
/// functionalities fetching the messages from the api and showing them in a
/// listView.
class ChannelPage extends StatefulWidget {
  /// Creates the page that shows the list of messages
  const ChannelPage({
    super.key,
    required this.channel,
  });

  // ignore: public_member_api_docs
  final Channel channel;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late FocusNode? _focusNode;
  final _messageInputController = StreamMessageInputController();

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode!.dispose();
    super.dispose();
  }

  void _reply(Message message) {
    _messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode!.requestFocus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamChannel(
      channel: widget.channel,
      child: Scaffold(
        appBar: StreamChannelHeader(
          title: ChannelName(
            textStyle:
                StreamChatTheme.of(context).channelHeaderTheme.titleStyle,
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: StreamMessageListView(
                messageBuilder: (p0, p1, p2, defaultMessageWidget) =>
                    defaultMessageWidget.copyWith(
                  onReplyTap: _reply,
                ),
              ),
            ),
            StreamMessageInput(
              messageInputController: _messageInputController,
              attachmentLimit: 3,
              onQuotedMessageCleared: () {
                _messageInputController.clearQuotedMessage();
                _focusNode!.unfocus();
              },
            ),
          ],
        ),
      ),
    );
  }
}
