import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

Future<void> main() async {
  /// Create a new instance of [StreamChatClient] passing the apikey obtained
  /// from your project dashboard.
  final client = StreamChatClient('b67pax5b2wdq');

  WidgetsFlutterBinding.ensureInitialized();

  /// Set the chatPersistenceClient for offline support
  client.chatPersistenceClient = StreamChatPersistenceClient(
    logLevel: Level.INFO,
    connectionMode: ConnectionMode.background,
  );

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
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiY29vbC1zaGFkb3ctNyJ9.'
    'gkOlCRb1qgy4joHPaxFwPOdXcGvSPvp6QY0S4mpRkVo',
  );

  /// Creates a channel using the type `messaging` and `godevs`.
  /// Channels are containers for holding messages between different members. To
  /// learn more about channels and some of our predefined types, checkout our
  /// our channel docs: https://getstream.io/chat/docs/initialize_channel/?language=dart
  final channel = client.channel('messaging', id: 'godevs');

  /// `.watch()` is used to create and listen to the channel for updates. If the
  /// channel already exists, it will simply listen for new events.
  await channel.watch();

  runApp(
    StreamExample(
      client: client,
      channel: channel,
    ),
  );
}

/// Example using Stream's Low Level Dart client.
class StreamExample extends StatelessWidget {
  /// To initialize this example, an instance of
  /// [client] and [channel] is required.
  const StreamExample({
    super.key,
    required this.client,
    required this.channel,
  });

  /// Instance of [StreamChatClient] we created earlier.
  /// This contains information about our application and connection state.
  final StreamChatClient client;

  /// The channel we'd like to observe and participate.
  final Channel channel;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Stream Chat Dart Example',
        home: HomeScreen(channel: channel),
      );
}

/// Main screen of our application. The layout is comprised of an [AppBar]
/// containing the channel name and a [MessageView] displaying recent messages.
class HomeScreen extends StatelessWidget {
  /// [HomeScreen] is constructed using the [Channel] we defined earlier.
  const HomeScreen({
    super.key,
    required this.channel,
  });

  /// Channel object containing the [Channel.id] we'd like to observe.
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    final messages = channel.state!.channelStateStream;
    return Scaffold(
      appBar: AppBar(
        title: Text('Channel: ${channel.id}'),
      ),
      body: SafeArea(
        child: StreamBuilder<ChannelState?>(
          stream: messages,
          builder: (
            BuildContext context,
            AsyncSnapshot<ChannelState?> snapshot,
          ) {
            if (snapshot.hasData && snapshot.data != null) {
              final _messages = snapshot.data!.messages ?? [];
              return MessageView(
                messages: _messages.reversed.toList(),
                channel: channel,
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text(
                  'There was an error loading messages. Please see logs.',
                ),
              );
            }
            return const Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// UI used to display a list of recent messages and a [TextField] for sending
/// new messages.
class MessageView extends StatefulWidget {
  /// Message takes the latest list of messages and the current channel.
  const MessageView({
    super.key,
    required this.messages,
    required this.channel,
  });

  /// List of messages sent in the given channel.
  final List<Message> messages;

  /// Current channel being observed.
  final Channel channel;

  @override
  _MessageViewState createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late final TextEditingController _controller;
  late final ScrollController _scrollController;

  List<Message> get _messages => widget.messages;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Convenience method for scrolling the list view when a new message is sent.
  void _updateList() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              reverse: true,
              itemBuilder: (BuildContext context, int index) {
                final item = _messages[index];
                if (item.user?.id == widget.channel.client.uid) {
                  return Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(item.text ?? ''),
                    ),
                  );
                } else {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(item.text ?? ''),
                    ),
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
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
                      // We can send a new message by calling `sendMessage` on
                      // the current channel. After sending a message, the
                      // TextField is cleared and the list view is scrolled
                      // to show the new item.
                      if (_controller.value.text.isNotEmpty) {
                        await widget.channel.sendMessage(
                          Message(text: _controller.value.text),
                        );
                        _controller.clear();
                        _updateList();
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
      );
}

/// Helper extension for quickly retrieving
/// the current user id from a [StreamChatClient].
extension on StreamChatClient {
  String get uid => state.currentUser!.id;
}
