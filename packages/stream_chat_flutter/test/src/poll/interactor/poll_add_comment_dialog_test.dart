// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_add_comment_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollAddCommentDialog looks fine',
      fileName: 'poll_add_comment_dialog_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 300),
      builder: () => _wrapWithMaterialApp(
        const PollAddCommentDialog(),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollAddCommentDialog with initialValue looks fine',
      fileName: 'poll_add_comment_dialog_with_initial_value_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 300),
      builder: () => _wrapWithMaterialApp(
        const PollAddCommentDialog(initialValue: 'This is a comment'),
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
      child: widget,
    ),
  );
}
