// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_suggest_option_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollSuggestOptionDialog looks fine',
      fileName: 'poll_suggest_option_dialog_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 300),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        const PollSuggestOptionDialog(),
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollSuggestOptionDialog with initialOption looks fine',
      fileName: 'poll_suggest_option_dialog_with_initial_option_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 300),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        const PollSuggestOptionDialog(
          initialOption: 'New option',
        ),
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
      child: Builder(
        builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            body: Container(
              color: theme.colorTheme.disabled,
              padding: const EdgeInsets.all(16),
              child: Center(child: widget),
            ),
          );
        },
      ),
    ),
  );
}
