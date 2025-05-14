import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/message_widget/reactions/reaction_picker_icon_list.dart';
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

  group('ReactionIconButton', () {
    testWidgets(
      'renders correctly with selected state',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionIconButton(
              icon: reactionIcons.first,
              isSelected: true,
              onPressed: () {},
            ),
          ),
        );

        expect(find.byType(ReactionIconButton), findsOneWidget);
        expect(find.byType(IconButton), findsOneWidget);
      },
    );

    testWidgets(
      'triggers callback when pressed',
      (WidgetTester tester) async {
        var callbackTriggered = false;

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionIconButton(
              icon: reactionIcons.first,
              isSelected: false,
              onPressed: () {
                callbackTriggered = true;
              },
            ),
          ),
        );

        await tester.tap(find.byType(IconButton));
        await tester.pump();

        expect(callbackTriggered, isTrue);
      },
    );

    group('Golden tests', () {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        final theme = brightness.name;

        goldenTest(
          'ReactionIconButton unselected in $theme theme',
          fileName: 'reaction_icon_button_unselected_$theme',
          constraints: const BoxConstraints.tightFor(width: 60, height: 60),
          builder: () => _wrapWithMaterialApp(
            brightness: brightness,
            ReactionIconButton(
              icon: reactionIcons.first,
              isSelected: false,
              onPressed: () {},
            ),
          ),
        );

        goldenTest(
          'ReactionIconButton selected in $theme theme',
          fileName: 'reaction_icon_button_selected_$theme',
          constraints: const BoxConstraints.tightFor(width: 60, height: 60),
          builder: () => _wrapWithMaterialApp(
            brightness: brightness,
            ReactionIconButton(
              icon: reactionIcons.first,
              isSelected: true,
              onPressed: () {},
            ),
          ),
        );
      }
    });
  });

  group('ReactionPickerIconList', () {
    testWidgets(
      'renders all reaction icons',
      (WidgetTester tester) async {
        final message = Message(
          id: 'test-message',
          text: 'Hello world',
          user: User(id: 'test-user'),
        );

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              message: message,
              reactionIcons: reactionIcons,
              onReactionPicked: (_) {},
            ),
          ),
        );

        // Wait for animations to complete
        await tester.pumpAndSettle();

        // Should find same number of IconButtons as reactionIcons
        expect(find.byType(IconButton), findsNWidgets(reactionIcons.length));
      },
    );

    testWidgets(
      'triggers onReactionPicked when a reaction icon is tapped',
      (WidgetTester tester) async {
        final message = Message(
          id: 'test-message',
          text: 'Hello world',
          user: User(id: 'test-user'),
        );

        Reaction? pickedReaction;

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              message: message,
              reactionIcons: reactionIcons,
              onReactionPicked: (reaction) {
                pickedReaction = reaction;
              },
            ),
          ),
        );

        // Wait for animations to complete
        await tester.pumpAndSettle();

        // Tap the first reaction icon
        await tester.tap(find.byType(IconButton).first);
        await tester.pump();

        // Verify callback was triggered with correct reaction type
        expect(pickedReaction, isNotNull);
        expect(pickedReaction!.type, 'love');
      },
    );

    testWidgets(
      'shows reaction icons with animation',
      (WidgetTester tester) async {
        final message = Message(
          id: 'test-message',
          text: 'Hello world',
          user: User(id: 'test-user'),
        );

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              message: message,
              reactionIcons: reactionIcons,
              onReactionPicked: (_) {},
            ),
          ),
        );

        // Initially the animations should be starting
        await tester.pump();

        // After animation completes
        await tester.pumpAndSettle();

        // Should have all reactions visible
        expect(
          find.byType(ReactionIconButton),
          findsNWidgets(reactionIcons.length),
        );
      },
    );

    testWidgets(
      'properly handles message with existing reactions',
      (WidgetTester tester) async {
        // Create a message with an existing reaction
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
            Material(
              child: ReactionPickerIconList(
                message: message,
                reactionIcons: reactionIcons,
                onReactionPicked: (_) {},
              ),
            ),
          ),
        );

        // Wait for animations
        await tester.pumpAndSettle();

        // All reaction buttons should be rendered
        expect(
          find.byType(ReactionIconButton),
          findsNWidgets(reactionIcons.length),
        );
      },
    );

    testWidgets(
      'updates when reactionIcons change',
      (WidgetTester tester) async {
        final message = Message(
          id: 'test-message',
          text: 'Hello world',
          user: User(id: 'test-user'),
        );

        // Build with initial set of reaction icons
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              message: message,
              // Only first two reactions
              reactionIcons: reactionIcons.sublist(0, 2),
              onReactionPicked: (_) {},
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(IconButton), findsNWidgets(2));

        // Rebuild with all reaction icons
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              message: message,
              reactionIcons: reactionIcons, // All three reactions
              onReactionPicked: (_) {},
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(IconButton), findsNWidgets(5));
      },
    );

    group('Golden tests', () {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        final theme = brightness.name;

        goldenTest(
          'ReactionPickerIconList in $theme theme',
          fileName: 'reaction_picker_icon_list_$theme',
          constraints: const BoxConstraints.tightFor(width: 400, height: 100),
          builder: () {
            final message = Message(
              id: 'test-message',
              text: 'Hello world',
              user: User(id: 'test-user'),
            );

            return _wrapWithMaterialApp(
              brightness: brightness,
              ReactionPickerIconList(
                message: message,
                reactionIcons: reactionIcons,
                onReactionPicked: (_) {},
              ),
            );
          },
        );

        goldenTest(
          'ReactionPickerIconList with selected reaction in $theme theme',
          fileName: 'reaction_picker_icon_list_selected_$theme',
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
              brightness: brightness,
              ReactionPickerIconList(
                message: message,
                reactionIcons: reactionIcons,
                onReactionPicked: (_) {},
              ),
            );
          },
        );
      }
    });
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
      child: Builder(builder: (context) {
        final theme = StreamChatTheme.of(context);
        return Scaffold(
          backgroundColor: theme.colorTheme.appBg,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: child,
            ),
          ),
        );
      }),
    ),
  );
}
