// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/stream_poll_creator_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamPollCreatorDialog should look fine',
      fileName: 'stream_poll_creator_dialog_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 1280, height: 800),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        const StreamPollCreatorDialog(),
      ),
    );

    goldenTest(
      '[${brightness.name}] -> StreamPollCreatorFullScreenDialog should look fine',
      fileName: 'stream_poll_creator_full_screen_dialog_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 916),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        const StreamPollCreatorFullScreenDialog(),
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
      child: widget,
    ),
  );
}
