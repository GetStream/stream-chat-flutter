import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_widget/components/stream_message_reactions.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  Future<void> pumpReactions(
    WidgetTester tester, {
    required Message message,
    StreamReactionsType? type,
    ValueChanged<Reaction?>? onReactionTap,
    ValueChanged<Reaction?>? onReactionLongPress,
  }) {
    return tester.pumpWidget(
      MaterialApp(
        home: StreamChatConfiguration(
          data: StreamChatConfigurationData(),
          child: StreamChatTheme(
            data: StreamChatThemeData(),
            child: Scaffold(
              body: Center(
                child: StreamMessageReactions(
                  message: message,
                  type: type,
                  onReactionTap: onReactionTap,
                  onReactionLongPress: onReactionLongPress,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('segmented: tapping a chip reports its reaction', (tester) async {
    Reaction? tapped;
    final message = Message(
      reactionGroups: {'love': ReactionGroup(count: 2)},
    );

    await pumpReactions(
      tester,
      message: message,
      type: StreamReactionsType.segmented,
      onReactionTap: (reaction) => tapped = reaction,
    );

    await tester.tap(find.byType(IconButton).first);
    expect(tapped?.type, 'love');
  });

  testWidgets('segmented: reports the full own reaction when present', (tester) async {
    Reaction? tapped;
    final message = Message(
      reactionGroups: {'love': ReactionGroup(count: 1)},
      ownReactions: [
        Reaction(
          type: 'love',
          user: User(id: 'u1'),
        ),
      ],
    );

    await pumpReactions(
      tester,
      message: message,
      type: StreamReactionsType.segmented,
      onReactionTap: (reaction) => tapped = reaction,
    );

    await tester.tap(find.byType(IconButton).first);
    // The user's own reaction is reported with its full data, not a template.
    expect(tapped?.type, 'love');
    expect(tapped?.user?.id, 'u1');
  });

  testWidgets('segmented: tapping the overflow chip reports null', (tester) async {
    var called = false;
    Reaction? tapped;
    // More groups than the visible segment limit (4) so an overflow chip shows.
    final message = Message(
      reactionGroups: {
        'like': ReactionGroup(count: 1),
        'love': ReactionGroup(count: 1),
        'haha': ReactionGroup(count: 1),
        'wow': ReactionGroup(count: 1),
        'sad': ReactionGroup(count: 1),
      },
    );

    await pumpReactions(
      tester,
      message: message,
      type: StreamReactionsType.segmented,
      onReactionTap: (reaction) {
        called = true;
        tapped = reaction;
      },
    );

    // The overflow "+N" chip is the trailing chip; it maps to no single reaction.
    await tester.tap(find.byType(IconButton).last);
    expect(called, isTrue);
    expect(tapped, isNull);
  });

  testWidgets('clustered: tapping the grouped chip reports null', (tester) async {
    var called = false;
    Reaction? tapped;
    final message = Message(
      reactionGroups: {
        'love': ReactionGroup(count: 2),
        'like': ReactionGroup(count: 1),
      },
    );

    await pumpReactions(
      tester,
      message: message,
      type: StreamReactionsType.clustered,
      onReactionTap: (reaction) {
        called = true;
        tapped = reaction;
      },
    );

    await tester.tap(find.byType(IconButton).first);
    expect(called, isTrue);
    expect(tapped, isNull);
  });

  testWidgets('segmented: long-pressing a chip reports its reaction', (tester) async {
    Reaction? longPressed;
    final message = Message(
      reactionGroups: {'love': ReactionGroup(count: 2)},
    );

    await pumpReactions(
      tester,
      message: message,
      type: StreamReactionsType.segmented,
      onReactionTap: (_) {},
      onReactionLongPress: (reaction) => longPressed = reaction,
    );

    await tester.longPress(find.byType(IconButton).first);
    expect(longPressed?.type, 'love');
  });

  testWidgets('segmented: long press reports the full own reaction when present', (tester) async {
    Reaction? longPressed;
    final message = Message(
      reactionGroups: {'love': ReactionGroup(count: 1)},
      ownReactions: [
        Reaction(
          type: 'love',
          user: User(id: 'u1'),
        ),
      ],
    );

    await pumpReactions(
      tester,
      message: message,
      type: StreamReactionsType.segmented,
      onReactionTap: (_) {},
      onReactionLongPress: (reaction) => longPressed = reaction,
    );

    await tester.longPress(find.byType(IconButton).first);
    // The user's own reaction is reported with its full data, not a template.
    expect(longPressed?.type, 'love');
    expect(longPressed?.user?.id, 'u1');
  });

  testWidgets('segmented: long-pressing the overflow chip reports null', (tester) async {
    var called = false;
    Reaction? longPressed;
    // More groups than the visible segment limit (4) so an overflow chip shows.
    final message = Message(
      reactionGroups: {
        'like': ReactionGroup(count: 1),
        'love': ReactionGroup(count: 1),
        'haha': ReactionGroup(count: 1),
        'wow': ReactionGroup(count: 1),
        'sad': ReactionGroup(count: 1),
      },
    );

    await pumpReactions(
      tester,
      message: message,
      type: StreamReactionsType.segmented,
      onReactionTap: (_) {},
      onReactionLongPress: (reaction) {
        called = true;
        longPressed = reaction;
      },
    );

    // The overflow "+N" chip is the trailing chip; it maps to no single reaction.
    await tester.longPress(find.byType(IconButton).last);
    expect(called, isTrue);
    expect(longPressed, isNull);
  });

  testWidgets('clustered: long-pressing the grouped chip reports null', (tester) async {
    var called = false;
    Reaction? longPressed;
    final message = Message(
      reactionGroups: {
        'love': ReactionGroup(count: 2),
        'like': ReactionGroup(count: 1),
      },
    );

    await pumpReactions(
      tester,
      message: message,
      type: StreamReactionsType.clustered,
      onReactionTap: (_) {},
      onReactionLongPress: (reaction) {
        called = true;
        longPressed = reaction;
      },
    );

    await tester.longPress(find.byType(IconButton).first);
    expect(called, isTrue);
    expect(longPressed, isNull);
  });

  testWidgets('registers no long-press gesture when onReactionLongPress is null', (tester) async {
    final message = Message(
      reactionGroups: {'love': ReactionGroup(count: 2)},
    );

    await pumpReactions(
      tester,
      message: message,
      type: StreamReactionsType.segmented,
      onReactionTap: (_) {},
    );

    // Left null so the gesture falls through to the enclosing message.
    final button = tester.widget<IconButton>(find.byType(IconButton).first);
    expect(button.onLongPress, isNull);
  });
}
