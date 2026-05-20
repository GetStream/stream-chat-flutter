import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/poll/interactor/poll_footer.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_chat_flutter_core/stream_chat_flutter_core.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

void main() async {
  final currentUser = User(id: 'user-1', name: 'User');

  final poll = Poll(
    id: 'poll-1',
    name: 'Favorite color?',
    options: const [
      PollOption(id: 'option-1', text: 'Red'),
      PollOption(id: 'option-2', text: 'Blue'),
      PollOption(id: 'option-3', text: 'Green'),
    ],
  );

  testWidgets(
    'End Poll button is visible and enabled for the creator on open poll',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(createdBy: currentUser),
            currentUser: currentUser,
            onEndVote: () {},
          ),
        ),
      );

      final endVoteButton = find.ancestor(
        of: find.text('End Poll'),
        matching: find.byType(StreamButton),
      );

      expect(endVoteButton, findsOneWidget);

      expect(
        tester.widget<StreamButton>(endVoteButton).props.onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'End Poll button is not visible for non-creator',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll,
            currentUser: currentUser,
            onEndVote: () {},
          ),
        ),
      );

      final endVoteButton = find.ancestor(
        of: find.text('End Poll'),
        matching: find.byType(StreamButton),
      );

      expect(endVoteButton, findsNothing);
    },
  );

  testWidgets(
    'End Poll button is not visible for closed poll',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(
              isClosed: true,
              createdBy: currentUser,
            ),
            currentUser: currentUser,
            onEndVote: () {},
          ),
        ),
      );

      final endVoteButton = find.ancestor(
        of: find.text('End Poll'),
        matching: find.byType(StreamButton),
      );

      expect(endVoteButton, findsNothing);
    },
  );

  testWidgets(
    'Add Comment button is visible and enabled when poll allows answers',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(allowAnswers: true),
            currentUser: currentUser,
            onAddComment: () {},
          ),
        ),
      );

      final addCommentButton = find.ancestor(
        of: find.text('Add a comment'),
        matching: find.byType(StreamButton),
      );

      expect(addCommentButton, findsOneWidget);
      expect(
        tester.widget<StreamButton>(addCommentButton).props.onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'Add Comment button is not visible when poll is closed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(
              isClosed: true,
              allowAnswers: true,
            ),
            currentUser: currentUser,
            onAddComment: () {},
          ),
        ),
      );

      final addCommentButton = find.ancestor(
        of: find.text('Add a comment'),
        matching: find.byType(StreamButton),
      );

      expect(addCommentButton, findsNothing);
    },
  );

  testWidgets(
    'View Comments button is visible and enabled if there are answers',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(answersCount: 1),
            currentUser: currentUser,
            onViewComments: () {},
          ),
        ),
      );

      final viewCommentsButton = find.ancestor(
        of: find.text('View Comments'),
        matching: find.byType(StreamButton),
      );

      expect(viewCommentsButton, findsOneWidget);
      expect(
        tester.widget<StreamButton>(viewCommentsButton).props.onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'View Comments button is not visible when there are no answers',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(
              answersCount: 0,
            ),
            currentUser: currentUser,
            onViewComments: () {},
          ),
        ),
      );

      final viewCommentsButton = find.ancestor(
        of: find.text('View Comments'),
        matching: find.byType(StreamButton),
      );

      expect(viewCommentsButton, findsNothing);
    },
  );

  testWidgets(
    'Suggest Option button is visible and enabled when allowed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(
              allowUserSuggestedOptions: true,
            ),
            currentUser: currentUser,
            onSuggestOption: () {},
          ),
        ),
      );

      final suggestOptionButton = find.ancestor(
        of: find.text('Suggest an option'),
        matching: find.byType(StreamButton),
      );

      expect(suggestOptionButton, findsOneWidget);
      expect(
        tester.widget<StreamButton>(suggestOptionButton).props.onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'Suggest Option button is not visible when poll is closed',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(
              isClosed: true,
              allowUserSuggestedOptions: true,
            ),
            currentUser: currentUser,
            onSuggestOption: () {},
          ),
        ),
      );

      final suggestOptionButton = find.ancestor(
        of: find.text('Suggest an option'),
        matching: find.byType(StreamButton),
      );

      expect(suggestOptionButton, findsNothing);
    },
  );

  testWidgets(
    'View Results button is enabled if there are votes',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(voteCount: 1),
            currentUser: currentUser,
            onViewResults: () {},
          ),
        ),
      );

      final viewResultsButton = find.ancestor(
        of: find.text('View Results'),
        matching: find.byType(StreamButton),
      );

      expect(viewResultsButton, findsOneWidget);
      expect(
        tester.widget<StreamButton>(viewResultsButton).props.onPressed,
        isNotNull,
      );
    },
  );

  testWidgets(
    'View Results button is not visible if there are no votes',
    (WidgetTester tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollFooter(
            poll: poll.copyWith(voteCount: 0),
            currentUser: currentUser,
            onViewResults: () {},
          ),
        ),
      );

      final viewResultsButton = find.ancestor(
        of: find.text('View Results'),
        matching: find.byType(StreamButton),
      );

      expect(viewResultsButton, findsNothing);
    },
  );
}

Widget _wrapWithMaterialApp(
  Widget widget,
) {
  return MaterialApp(
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: widget,
    ),
  );
}
