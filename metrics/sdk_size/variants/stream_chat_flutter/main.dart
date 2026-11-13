import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamChatClient('api-key');
  await client.connectUser(User(id: 'sdk-size'), 'user-token');

  runApp(
    MaterialApp(
      builder: (context, child) => StreamChat(client: client, child: child),
      home: ChannelListPage(client: client),
    ),
  );
}

class ChannelListPage extends StatefulWidget {
  const ChannelListPage({super.key, required this.client});

  final StreamChatClient client;

  @override
  State<ChannelListPage> createState() => _ChannelListPageState();
}

class _ChannelListPageState extends State<ChannelListPage> {
  late final _controller = StreamChannelListController(client: widget.client);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamChannelListView(
        controller: _controller,
        onChannelTap: (channel) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => StreamChannel(channel: channel, child: const ChannelPage()),
          ),
        ),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const StreamChannelHeader(),
      body: Column(
        children: [
          const Expanded(child: StreamMessageListView()),
          StreamMessageComposer(),
        ],
      ),
    );
  }
}
