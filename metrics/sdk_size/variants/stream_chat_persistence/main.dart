import 'package:flutter/material.dart';
import 'package:stream_chat/stream_chat.dart';
import 'package:stream_chat_persistence/stream_chat_persistence.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final client = StreamChatClient('api-key')..chatPersistenceClient = StreamChatPersistenceClient();
  await client.connectUser(User(id: 'sdk-size'), 'user-token');

  final channels = await client.queryChannels().first;
  final channel = channels.firstOrNull ?? client.channel('messaging', id: 'sdk-size');
  await channel.watch();
  await channel.sendMessage(Message(text: 'Hello'));

  runApp(const MaterialApp(home: Scaffold()));
}
