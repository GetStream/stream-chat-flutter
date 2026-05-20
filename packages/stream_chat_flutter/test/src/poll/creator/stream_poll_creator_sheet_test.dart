// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/stream_poll_creator_sheet.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamPollCreatorSheet should look fine',
      fileName: 'stream_poll_creator_sheet_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 916),
      builder: () => _wrapWithMaterialApp(
        const StreamPollCreatorSheet(),
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
    home: StreamChatConfiguration(
      data: StreamChatConfigurationData(),
      child: StreamChatTheme(
        data: StreamChatThemeData(),
        child: Builder(
          builder: (context) {
            return Scaffold(
              backgroundColor: context.streamColorScheme.backgroundApp,
              body: widget,
            );
          },
        ),
      ),
    ),
  );
}
