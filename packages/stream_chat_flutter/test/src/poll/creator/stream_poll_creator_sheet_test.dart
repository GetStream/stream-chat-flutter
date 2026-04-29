// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/stream_poll_creator_sheet.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamPollCreatorSheet should look fine',
      fileName: 'stream_poll_creator_sheet_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 916),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        const StreamPollCreatorSheet(),
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    home: StreamChatConfiguration(
      data: StreamChatConfigurationData(),
      child: StreamChatTheme(
        data: StreamChatThemeData(brightness: brightness),
        child: Builder(
          builder: (context) {
            final theme = StreamChatTheme.of(context);
            return Scaffold(
              backgroundColor: theme.colorTheme.appBg,
              body: widget,
            );
          },
        ),
      ),
    ),
  );
}
