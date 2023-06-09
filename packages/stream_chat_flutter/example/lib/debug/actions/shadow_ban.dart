import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../error_dialog.dart';

class DebugShadowBan extends StatelessWidget {
  const DebugShadowBan({
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
          labelText: 'Shadow Ban',
          hintText: 'User Id',
          isDense: true,
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) async {
          final userId = value.trim();
          try {
            debugPrint('[shadowBan] userId: $userId');
            final result = await client.shadowBan(userId);
            debugPrint('[shadowBan] completed: $result');
          } catch (e) {
            debugPrint('[shadowBan] failed: $e');
            showErrorDialog(context, e, 'Shadow Ban');
          }
        },
      ),
    );
  }
}
