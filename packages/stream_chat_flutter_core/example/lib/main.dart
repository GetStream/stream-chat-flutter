import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

Future<void> main() async {
  /// Create a new instance of [Client] passing the apikey obtained from your
  /// project dashboard.
  final client = Client('b67pax5b2wdq');

  /// Set the current user. In a production scenario, this should be done using
  /// a backend to generate a user token using our server SDK.
  /// Please see the following for more information:
  /// https://getstream.io/chat/docs/ios_user_setup_and_tokens/
  await client.setUser(
    User(
      id: 'cool-shadow-7',
      extraData: {
        'image':
            'https://getstream.io/random_png/?id=cool-shadow-7&amp;name=Cool+shadow',
      },
    ),
    'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiY29vbC1zaGFkb3ctNyJ9.gkOlCRb1qgy4joHPaxFwPOdXcGvSPvp6QY0S4mpRkVo',
  );

  runApp(
    StreamExample(
      client: client,
    ),
  );
}

class StreamExample extends StatelessWidget {
  const StreamExample({
    Key key,
    @required this.client,
  }) : super(key: key);

  final Client client;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Chat Dart Example',
      home: _HomeScreen(),
      builder: (context, child) => StreamChatCore(
        client: client,
        child: ChannelsBloc(child: child),
      ),
    );
  }
}

class _HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Channels'),
      ),
      body: ChannelListCore(
        emptyBuilder: (BuildContext context) {
          return Center(
            child: Text('Looks like you are not in any channels'),
          );
        },
        loadingBuilder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: 100.0,
              width: 100.0,
              child: CircularProgressIndicator(),
            ),
          );
        },
        errorBuilder: (Error error) {
          return Center(
            child:
                Text('Oh no, something went wrong. Please check your config.'),
          );
        },
        listBuilder: (BuildContext context, List<Channel> channels) =>
            ListView.builder(
          itemCount: channels.length,
          itemBuilder: (BuildContext context, int index) {
            final item = channels[index];
            return ListTile(
              title: Text(item.name),
              subtitle: Text(item.state.lastMessage.text),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => StreamChannel(
                      channel: item,
                      child: MessageScreen(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class MessageScreen extends StatefulWidget {
  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  TextEditingController _controller;
  ScrollController _scrollController;

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

  void _updateList() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MessageListCore(
              emptyBuilder: (BuildContext context) {
                return Center(
                  child: Text('Looks like you are not in any channels'),
                );
              },
              loadingBuilder: (BuildContext context) {
                return Center(
                  child: SizedBox(
                    height: 100.0,
                    width: 100.0,
                    child: CircularProgressIndicator(),
                  ),
                );
              },
              messageListBuilder:
                  (BuildContext context, List<Message> messages) {
                return ListView.builder(
                  controller: _scrollController,
                  itemCount: messages.length,
                  reverse: true,
                  itemBuilder: (BuildContext context, int index) {
                    final item = messages[index];
                    final client = StreamChatCore.of(context).client;
                    if (item.user.id == client.uid) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.text),
                        ),
                      );
                    } else {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(item.text),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                      if (_controller.value.text.isNotEmpty) {
                        //TODO(Nash): Send Message
                        // await widget.channel.sendMessage(
                        //   Message(text: _controller.value.text),
                        // );
                        _controller.clear();
                        _updateList();
                      }
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

extension on Client {
  String get uid => state.user.id;
}

extension on Channel {
  String get name {
    final _channelName = extraData['name'];
    if (_channelName != null) {
      return _channelName;
    } else {
      return cid;
    }
  }
}