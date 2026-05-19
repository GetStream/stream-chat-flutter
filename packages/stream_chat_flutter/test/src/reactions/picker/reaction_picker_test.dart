import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/misc/staggered_scale_transition.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  const resolver = _TestReactionIconResolver();

  testWidgets(
    'renders with correct message and reaction buttons',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageReactionPicker(
            message: message,
            onReactionPicked: (_) {},
          ),
          reactionIconResolver: resolver,
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify the widget renders with correct structure.
      expect(find.byType(StreamMessageReactionPicker), findsOneWidget);
      // Verify the correct number of reaction buttons.
      expect(
        find.byType(StreamEmojiButton),
        findsNWidgets(resolver.defaultReactions.length),
      );
      expect(find.byKey(const Key('add_reaction')), findsOneWidget);
    },
  );

  testWidgets(
    'calls onReactionPicked when a reaction is selected',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
      );

      Reaction? pickedReaction;

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageReactionPicker(
            message: message,
            onReactionPicked: (reaction) {
              pickedReaction = reaction;
            },
          ),
          reactionIconResolver: resolver,
        ),
      );

      // Wait for animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Tap the first reaction button.
      await tester.tap(find.byKey(const Key('love')));
      await tester.pump();

      // Verify the callback was called with the correct reaction.
      expect(pickedReaction, isNotNull);
      expect(pickedReaction!.type, 'love');
      expect(pickedReaction!.emojiCode, resolver.emojiCode('love'));
    },
  );

  testWidgets(
    'reuses own reaction when selected',
    (WidgetTester tester) async {
      final existingReaction = Reaction(
        type: 'love',
        messageId: 'test-message',
        userId: 'test-user',
      );

      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
        ownReactions: [existingReaction],
      );

      Reaction? pickedReaction;

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageReactionPicker(
            message: message,
            onReactionPicked: (reaction) {
              pickedReaction = reaction;
            },
          ),
          reactionIconResolver: resolver,
        ),
      );

      // Wait for animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      await tester.tap(find.byKey(const Key('love')));
      await tester.pump();

      expect(pickedReaction, same(existingReaction));
    },
  );

  testWidgets(
    'marks own reactions as selected',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
        ownReactions: [
          Reaction(
            type: 'love',
            messageId: 'test-message',
            userId: 'test-user',
          ),
        ],
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageReactionPicker(
            message: message,
            onReactionPicked: (_) {},
          ),
          reactionIconResolver: resolver,
        ),
      );

      // Wait for animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final selectedButton = tester.widget<StreamEmojiButton>(
        find.byKey(const Key('love')),
      );
      final unselectedButton = tester.widget<StreamEmojiButton>(
        find.byKey(const Key('like')),
      );

      expect(selectedButton.props.isSelected, isTrue);
      expect(unselectedButton.props.isSelected, isFalse);
    },
  );

  testWidgets(
    'updates reaction buttons when resolver default reactions change',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
      );

      const compactResolver = _CustomReactionIconResolver({'love', 'like'});

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageReactionPicker(
            message: message,
            onReactionPicked: (_) {},
          ),
          reactionIconResolver: compactResolver,
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));
      // Initial resolver exposes two quick reactions.
      expect(find.byType(StreamEmojiButton), findsNWidgets(2));

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageReactionPicker(
            message: message,
            onReactionPicked: (_) {},
          ),
          reactionIconResolver: resolver,
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));
      // Updated resolver exposes the default quick-reaction set.
      expect(
        find.byType(StreamEmojiButton),
        findsNWidgets(resolver.defaultReactions.length),
      );
    },
  );

  testWidgets(
    'uses only defaultReactions even when supportedReactions contains more types',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
      );

      const subsetResolver = _SubsetDefaultReactionIconResolver();

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageReactionPicker(
            message: message,
            onReactionPicked: (_) {},
          ),
          reactionIconResolver: subsetResolver,
        ),
      );

      // Wait for animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Picker should render only the resolver's quick-reaction defaults.
      expect(find.byType(StreamEmojiButton), findsNWidgets(1));
      expect(find.byKey(const Key('love')), findsOneWidget);
      expect(find.byKey(const Key('like')), findsNothing);
      expect(find.byKey(const Key('wow')), findsNothing);
    },
  );

  testWidgets(
    'uses custom reaction resolver rendering',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageReactionPicker(
            message: message,
            onReactionPicked: (_) {},
          ),
          reactionIconResolver: const _TypeBasedReactionIconResolver(),
        ),
      );

      // Wait for animations to complete.
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // _TypeBasedReactionIconResolver defines one reaction ('customParty')
      // that resolves to StreamUnicodeEmoji('❓'). Verify the fallback emoji
      // is rendered via a StreamEmoji widget inside the picker.
      expect(find.byType(StreamEmoji), findsOneWidget);
      expect(find.text('❓'), findsOneWidget);
    },
  );

  testWidgets(
    'renders picker without staggered transition animation',
    (WidgetTester tester) async {
      final message = Message(
        id: 'test-message',
        text: 'Hello world',
        user: User(id: 'test-user'),
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamMessageReactionPicker(
            message: message,
            onReactionPicked: (_) {},
          ),
          reactionIconResolver: resolver,
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(StaggeredScaleTransition), findsNothing);
    },
  );

  group('Golden tests', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final theme = brightness.name;

      goldenTest(
        'StreamMessageReactionPicker in $theme theme',
        fileName: 'stream_reaction_picker_$theme',
        constraints: const BoxConstraints.tightFor(width: 400, height: 100),
        builder: () {
          final message = Message(
            id: 'test-message',
            text: 'Hello world',
            user: User(id: 'test-user'),
          );

          return _wrapWithMaterialApp(
            StreamMessageReactionPicker(
              message: message,
              onReactionPicked: (_) {},
            ),
            reactionIconResolver: resolver,
          );
        },
      );

      goldenTest(
        'StreamMessageReactionPicker with selected reaction in $theme theme',
        fileName: 'stream_reaction_picker_selected_$theme',
        constraints: const BoxConstraints.tightFor(width: 400, height: 100),
        builder: () {
          final message = Message(
            id: 'test-message',
            text: 'Hello world',
            user: User(id: 'test-user'),
            ownReactions: [
              Reaction(
                type: 'love',
                messageId: 'test-message',
                userId: 'test-user',
              ),
            ],
          );

          return _wrapWithMaterialApp(
            StreamMessageReactionPicker(
              message: message,
              onReactionPicked: (_) {},
            ),
            reactionIconResolver: resolver,
          );
        },
      );

      goldenTest(
        'StreamMessageReactionPicker with subset defaults in $theme theme',
        fileName: 'stream_reaction_picker_subset_$theme',
        constraints: const BoxConstraints.tightFor(width: 400, height: 100),
        builder: () {
          final message = Message(
            id: 'test-message',
            text: 'Hello world',
            user: User(id: 'test-user'),
          );

          return _wrapWithMaterialApp(
            StreamMessageReactionPicker(
              message: message,
              onReactionPicked: (_) {},
            ),
            reactionIconResolver: const _SubsetDefaultReactionIconResolver(),
          );
        },
      );
    }
  });
}

