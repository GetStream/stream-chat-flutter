// ignore_for_file: public_member_api_docs

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
    logLevel: Level.OFF,
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
      // themeMode: ThemeMode.dark,
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

class ResponsiveChat extends StatelessWidget {
  const ResponsiveChat({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.isMobile) {
          return ChannelListPage(
            onTap: (c) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return StreamChannel(
                      channel: c,
                      child: ChannelPage(
                        onBackPressed: (context) {
                          Navigator.of(
                            context,
                            rootNavigator: true,
                          ).pop();
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );
        }

        return const SplitView();
      },
      breakpoints: const ScreenBreakpoints(
        desktop: 550,
        tablet: 550,
        watch: 300,
      ),
    );
  }
}

class SplitView extends StatefulWidget {
  const SplitView({
    super.key,
  });

  @override
  _SplitViewState createState() => _SplitViewState();
}

class _SplitViewState extends State<SplitView> {
  Channel? selectedChannel;

  @override
  Widget build(BuildContext context) {
    return Flex(
      direction: Axis.horizontal,
      children: <Widget>[
        Flexible(
          child: ChannelListPage(
            onTap: (channel) {
              setState(() {
                selectedChannel = channel;
              });
            },
            selectedChannel: selectedChannel,
          ),
        ),
        Flexible(
          flex: 2,
          child: ClipPath(
            child: Scaffold(
              body: selectedChannel != null
                  ? StreamChannel(
                      key: ValueKey(selectedChannel!.cid),
                      channel: selectedChannel!,
                      child: const ChannelPage(showBackButton: false),
                    )
                  : Center(
                      child: Text(
                        'Pick a channel to show the messages 💬',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({
    super.key,
    this.onTap,
    this.selectedChannel,
  });

  final void Function(Channel)? onTap;
  final Channel? selectedChannel;

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
  Widget build(BuildContext context) => Scaffold(
        body: StreamChannelListView(
          onChannelTap: widget.onTap,
          controller: _listController,
          itemBuilder: (context, channels, index, defaultWidget) {
            return defaultWidget.copyWith(
              selected: channels[index] == widget.selectedChannel,
            );
          },
        ),
      );
}

class ChannelPage extends StatefulWidget {
  const ChannelPage({
    super.key,
    this.showBackButton = true,
    this.onBackPressed,
  });

  final bool showBackButton;
  final void Function(BuildContext)? onBackPressed;

  @override
  State<ChannelPage> createState() => _ChannelPageState();
}

class _ChannelPageState extends State<ChannelPage> {
  late final messageInputController = StreamMessageInputController();
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) => Navigator(
        onGenerateRoute: (settings) => MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: StreamChannelHeader(
              onBackPressed: widget.onBackPressed != null
                  ? () {
                      widget.onBackPressed!(context);
                    }
                  : null,
              showBackButton: widget.showBackButton,
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: StreamMessageListView(
                    onMessageSwiped:
                        (CurrentPlatform.isAndroid || CurrentPlatform.isIos)
                            ? reply
                            : null,
                    threadBuilder: (context, parent) {
                      return ThreadPage(
                        parent: parent!,
                      );
                    },
                    messageBuilder:
                        (context, details, messages, defaultWidget) {
                      return defaultWidget.copyWith(
                        onReplyTap: reply,
                      );
                    },
                  ),
                ),
                StreamMessageInput(
                  onQuotedMessageCleared:
                      messageInputController.clearQuotedMessage,
                  focusNode: focusNode,
                  messageInputController: messageInputController,
                ),
              ],
            ),
          ),
        ),
      );

  void reply(Message message) {
    messageInputController.quotedMessage = message;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }
}

class ThreadPage extends StatelessWidget {
  const ThreadPage({
    super.key,
    required this.parent,
  });

  final Message parent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: StreamThreadHeader(
        parent: parent,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamMessageListView(
              parentMessage: parent,
            ),
          ),
          StreamMessageInput(
            messageInputController: StreamMessageInputController(
              message: Message(parentId: parent.id),
            ),
          ),
        ],
      ),
    );
  }
}
