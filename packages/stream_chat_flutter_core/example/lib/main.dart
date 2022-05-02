import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

Future<void> main() async {
  /// Create a new instance of [StreamChatClient] passing the apikey obtained
  /// from your project dashboard.
  final client = StreamChatClient('b67pax5b2wdq');

  /// Set the current user. In a production scenario, this should be done using
  /// a backend to generate a user token using our server SDK.
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
  await client.connectUser(
    User(
      id: 'cool-shadow-7',
      image:
          'https://getstream.io/random_png/?id=cool-shadow-7&amp;name=Cool+shadow',
    ),
    '''eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiY29vbC1zaGFkb3ctNyJ9.gkOlCRb1qgy4joHPaxFwPOdXcGvSPvp6QY0S4mpRkVo''',
  );

  runApp(
    StreamExample(
      client: client,
    ),
  );
}

/// Example application using Stream Chat core widgets.
/// Stream Chat Core is a set of Flutter wrappers which provide basic
/// functionality for building Flutter applications using Stream.
///
/// If you'd prefer using pre-made UI widgets for your app, please see our other
/// package, `stream_chat_flutter`.
class StreamExample extends StatelessWidget {
  /// Minimal example using Stream's core Flutter package.
  ///
  /// If you'd prefer using pre-made UI widgets for your app, please see our
  /// other package, `stream_chat_flutter`.
  const StreamExample({
    Key? key,
    required this.client,
  }) : super(key: key);

  /// Instance of Stream Client.
  /// Stream's [StreamChatClient] can be used to connect to our servers and
  /// set the default user for the application. Performing these actions
  /// trigger a websocket connection allowing for real-time updates.
  final StreamChatClient client;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Stream Chat Core Example',
        home: HomeScreen(),
        builder: (context, child) => StreamChatCore(
          client: client,
          child: child!,
        ),
      );
}

/// Basic layout displaying a list of [Channel]s the user is a part of.
/// This is implemented using a [StreamChannelListController].
///
/// [StreamChannelListController] is a controller that lets you manage a list of
/// channels.
class HomeScreen extends StatefulWidget {
  /// Builds a basic layout displaying a list of [Channel]s the user is a
  /// part of.
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Controller used for loading more data and controlling pagination in
  /// [StreamChannelListController].
  late final channelListController = StreamChannelListController(
    client: StreamChatCore.of(context).client,
    filter: Filter.and([
      Filter.equal('type', 'messaging'),
      Filter.in_(
        'members',
        [
          StreamChatCore.of(context).currentUser!.id,
        ],
      ),
    ]),
  );

  @override
  void initState() {
    channelListController.doInitialLoad();
    super.initState();
  }

  @override
  void dispose() {
    channelListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Channels'),
        ),
        body: PagedValueListenableBuilder<int, Channel>(
          valueListenable: channelListController,
          builder: (context, value, child) {
            return value.when(
              (channels, nextPageKey, error) => LazyLoadScrollView(
                onEndOfPage: () async {
                  if (nextPageKey != null) {
                    channelListController.loadMore(nextPageKey);
                  }
                },
                child: ListView.builder(
                  /// We're using the channels length when there are no more
                  /// pages to load and there are no errors with pagination.
                  /// In case we need to show a loading indicator or and error
                  /// tile we're increasing the count by 1.
                  itemCount: (nextPageKey != null || error != null)
                      ? channels.length + 1
                      : channels.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == channels.length) {
                      if (error != null) {
                        return TextButton(
                          onPressed: () {
                            channelListController.retry();
                          },
                          child: Text(error.message),
                        );
                      }
                      return CircularProgressIndicator();
                    }

                    final _item = channels[index];
                    return ListTile(
                      title: Text(_item.name ?? ''),
                      subtitle: StreamBuilder<Message?>(
                        stream: _item.state!.lastMessageStream,
                        initialData: _item.state!.lastMessage,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(snapshot.data!.text!);
                          }

                          return const SizedBox();
                        },
                      ),
                      onTap: () {
                        /// Display a list of messages when the user taps on
                        /// an item. We can use [StreamChannel] to wrap our
                        /// [MessageScreen] screen with the selected channel.
                        ///
                        /// This allows us to use a built-in inherited widget
                        /// for accessing our `channel` later on.
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => StreamChannel(
                              channel: _item,
                              child: const MessageScreen(),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              loading: () => const Center(
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (e) => Center(
                child: Text(
                  'Oh no, something went wrong. '
                  'Please check your config. $e',
                ),
              ),
            );
          },
        ),
      );
}

/// A list of messages sent in the current channel.
/// When a user taps on a channel in [HomeScreen], a navigator push
/// [MessageScreen] to display the list of messages in the selected channel.
///
/// This is implemented using [MessageListCore], a convenience builder with
/// callbacks for building UIs based on different api results.
class MessageScreen extends StatefulWidget {
  /// Build a MessageScreen
  const MessageScreen({Key? key}) : super(key: key);

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final StreamMessageInputController messageInputController =
      StreamMessageInputController();
  late final ScrollController _scrollController;
  final messageListController = MessageListController();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    messageInputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _updateList() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    /// To access the current channel, we can use the `.of()` method on
    /// [StreamChannel] to fetch the closest instance.
    final channel = StreamChannel.of(context).channel;
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Iterable<User>>(
          initialData: channel.state?.typingEvents.keys,
          stream: channel.state?.typingEventsStream.map((it) => it.keys),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return Text('${snapshot.data!.first.name} is typing...');
            }
            return const SizedBox();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: LazyLoadScrollView(
                onEndOfPage: () async {
                  messageListController.paginateData!();
                },
                child: MessageListCore(
                  messageListController: messageListController,
                  emptyBuilder: (BuildContext context) => const Center(
                    child: Text('Nothing here yet'),
                  ),
                  loadingBuilder: (BuildContext context) => const Center(
                    child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  messageListBuilder: (
                    BuildContext context,
                    List<Message> messages,
                  ) =>
                      ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    reverse: true,
                    itemBuilder: (BuildContext context, int index) {
                      final item = messages[index];
                      final client = StreamChatCore.of(context).client;
                      if (item.user!.id == client.uid) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(item.text!),
                          ),
                        );
                      } else {
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(item.text!),
                          ),
                        );
                      }
                    },
                  ),
                  errorBuilder: (BuildContext context, error) {
                    print(error.toString());
                    return const Center(
                      child: SizedBox(
                        height: 100,
                        width: 100,
                        child:
                            Text('Oh no, an error occured. Please see logs.'),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageInputController.textEditingController,
                      onChanged: (s) => messageInputController.text = s,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message',
                      ),
                    ),
                  ),
                  Material(
                    type: MaterialType.circle,
                    color: Colors.blue,
                    clipBehavior: Clip.hardEdge,
                    child: InkWell(
                      onTap: () async {
                        if (messageInputController.message.text?.isNotEmpty ==
                            true) {
                          await channel.sendMessage(
                            messageInputController.message,
                          );
                          messageInputController.clear();
                          if (mounted) {
                            _updateList();
                          }
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Center(
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Extensions can be used to add functionality to the SDK. In the example
/// below, we add a simple extensions to the [StreamChatClient].
extension on StreamChatClient {
  /// Fetches the current user id.
  String get uid => state.currentUser!.id;
}
