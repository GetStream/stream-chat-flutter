import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_question_text_field.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    testGoldens(
      '[${brightness.name}] -> PollQuestionTextField should look fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          PollQuestionTextField(
            title: 'Question',
            hintText: 'Ask a question',
            initialQuestion: PollQuestion(),
          ),
          surfaceSize: const Size(600, 150),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'poll_question_text_field_${brightness.name}',
        );
      },
    );

    testGoldens(
      '[${brightness.name}] -> PollQuestionTextField with error should look fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          PollQuestionTextField(
            title: 'Question',
            hintText: 'Ask a question',
            initialQuestion: PollQuestion(
              text: 'A very long question that should not be allowed',
              error: 'Question should be at most 10 characters long',
            ),
          ),
          surfaceSize: const Size(600, 150),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'poll_question_text_field_error_${brightness.name}',
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
      child: Builder(builder: (context) {
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
      }),
    ),
  );
}
