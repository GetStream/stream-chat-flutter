import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_question_text_field.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  testGoldens(
    '[Light] -> PollQuestionTextField should look fine',
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
          brightness: Brightness.light,
        ),
      );

      await screenMatchesGolden(tester, 'poll_question_text_field_light');
    },
  );

  testGoldens(
    '[Dark] -> PollQuestionTextField should look fine',
    (tester) async {
      await tester.pumpWidgetBuilder(
        PollQuestionTextField(
          title: 'Question',
          initialQuestion: PollQuestion(
            text: 'A very long question that should not be allowed',
            error: 'Question should be at most 10 characters long',
          ),
        ),
        surfaceSize: const Size(600, 150),
        wrapper: _wrapWithMaterialApp,
      );

      await screenMatchesGolden(tester, 'poll_question_text_field_error');
    },
  );

  testGoldens(
    '[Error] -> PollQuestionTextField should look fine',
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
          brightness: Brightness.dark,
        ),
      );

      await screenMatchesGolden(tester, 'poll_question_text_field_dark');
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
