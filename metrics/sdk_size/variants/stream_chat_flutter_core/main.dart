import 'package:flutter/material.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamChatClient('api-key');
  await client.connectUser(User(id: 'sdk-size'), 'user-token');

  runApp(
    MaterialApp(
      builder: (context, child) => StreamChatCore(client: client, child: child!),
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
      body: PagedValueListView<int, Channel>(
        controller: _controller,
        itemBuilder: (context, channels, index) {
          final channel = channels[index];
          return ListTile(
            title: Text(channel.name ?? channel.cid ?? ''),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => StreamChannel(channel: channel, child: const ChannelPage()),
              ),
            ),
          );
        },
        separatorBuilder: (context, channels, index) => const Divider(),
        emptyBuilder: (context) => const SizedBox(),
        loadMoreErrorBuilder: (context, error) => Text('$error'),
        loadMoreIndicatorBuilder: (context) => const CircularProgressIndicator(),
        loadingBuilder: (context) => const CircularProgressIndicator(),
        errorBuilder: (context, error) => Text('$error'),
      ),
    );
  }
}

class ChannelPage extends StatelessWidget {
  const ChannelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MessageListCore(
        loadingBuilder: (context) => const CircularProgressIndicator(),
        emptyBuilder: (context) => const SizedBox(),
        errorBuilder: (context, error) => Text('$error'),
        messageListBuilder: (context, messages) => ListView(
          children: [
            for (final message in messages) ListTile(title: Text(message.text ?? '')),
          ],
        ),
      ),
    );
  }
}
