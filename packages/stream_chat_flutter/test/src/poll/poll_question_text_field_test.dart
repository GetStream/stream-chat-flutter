import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_question_text_field.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  goldenTest(
    '[Light] -> PollQuestionTextField should look fine',
    fileName: 'poll_question_text_field_light',
    constraints: const BoxConstraints.tightFor(width: 600, height: 150),
    builder: () => _wrapWithMaterialApp(
      brightness: Brightness.light,
      PollQuestionTextField(
        title: 'Question',
        hintText: 'Ask a question',
        initialQuestion: PollQuestion(),
      ),
    ),
  );

  goldenTest(
    '[Error] -> PollQuestionTextField should look fine',
    fileName: 'poll_question_text_field_error',
    constraints: const BoxConstraints.tightFor(width: 600, height: 150),
    builder: () => _wrapWithMaterialApp(
      PollQuestionTextField(
        title: 'Question',
        initialQuestion: PollQuestion(
          text: 'A very long question that should not be allowed',
          error: 'Question should be at most 10 characters long',
        ),
      ),
    ),
  );

  goldenTest(
    '[Dark] -> PollQuestionTextField should look fine',
    fileName: 'poll_question_text_field_dark',
    constraints: const BoxConstraints.tightFor(width: 600, height: 150),
    builder: () => _wrapWithMaterialApp(
      brightness: Brightness.dark,
      PollQuestionTextField(
        title: 'Question',
        hintText: 'Ask a question',
        initialQuestion: PollQuestion(),
      ),
    ),
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
