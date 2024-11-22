import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/poll/creator/stream_poll_creator_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    testGoldens(
      '[${brightness.name}] -> StreamPollCreatorDialog should look fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          const StreamPollCreatorDialog(),
          surfaceSize: const Size(1280, 800),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'stream_poll_creator_dialog_${brightness.name}',
        );
      },
    );

    testGoldens(
      '[${brightness.name}] -> StreamPollCreatorFullScreenDialog should look fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          const StreamPollCreatorFullScreenDialog(),
          surfaceSize: const Size(412, 916),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'stream_poll_creator_full_screen_dialog_${brightness.name}',
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
