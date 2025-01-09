import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamUnreadThreadsBanner looks fine',
      fileName: 'stream_unread_threads_banner_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 400, height: 100),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        const StreamUnreadThreadsBanner(unreadThreads: {'id1', 'id2', 'id3'}),
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    home: StreamChatTheme(
      data: StreamChatThemeData(brightness: brightness),
      child: Builder(builder: (context) {
        final theme = StreamChatTheme.of(context);
        return Scaffold(
          backgroundColor: theme.colorTheme.appBg,
          body: Center(child: widget),
        );
      }),
    ),
  );
}
