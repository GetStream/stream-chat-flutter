import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  const resolver = _TestReactionIconResolver();

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
          ),
          reactionIconResolver: resolver,
        ),
      );

      await tester.pumpAndSettle();

      // Verify the widget renders with correct structure.
      expect(find.byType(StreamReactionIndicator), findsOneWidget);
      expect(find.byType(StreamEmoji), findsNWidgets(2));
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
            onTap: () {
              tapped = true;
            },
          ),
          reactionIconResolver: resolver,
        ),
      );

      await tester.pumpAndSettle();

      // Tap the indicator.
      await tester.tap(find.byType(InkWell));
      await tester.pump();

      // Verify the callback was called.
      expect(tapped, isTrue);
    },
  );

  testWidgets(
    'renders no emojis when reactionGroups are missing',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionIndicator(
            message: message,
          ),
          reactionIconResolver: resolver,
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StreamEmoji), findsNothing);
    },
  );

  testWidgets(
    'updates emoji count when reaction groups change',
    (WidgetTester tester) async {
      final initialMessage = Message(
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

      final updatedMessage = Message(
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
          'like': ReactionGroup(
            count: 1,
            sumScores: 1,
            firstReactionAt: DateTime.now(),
            lastReactionAt: DateTime.now(),
          ),
          'wow': ReactionGroup(
            count: 1,
            sumScores: 1,
            firstReactionAt: DateTime.now(),
            lastReactionAt: DateTime.now(),
          ),
        },
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionIndicator(message: initialMessage),
          reactionIconResolver: resolver,
        ),
      );

      await tester.pumpAndSettle();
      // Initially only one reaction group is visible.
      expect(find.byType(StreamEmoji), findsOneWidget);

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionIndicator(message: updatedMessage),
          reactionIconResolver: resolver,
        ),
      );

      await tester.pumpAndSettle();
      // Updated message contains three reaction groups.
      expect(find.byType(StreamEmoji), findsNWidgets(3));
    },
  );

  testWidgets(
    'respects custom reaction sorting',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
        reactionGroups: {
          'love': ReactionGroup(
            count: 5,
            sumScores: 5,
            firstReactionAt: DateTime(2026, 1, 1, 10, 0),
            lastReactionAt: DateTime(2026, 1, 1, 10, 0),
          ),
          'like': ReactionGroup(
            count: 1,
            sumScores: 1,
            firstReactionAt: DateTime(2026, 1, 1, 9, 0),
            lastReactionAt: DateTime(2026, 1, 1, 9, 0),
          ),
        },
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionIndicator(
            message: message,
            reactionSorting: ReactionSorting.byCount,
          ),
          reactionIconResolver: resolver,
        ),
      );

      await tester.pumpAndSettle();

      // Validate display order for custom sorting (ascending count).
      final rendered = tester.widgetList<StreamEmoji>(
        find.byType(StreamEmoji),
      );

      final first = rendered.first.props.emoji as Text;
      final second = rendered.elementAt(1).props.emoji as Text;

      expect(first.data, resolver.emojiCode('like'));
      expect(second.data, resolver.emojiCode('love'));
    },
  );

  testWidgets(
    'uses custom reaction resolver rendering',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
        reactionGroups: {
          'customParty': ReactionGroup(
            count: 1,
            sumScores: 1,
            firstReactionAt: DateTime.now(),
            lastReactionAt: DateTime.now(),
          ),
        },
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionIndicator(message: message),
          reactionIconResolver: const _TypeBasedReactionIconResolver(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byKey(const Key('custom-type-customParty')), findsOneWidget);
    },
  );

  testWidgets(
    'renders resolver fallback for unsupported reaction type',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
        reactionGroups: {
          'customUnsupported': ReactionGroup(
            count: 1,
            sumScores: 1,
            firstReactionAt: DateTime.now(),
            lastReactionAt: DateTime.now(),
          ),
        },
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionIndicator(message: message),
          reactionIconResolver: const _StrictReactionIconResolver(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(StreamEmoji), findsOneWidget);
      expect(find.text('❓'), findsOneWidget);
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
            ),
            reactionIconResolver: resolver,
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
            ),
            reactionIconResolver: resolver,
          );
        },
      );

      goldenTest(
        'StreamReactionIndicator with resolver fallback in $theme theme',
        fileName: 'stream_reaction_indicator_fallback_$theme',
        constraints: const BoxConstraints.tightFor(width: 200, height: 60),
        builder: () {
          final message = Message(
            id: 'test-message',
            text: 'Hello world',
            user: User(id: 'test-user'),
            reactionGroups: {
              'customUnsupported': ReactionGroup(
                count: 1,
                sumScores: 1,
                firstReactionAt: DateTime.now(),
                lastReactionAt: DateTime.now(),
              ),
            },
          );

          return _wrapWithMaterialApp(
            brightness: brightness,
            StreamReactionIndicator(
              message: message,
            ),
            reactionIconResolver: const _StrictReactionIconResolver(),
          );
        },
      );
    }
  });
}

Widget _wrapWithMaterialApp(
  Widget child, {
  Brightness? brightness,
  ReactionIconResolver? reactionIconResolver,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(brightness: brightness),
    builder: (context, child) => StreamChatConfiguration(
      data: StreamChatConfigurationData(
        reactionIconResolver: reactionIconResolver ?? const _TestReactionIconResolver(),
      ),
      child: StreamChatTheme(
        data: StreamChatThemeData(brightness: brightness),
        child: child ?? const SizedBox.shrink(),
      ),
    ),
    home: Builder(
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
  );
}

class _TestReactionIconResolver extends ReactionIconResolver {
  const _TestReactionIconResolver();

  static const _reactionTypes = {'like', 'haha', 'love', 'wow', 'sad'};

  @override
  Set<String> get defaultReactions => _reactionTypes;

  @override
  Set<String> get supportedReactions => _reactionTypes;

  @override
  String? emojiCode(String type) => streamSupportedEmojis[type]?.emoji;

  @override
  Widget resolve(BuildContext context, String type) {
    return Text(emojiCode(type) ?? type);
  }
}

class _TypeBasedReactionIconResolver extends ReactionIconResolver {
  const _TypeBasedReactionIconResolver();

  @override
  Set<String> get defaultReactions => const {'customParty'};

  @override
  Set<String> get supportedReactions => const {'customParty'};

  @override
  String? emojiCode(String type) => null;

  @override
  Widget resolve(BuildContext context, String type) {
    return SizedBox.square(key: Key('custom-type-$type'));
  }
}

class _StrictReactionIconResolver extends ReactionIconResolver {
  const _StrictReactionIconResolver();

  @override
  Set<String> get defaultReactions => const {'love'};

  @override
  Set<String> get supportedReactions => const {'love'};

  @override
  String? emojiCode(String type) => streamSupportedEmojis[type]?.emoji;

  @override
  Widget resolve(BuildContext context, String type) {
    if (!supportedReactions.contains(type)) {
      return const Text('❓');
    }

    if (emojiCode(type) case final emoji?) {
      return Text(emoji);
    }

    return const Text('❓');
  }
}
