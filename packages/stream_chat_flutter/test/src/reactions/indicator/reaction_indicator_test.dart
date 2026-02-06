import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final reactionIcons = [
    StreamReactionIcon(
      type: 'love',
      builder: (context, isSelected, iconSize) => StreamSvgIcon(
        icon: StreamSvgIcons.loveReaction,
        size: iconSize,
        color: isSelected ? Colors.red : Colors.grey.shade700,
      ),
    ),
    StreamReactionIcon(
      type: 'thumbsUp',
      builder: (context, isSelected, iconSize) => StreamSvgIcon(
        icon: StreamSvgIcons.thumbsUpReaction,
        size: iconSize,
        color: isSelected ? Colors.blue : Colors.grey.shade700,
      ),
    ),
    StreamReactionIcon(
      type: 'thumbsDown',
      builder: (context, isSelected, iconSize) => StreamSvgIcon(
        icon: StreamSvgIcons.thumbsDownReaction,
        size: iconSize,
        color: isSelected ? Colors.orange : Colors.grey.shade700,
      ),
    ),
    StreamReactionIcon(
      type: 'lol',
      builder: (context, isSelected, iconSize) => StreamSvgIcon(
        icon: StreamSvgIcons.lolReaction,
        size: iconSize,
        color: isSelected ? Colors.amber : Colors.grey.shade700,
      ),
    ),
    StreamReactionIcon(
      type: 'wut',
      builder: (context, isSelected, iconSize) => StreamSvgIcon(
        icon: StreamSvgIcons.wutReaction,
        size: iconSize,
        color: isSelected ? Colors.purple : Colors.grey.shade700,
      ),
    ),
  ];

  testWidgets(
    'renders with correct message and reaction icons',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
        reactionGroups: {
          'love': ReactionGroup(
            count: 3,
            sumScores: 3,
            firstReactionAt: DateTime.now(),
            lastReactionAt: DateTime.now(),
          ),
          'thumbsUp': ReactionGroup(
            count: 2,
            sumScores: 2,
            firstReactionAt: DateTime.now(),
            lastReactionAt: DateTime.now(),
          ),
        },
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionIndicator(
            message: message,
            reactionIcons: reactionIcons,
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the widget renders with correct structure
      expect(find.byType(StreamReactionIndicator), findsOneWidget);
      expect(find.byType(ReactionIndicatorIconList), findsOneWidget);
    },
  );

  testWidgets(
    'triggers onTap callback when tapped',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
        reactionGroups: {
          'love': ReactionGroup(
            count: 1,
            sumScores: 1,
            firstReactionAt: DateTime.now(),
            lastReactionAt: DateTime.now(),
          ),
        },
      );

      var tapped = false;

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionIndicator(
            message: message,
            reactionIcons: reactionIcons,
            onTap: () {
              tapped = true;
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap the indicator
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Verify the callback was called
      expect(tapped, isTrue);
    },
  );

  testWidgets(
    'uses custom reactionIconBuilder when provided',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
        reactionGroups: {
          'love': ReactionGroup(
            count: 5,
            sumScores: 5,
            firstReactionAt: DateTime.now(),
            lastReactionAt: DateTime.now(),
          ),
        },
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionIndicator(
            message: message,
            reactionIcons: reactionIcons,
            reactionIconBuilder: (context, icon) {
              final count = message.reactionGroups?[icon.type]?.count ?? 0;
              return Row(
                children: [
                  icon.build(context),
                  const SizedBox(width: 4),
                  Text('$count', key: const Key('reaction-count')),
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify the custom count text is displayed
      expect(find.byKey(const Key('reaction-count')), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
    },
  );

  group('Golden tests', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final theme = brightness.name;

      goldenTest(
        'StreamReactionIndicator in $theme theme',
        fileName: 'stream_reaction_indicator_$theme',
        constraints: const BoxConstraints.tightFor(width: 200, height: 60),
        builder: () {
          final message = Message(
            id: 'test-message',
            text: 'Hello world',
            user: User(id: 'test-user'),
            reactionGroups: {
              'love': ReactionGroup(
                count: 3,
                sumScores: 3,
                firstReactionAt: DateTime.now(),
                lastReactionAt: DateTime.now(),
              ),
              'thumbsUp': ReactionGroup(
                count: 2,
                sumScores: 2,
                firstReactionAt: DateTime.now(),
                lastReactionAt: DateTime.now(),
              ),
            },
          );

          return _wrapWithMaterialApp(
            brightness: brightness,
            StreamReactionIndicator(
              message: message,
              reactionIcons: reactionIcons,
            ),
          );
        },
      );

      goldenTest(
        'StreamReactionIndicator with own reaction in $theme theme',
        fileName: 'stream_reaction_indicator_own_$theme',
        constraints: const BoxConstraints.tightFor(width: 200, height: 60),
        builder: () {
          final message = Message(
            id: 'test-message',
            text: 'Hello world',
            user: User(id: 'test-user'),
            reactionGroups: {
              'love': ReactionGroup(
                count: 1,
                sumScores: 1,
                firstReactionAt: DateTime.now(),
                lastReactionAt: DateTime.now(),
              ),
            },
            ownReactions: [
              Reaction(
                type: 'love',
                messageId: 'test-message',
                userId: 'test-user',
              ),
            ],
          );

          return _wrapWithMaterialApp(
            brightness: brightness,
            StreamReactionIndicator(
              message: message,
              reactionIcons: reactionIcons,
            ),
          );
        },
      );
    }
  });
}

Widget _wrapWithMaterialApp(
  Widget child, {
  Brightness? brightness,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    home: StreamChatTheme(
      data: StreamChatThemeData(brightness: brightness),
      child: Builder(
        builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.overlay,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: child,
              ),
            ),
          );
        },
      ),
    ),
  );
}
