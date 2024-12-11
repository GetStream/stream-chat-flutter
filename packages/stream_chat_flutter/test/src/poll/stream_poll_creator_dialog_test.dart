import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_creator_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  testGoldens(
    '[Light] -> StreamPollCreatorDialog should look fine',
    (tester) async {
      await tester.pumpWidgetBuilder(
        const StreamPollCreatorDialog(),
        surfaceSize: const Size(1280, 800),
        wrapper: (child) => _wrapWithMaterialApp(
          child,
          brightness: Brightness.light,
        ),
      );

      await screenMatchesGolden(tester, 'stream_poll_creator_dialog_light');
    },
  );

  testGoldens(
    '[Dark] -> StreamPollCreatorDialog should look fine',
    (tester) async {
      await tester.pumpWidgetBuilder(
        const StreamPollCreatorDialog(),
        surfaceSize: const Size(1280, 800),
        wrapper: (child) => _wrapWithMaterialApp(
          child,
          brightness: Brightness.dark,
        ),
      );

      await screenMatchesGolden(tester, 'stream_poll_creator_dialog_dark');
    },
  );

  testGoldens(
    '[Light] -> StreamPollCreatorFullScreenDialog should look fine',
    (tester) async {
      await tester.pumpWidgetBuilder(
        const StreamPollCreatorFullScreenDialog(),
        surfaceSize: const Size(412, 916),
        wrapper: (child) => _wrapWithMaterialApp(
          child,
          brightness: Brightness.light,
        ),
      );

      await screenMatchesGolden(
        tester,
        'stream_poll_creator_full_screen_dialog_light',
      );
    },
  );

  testGoldens(
    '[Dark] -> StreamPollCreatorFullScreenDialog should look fine',
    (tester) async {
      await tester.pumpWidgetBuilder(
        const StreamPollCreatorFullScreenDialog(),
        surfaceSize: const Size(412, 916),
        wrapper: (child) => _wrapWithMaterialApp(
          child,
          brightness: Brightness.dark,
        ),
      );

      await screenMatchesGolden(
        tester,
        'stream_poll_creator_full_screen_dialog_dark',
      );
    },
  );
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
