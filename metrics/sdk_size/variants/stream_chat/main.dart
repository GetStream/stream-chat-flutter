import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamChatClient('api-key');
  await client.connectUser(User(id: 'sdk-size'), 'user-token');

  final channels = await client.queryChannels().first;
  final channel = channels.firstOrNull ?? client.channel('messaging', id: 'sdk-size');
  await channel.watch();
  await channel.sendMessage(Message(text: 'Hello'));

  runApp(const MaterialApp(home: Scaffold()));
}
