import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamTimestamp looks fine',
      fileName: 'stream_timestamp_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 400, height: 100),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        Builder(
          builder: (context) {
            final theme = StreamChatTheme.of(context);
            return StreamTimestamp(
              date: DateTime.parse('2021-07-20T16:00:00.000Z'),
              style: theme.textTheme.footnote.copyWith(
                color: theme.colorTheme.textHighEmphasis,
              ),
            );
          },
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
      child: Builder(builder: (context) {
        final theme = StreamChatTheme.of(context);
        return Scaffold(
          backgroundColor: theme.colorTheme.appBg,
          body: Center(child: widget),
        );
      }),
    ),
  );
}
