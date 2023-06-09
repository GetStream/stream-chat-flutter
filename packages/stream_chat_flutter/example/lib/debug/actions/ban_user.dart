// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'package:stream_chat_flutter_example/debug/error_dialog.dart';

class DebugBanUser extends StatelessWidget {
  const DebugBanUser({
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
          labelText: 'Ban User',
          hintText: 'User Id',
          isDense: true,
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) async {
          final userId = value.trim();
          try {
            debugPrint('[banUser] userId: $userId');
            final result = await client.banUser(userId);
            debugPrint('[banUser] completed: $result');
          } catch (e) {
            debugPrint('[banUser] failed: $e');
            showErrorDialog(context, e, 'Ban User');
          }
        },
      ),
    );
  }
}
