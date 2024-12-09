import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_header.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';

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
    testGoldens(
      '[${brightness.name}] -> PollHeader looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          PollHeader(poll: poll),
          surfaceSize: const Size(300, 100),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(tester, 'poll_header_${brightness.name}');
      },
    );

    testGoldens(
      '[${brightness.name}] -> PollHeader with long question looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          PollHeader(
            poll: poll.copyWith(
              name: 'A very long question that does not fit in one line',
            ),
          ),
          surfaceSize: const Size(300, 100),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
            tester, 'poll_header_long_question_${brightness.name}');
      },
    );

    testGoldens(
      '[${brightness.name}] -> PollHeader subtitle with voting mode disabled looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          PollHeader(
            poll: poll.copyWith(
              isClosed: true,
            ),
          ),
          surfaceSize: const Size(300, 100),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'poll_header_subtitle_voting_mode_disabled_${brightness.name}',
        );
      },
    );

    testGoldens(
      '[${brightness.name}] -> PollHeader subtitle with voting mode unique looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          PollHeader(
            poll: poll.copyWith(
              enforceUniqueVote: true,
            ),
          ),
          surfaceSize: const Size(300, 100),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'poll_header_subtitle_voting_mode_unique_${brightness.name}',
        );
      },
    );

    testGoldens(
      '[${brightness.name}] -> PollHeader subtitle with voting mode limited looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          PollHeader(
            poll: poll.copyWith(
              maxVotesAllowed: 2,
              enforceUniqueVote: false,
            ),
          ),
          surfaceSize: const Size(300, 100),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'poll_header_subtitle_voting_mode_limited_${brightness.name}',
        );
      },
    );

    testGoldens(
      '[${brightness.name}] -> PollHeader subtitle with voting mode all looks fine',
      (tester) async {
        await tester.pumpWidgetBuilder(
          PollHeader(
            poll: poll.copyWith(
              maxVotesAllowed: 3,
              enforceUniqueVote: false,
            ),
          ),
          surfaceSize: const Size(300, 100),
          wrapper: (child) => _wrapWithMaterialApp(
            child,
            brightness: brightness,
          ),
        );

        await screenMatchesGolden(
          tester,
          'poll_header_subtitle_voting_mode_all_${brightness.name}',
        );
      },
    );
  }

  //  @override
  //   String pollVotingModeLabel(PollVotingMode votingMode) {
  //     return votingMode.when(
  //       disabled: () => 'Vote ended',
  //       unique: () => 'Select one',
  //       limited: (count) => 'Select up to $count',
  //       all: () => 'Select one or more',
  //     );
  //   }
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
          body: Container(
            color: theme.colorTheme.disabled,
            padding: const EdgeInsets.all(16),
            child: Center(child: widget),
          ),
        );
      }),
    ),
  );
}
