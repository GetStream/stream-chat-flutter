// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_option_reorderable_list_view.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollOptionReorderableListView should look fine',
      fileName: 'poll_option_reorderable_list_view_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 500),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        PollOptionReorderableListView(
          title: 'Options',
          itemHintText: 'Add an option',
          initialOptions: [
            PollOptionItem(text: 'Option 1'),
            PollOptionItem(text: 'Option 2'),
            PollOptionItem(text: 'Option 3'),
            PollOptionItem(text: 'Option 4'),
          ],
        ),
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollOptionReorderableListView with error should look fine',
      fileName: 'poll_option_reorderable_list_view_error_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 500),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        PollOptionReorderableListView(
          title: 'Options',
          itemHintText: 'Add an option',
          initialOptions: [
            PollOptionItem(text: 'Option 1', error: 'Option already exists'),
            PollOptionItem(text: 'Option 1', error: 'Option already exists'),
            PollOptionItem(text: 'Option 3'),
            PollOptionItem(text: 'Option 4'),
          ],
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
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: widget,
              ),
            ),
          );
        },
      ),
    ),
  );
}
