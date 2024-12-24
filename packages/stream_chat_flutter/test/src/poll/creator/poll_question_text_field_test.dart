// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_question_text_field.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollQuestionTextField should look fine',
      fileName: 'poll_question_text_field_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 150),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        PollQuestionTextField(
          title: 'Question',
          hintText: 'Ask a question',
          initialQuestion: PollQuestion(),
        ),
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollQuestionTextField with error should look fine',
      fileName: 'poll_question_text_field_error_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 150),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        PollQuestionTextField(
          title: 'Question',
          hintText: 'Ask a question',
          initialQuestion: PollQuestion(
            text: 'A very long question that should not be allowed',
            error: 'Question should be at most 10 characters long',
          ),
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
