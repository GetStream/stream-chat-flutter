import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../error_dialog.dart';

class DebugRemoveShadowBan extends StatelessWidget {
  const DebugRemoveShadowBan({
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
          labelText: 'Remove Shadow Ban',
          hintText: 'User Id',
          isDense: true,
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) async {
          final userId = value.trim();
          try {
            debugPrint('[removeShadowBan] userId: $userId');
            final result = await client.removeShadowBan(userId);
            debugPrint('[removeShadowBan] result: $result');
          } catch (e) {
            debugPrint('[removeShadowBan] failed: $e');
            showErrorDialog(context, e, 'Remove Shadow Ban');
          }
        },
      ),
    );
  }
}
