// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:stream_chat_flutter_example/debug/error_dialog.dart';

class DebugRemoveUser extends StatelessWidget {
  const DebugRemoveUser({
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
          labelText: 'Remove User',
          hintText: 'User Id',
          isDense: true,
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) async {
          final userId = value.trim();
          try {
            debugPrint('[removeUser] userId: $userId');
            final result = await client.removeChannelMembers(
              channel.id!,
              channel.type,
              [userId],
            );
            debugPrint('[removeUser] result: $result');
          } catch (e) {
            debugPrint('[removeUser] failed: $e');
            showErrorDialog(context, e, 'Remove User');
          }
        },
      ),
    );
  }
}
