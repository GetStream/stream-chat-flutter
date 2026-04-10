import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/stream_poll_options_dialog.dart';
import 'package:stream_chat_flutter/src/stream_chat_configuration.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

void main() {
  final currentUser = User(id: 'curr-user', name: 'Current User');

  final latestVotesByOption = {
    'option-1': [
      for (var i = 0; i < 5; i++)
        PollVote(
          userId: 'user-$i',
          user: User(id: 'user-$i', name: 'User $i'),
          optionId: 'option-1',
          createdAt: DateTime.now(),
        ),
    ],
    'option-2': [
      for (var i = 0; i < 2; i++)
        PollVote(
          userId: 'user-$i',
          user: User(id: 'user-$i', name: 'User $i'),
          optionId: 'option-2',
          createdAt: DateTime.now(),
        ),
    ],
    'option-3': [
      PollVote(
        user: currentUser,
        userId: currentUser.id,
        optionId: 'option-3',
        createdAt: DateTime.now(),
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
      createdAt: DateTime.now(),
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
    goldenTest(
      '[${brightness.name}] -> StreamPollOptionsDialog looks fine',
      fileName: 'stream_poll_options_dialog_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 916),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        StreamPollOptionsDialog(poll: poll),
      ),
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
        child: Builder(
          builder: (context) {
            final theme = StreamChatTheme.of(context);
            return Scaffold(
              backgroundColor: theme.colorTheme.appBg,
              body: Center(child: widget),
            );
          },
        ),
      ),
    ),
  );
}
