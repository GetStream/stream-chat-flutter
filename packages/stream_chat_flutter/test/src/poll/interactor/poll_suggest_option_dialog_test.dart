// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_suggest_option_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollSuggestOptionDialog looks fine',
      fileName: 'poll_suggest_option_dialog_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 300),
      builder: () => _wrapWithMaterialApp(
        const PollSuggestOptionDialog(),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollSuggestOptionDialog with initialOption looks fine',
      fileName: 'poll_suggest_option_dialog_with_initial_option_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 300),
      builder: () => _wrapWithMaterialApp(
        const PollSuggestOptionDialog(
          initialOption: 'New option',
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
          final colorScheme = context.streamColorScheme;
          return Scaffold(
            backgroundColor: colorScheme.backgroundApp,
            body: Container(
              color: colorScheme.textDisabled,
              padding: const EdgeInsets.all(16),
              child: Center(child: widget),
            ),
          );
        },
      ),
    ),
  );
}
