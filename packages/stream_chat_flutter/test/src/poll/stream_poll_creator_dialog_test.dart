import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/stream_poll_creator_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  goldenTest(
    '[Light] -> StreamPollCreatorDialog should look fine',
    fileName: 'stream_poll_creator_dialog_light',
    constraints: const BoxConstraints.tightFor(width: 1280, height: 800),
    builder: () => _wrapWithMaterialApp(
      brightness: Brightness.light,
      const StreamPollCreatorDialog(),
    ),
  );

  goldenTest(
    '[Dark] -> StreamPollCreatorDialog should look fine',
    fileName: 'stream_poll_creator_dialog_dark',
    constraints: const BoxConstraints.tightFor(width: 1280, height: 800),
    builder: () => _wrapWithMaterialApp(
      brightness: Brightness.dark,
      const StreamPollCreatorDialog(),
    ),
  );

  goldenTest(
    '[Light] -> StreamPollCreatorFullScreenDialog should look fine',
    fileName: 'stream_poll_creator_full_screen_dialog_light',
    constraints: const BoxConstraints.tightFor(width: 412, height: 916),
    builder: () => _wrapWithMaterialApp(
      brightness: Brightness.light,
      const StreamPollCreatorFullScreenDialog(),
    ),
  );

  goldenTest(
    '[Dark] -> StreamPollCreatorFullScreenDialog should look fine',
    fileName: 'stream_poll_creator_full_screen_dialog_dark',
    constraints: const BoxConstraints.tightFor(width: 412, height: 916),
    builder: () => _wrapWithMaterialApp(
      brightness: Brightness.dark,
      const StreamPollCreatorFullScreenDialog(),
    ),
  );
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
