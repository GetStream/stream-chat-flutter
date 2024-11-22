import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_suggest_option_dialog.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    testGoldens(
      '[${brightness.name}] -> PollSuggestOptionDialog looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          const PollSuggestOptionDialog(),
          surfaceSize: const Size(600, 300),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
            tester, 'poll_suggest_option_dialog_${brightness.name}');
      },
    );

    testGoldens(
      '[${brightness.name}] -> PollSuggestOptionDialog with initialOption looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          const PollSuggestOptionDialog(
            initialOption: 'New option',
          ),
          surfaceSize: const Size(600, 300),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'poll_suggest_option_dialog_with_initial_option_${brightness.name}',
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
