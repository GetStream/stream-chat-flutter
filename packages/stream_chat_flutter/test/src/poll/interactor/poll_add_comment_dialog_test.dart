// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_add_comment_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    testGoldens(
      '[${brightness.name}] -> PollAddCommentDialog looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          const PollAddCommentDialog(),
          surfaceSize: const Size(600, 300),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
            tester, 'poll_add_comment_dialog_${brightness.name}');
      },
    );

    testGoldens(
      '[${brightness.name}] -> PollAddCommentDialog with initialValue looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          const PollAddCommentDialog(
            initialValue: 'This is a comment',
          ),
          surfaceSize: const Size(600, 300),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'poll_add_comment_dialog_with_initial_value_${brightness.name}',
        );
      },
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
