// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:stream_chat_flutter_example/debug/error_dialog.dart';

class DebugUnmuteUser extends StatelessWidget {
  const DebugUnmuteUser({
    super.key,
    required this.client,
  });

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Unmute User',
          hintText: 'User Id',
          isDense: true,
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) async {
          final userId = value.trim();
          try {
            debugPrint('[unmuteUser] userId: $userId');
            final result = await client.unmuteUser(userId);
            debugPrint('[unmuteUser] completed: $result');
          } catch (e) {
            debugPrint('[unmuteUser] failed: $e');
            showErrorDialog(context, e, 'Unmute User');
          }
        },
      ),
    );
  }
}
