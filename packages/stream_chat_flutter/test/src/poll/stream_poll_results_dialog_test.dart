// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_results_dialog.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  final currentUser = User(id: 'curr-user', name: 'Current User');
  final createdAt = DateTime.parse('2021-07-20T16:00:00.000Z');
  final latestVotesByOption = {
    'option-1': [
      for (var i = 0; i < 5; i++)
        PollVote(
          userId: 'user-$i',
          user: User(id: 'user-$i', name: 'User $i'),
          optionId: 'option-1',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
    ],
    'option-2': [
      for (var i = 0; i < 2; i++)
        PollVote(
          userId: 'user-$i',
          user: User(id: 'user-$i', name: 'User $i'),
          optionId: 'option-2',
          createdAt: createdAt,
          updatedAt: createdAt,
        ),
    ],
    'option-3': [
      PollVote(
        user: currentUser,
        userId: currentUser.id,
        optionId: 'option-3',
        createdAt: createdAt,
        updatedAt: createdAt,
      ),
    ],
  };

  final voteCountsByOption = latestVotesByOption.map(
    (key, value) => MapEntry(key, value.length),
  );

  final latestAnswers = [
    PollVote(
      user: currentUser,
      userId: currentUser.id,
      answerText: 'I also like yellow',
      createdAt: createdAt,
      updatedAt: createdAt,
    ),
  ];

  final poll = Poll(
    id: 'poll-1',
    name: 'What is your favorite color?',
    createdBy: currentUser,
    allowUserSuggestedOptions: true,
    options: const [
      PollOption(id: 'option-1', text: 'Red'),
      PollOption(id: 'option-2', text: 'Blue'),
      PollOption(id: 'option-3', text: 'Green'),
    ],
    voteCount: voteCountsByOption.values.reduce((a, b) => a + b),
    voteCountsByOption: voteCountsByOption,
    latestVotesByOption: latestVotesByOption,
    allowAnswers: true,
    answersCount: latestAnswers.length,
    latestAnswers: latestAnswers,
    ownVotesAndAnswers: [
      ...latestAnswers,
      ...latestVotesByOption.values.expand((it) => it),
    ].where((it) => it.userId == currentUser.id).toList(),
  );

  for (final brightness in Brightness.values) {
    testGoldens(
      '[${brightness.name}] -> StreamPollResultsDialog looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          StreamPollResultsDialog(poll: poll),
          surfaceSize: const Size(412, 916),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'stream_poll_results_dialog_${brightness.name}',
        );
      },
    );

    testGoldens(
      '[${brightness.name}] -> StreamPollResultsDialog with Show all looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          StreamPollResultsDialog(
            poll: poll,
            visibleVotesCount: 2,
            onShowAllVotesPressed: (_) {},
          ),
          surfaceSize: const Size(412, 916),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'stream_poll_results_dialog_with_show_all_${brightness.name}',
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
    home: StreamChatConfiguration(
      data: StreamChatConfigurationData(),
      child: StreamChatTheme(
        data: StreamChatThemeData(brightness: brightness),
        child: Builder(builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            body: Center(child: widget),
          );
        }),
      ),
    ),
  );
}
