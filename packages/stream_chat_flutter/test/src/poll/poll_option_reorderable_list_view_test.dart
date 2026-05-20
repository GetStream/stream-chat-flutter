import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_option_reorderable_list_view.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

void main() {
  goldenTest(
    '[Light] -> PollOptionReorderableListView should look fine',
    fileName: 'poll_option_reorderable_list_view_light',
    constraints: const BoxConstraints.tightFor(width: 600, height: 500),
    builder: () => _wrapWithMaterialApp(
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
    '[Dark] -> PollOptionReorderableListView should look fine',
    fileName: 'poll_option_reorderable_list_view_dark',
    constraints: const BoxConstraints.tightFor(width: 600, height: 500),
    builder: () => _wrapWithMaterialApp(
      brightness: Brightness.dark,
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
    '[Error] -> PollOptionReorderableListView should look fine',
    fileName: 'poll_option_reorderable_list_view_error',
    constraints: const BoxConstraints.tightFor(width: 600, height: 500),
    builder: () => _wrapWithMaterialApp(
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
