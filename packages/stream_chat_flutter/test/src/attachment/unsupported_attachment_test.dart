import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  for (final brightness in Brightness.values) {
    final theme = brightness.name;
    goldenTest(
      '[$theme] -> should look correct',
      fileName: 'stream_unsupported_attachment_$theme',
      constraints: const BoxConstraints.tightFor(width: 300, height: 100),
      builder: () => _wrapWithStreamChatApp(
        StreamUnsupportedAttachment(message: Message()),
        brightness: brightness,
      ),
    );
  }
}

Widget _wrapWithStreamChatApp(
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
