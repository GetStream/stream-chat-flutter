import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_option_reorderable_list_view.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_question_text_field.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_switch_list_tile.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('StreamPollCreatorWidget renders correctly', (tester) async {
    final controller = StreamPollController(
      config: const PollConfig(
        nameRange: (min: 1, max: 150),
        allowedVotesRange: (min: 1, max: 10),
      ),
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamPollCreatorWidget(
          controller: controller,
        ),
      ),
    );

    // Verify that the widget is rendered correctly
    expect(find.byType(PollQuestionTextField), findsOneWidget);
    expect(find.byType(PollOptionReorderableListView), findsOneWidget);
    expect(find.byType(PollSwitchListTile), findsNWidgets(4));
  });

  testWidgets('StreamPollCreatorWidget updates poll state correctly',
      (tester) async {
    final controller = StreamPollController(
      config: const PollConfig(
        nameRange: (min: 1, max: 150),
        allowedVotesRange: (min: 1, max: 10),
      ),
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamPollCreatorWidget(
          controller: controller,
        ),
      ),
    );

    // Interact with the widget to update the poll state
    await tester.enterText(
      find.byType(PollQuestionTextField),
      'What is your favorite color?',
    );
    await tester.pumpAndSettle();
    expect(controller.value.name, 'What is your favorite color?');

    await tester.tap(find.switchListTileText('Multiple answers'));
    await tester.pumpAndSettle();
    expect(controller.value.enforceUniqueVote, false);

    await tester.tap(
      find.descendant(
        of: find.byType(PollSwitchTextField),
        matching: find.byType(Switch),
      ),
    );
    await tester.pumpAndSettle();
    expect(controller.value.maxVotesAllowed, null);

    await tester.enterText(
      find.descendant(
        of: find.byType(PollSwitchTextField),
        matching: find.byType(TextField),
      ),
      '3',
    );
    await tester.pumpAndSettle();
    expect(controller.value.maxVotesAllowed, 3);

    await tester.tap(find.switchListTileText('Anonymous poll'));
    await tester.pumpAndSettle();
    expect(controller.value.votingVisibility, VotingVisibility.anonymous);

    await tester.tap(find.switchListTileText('Suggest an option'));
    await tester.pumpAndSettle();
    expect(controller.value.allowUserSuggestedOptions, true);

    await tester.dragUntilVisible(
      find.switchListTileText('Add a comment'),
      find.byType(SingleChildScrollView),
      const Offset(0, 500),
    );

    await tester.tap(find.switchListTileText('Add a comment'));
    await tester.pumpAndSettle();
    expect(controller.value.allowAnswers, true);
  });
}

extension on CommonFinders {
  Finder switchListTileText(String title) {
    return ancestor(
      of: find.text(title),
      matching: find.byType(SwitchListTile),
    );
  }
}

Widget _wrapWithMaterialApp(Widget widget) {
  return MaterialApp(
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Scaffold(
        body: widget,
      ),
    ),
  );
}
