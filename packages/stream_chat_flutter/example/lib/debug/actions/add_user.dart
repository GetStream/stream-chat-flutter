// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:stream_chat_flutter_example/debug/error_dialog.dart';

class DebugAddUser extends StatelessWidget {
  const DebugAddUser({
    super.key,
    required this.client,
    required this.channel,
  });

  final StreamChatClient client;
  final Channel channel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Add User',
          hintText: 'User Id',
          isDense: true,
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) async {
          final userId = value.trim();
          try {
            debugPrint('[addUser] userId: $userId');
            final result = await client.addChannelMembers(
              channel.id!,
              channel.type,
              [userId],
            );
            debugPrint('[addUser] result: $result');
          } catch (e) {
            debugPrint('[addUser] failed: $e');
            showErrorDialog(context, e, 'Add User');
          }
        },
      ),
    );
  }
}
