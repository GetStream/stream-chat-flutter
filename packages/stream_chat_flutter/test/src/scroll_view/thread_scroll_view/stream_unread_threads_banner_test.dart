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
        const StreamUnreadThreadsBanner(
          enabled: true,
          unreadThreads: {'id1', 'id2', 'id3'},
        ),
        brightness: brightness,
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: context.streamColorScheme.backgroundApp,
            body: Center(child: widget),
          );
        },
      ),
    ),
  );
}
