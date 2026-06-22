// ignore_for_file: lines_longer_than_80_chars

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_header.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/chat.dart';

void main() {
  final poll = Poll(
    id: 'poll-1',
    name: 'What is your favorite color?',
    options: const [
      PollOption(id: 'option-1', text: 'Red'),
      PollOption(id: 'option-2', text: 'Blue'),
      PollOption(id: 'option-3', text: 'Green'),
    ],
  );

  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollHeader looks fine',
      fileName: 'poll_header_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 300, height: 120),
      builder: () => _wrapWithMaterialApp(
        PollHeader(poll: poll),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollHeader with long question looks fine',
      fileName: 'poll_header_long_question_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 300, height: 150),
      builder: () => _wrapWithMaterialApp(
        PollHeader(
          poll: poll.copyWith(
            name: 'A very long question that does not fit in one line',
          ),
        ),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollHeader subtitle with voting mode disabled looks fine',
      fileName: 'poll_header_subtitle_voting_mode_disabled_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 300, height: 120),
      builder: () => _wrapWithMaterialApp(
        PollHeader(
          poll: poll.copyWith(isClosed: true),
        ),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollHeader subtitle with voting mode unique looks fine',
      fileName: 'poll_header_subtitle_voting_mode_unique_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 300, height: 120),
      builder: () => _wrapWithMaterialApp(
        PollHeader(
          poll: poll.copyWith(enforceUniqueVote: true),
        ),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollHeader subtitle with voting mode limited looks fine',
      fileName: 'poll_header_subtitle_voting_mode_limited_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 300, height: 120),
      builder: () => _wrapWithMaterialApp(
        PollHeader(
          poll: poll.copyWith(maxVotesAllowed: 2, enforceUniqueVote: false),
        ),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollHeader subtitle with voting mode all looks fine',
      fileName: 'poll_header_subtitle_voting_mode_all_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 300, height: 120),
      builder: () => _wrapWithMaterialApp(
        PollHeader(
          poll: poll.copyWith(maxVotesAllowed: 3, enforceUniqueVote: false),
        ),
        brightness: brightness,
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Builder(
        builder: (context) {
          final colorScheme = context.streamColorScheme;
          return Scaffold(
            backgroundColor: colorScheme.backgroundApp,
            body: Container(
              color: colorScheme.textDisabled,
              padding: const EdgeInsets.all(16),
              child: Center(child: widget),
            ),
          );
        },
      ),
    ),
  );
}