Widget _wrapWithMaterialApp(
  Widget child, {
  ReactionIconResolver? reactionIconResolver,
}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    builder: (context, child) => StreamChatConfiguration(
      data: StreamChatConfigurationData(
        reactionIconResolver: reactionIconResolver ?? const _TestReactionIconResolver(),
      ),
      child: StreamChatTheme(
        data: StreamChatThemeData(),
        child: child ?? const SizedBox.shrink(),
      ),
    ),
    home: Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: context.streamColorScheme.backgroundOverlayLight,
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
  StreamEmojiContent resolve(String type) {
    if (emojiCode(type) case final emoji?) return StreamUnicodeEmoji(emoji);
    return const StreamUnicodeEmoji('❓');
  }
}

class _CustomReactionIconResolver extends ReactionIconResolver {
  const _CustomReactionIconResolver(this._types);

  final Set<String> _types;

  @override
  Set<String> get defaultReactions => _types;

  @override
  Set<String> get supportedReactions => _types;

  @override
  String? emojiCode(String type) => streamSupportedEmojis[type]?.emoji;

  @override
  StreamEmojiContent resolve(String type) {
    if (emojiCode(type) case final emoji?) return StreamUnicodeEmoji(emoji);
    return const StreamUnicodeEmoji('❓');
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
  StreamEmojiContent resolve(String type) {
    return const StreamUnicodeEmoji('❓');
  }
}

class _SubsetDefaultReactionIconResolver extends ReactionIconResolver {
  const _SubsetDefaultReactionIconResolver();

  @override
  Set<String> get defaultReactions => const {'love'};

  @override
  Set<String> get supportedReactions => const {'love', 'like', 'wow'};

  @override
  String? emojiCode(String type) => streamSupportedEmojis[type]?.emoji;

  @override
  StreamEmojiContent resolve(String type) {
    if (emojiCode(type) case final emoji?) return StreamUnicodeEmoji(emoji);
    return const StreamUnicodeEmoji('❓');
  }
}
