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
      );

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamReactionPicker(
            message: message,
            reactionIcons: reactionIcons,
            onReactionPicked: (_) {},
          ),
        ),
      );

      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Verify the widget renders with correct structure
      expect(find.byType(StreamReactionPicker), findsOneWidget);
      expect(find.byType(ReactionPickerIconList), findsOneWidget);

      // Verify the correct number of reaction icons
      expect(find.byType(IconButton), findsNWidgets(reactionIcons.length));
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
          StreamReactionPicker(
            message: message,
            reactionIcons: reactionIcons,
            onReactionPicked: (reaction) {
              pickedReaction = reaction;
            },
          ),
        ),
      );

      // Wait for animations to complete
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Tap the first reaction icon
      await tester.tap(find.byType(IconButton).first);
      await tester.pump();

      // Verify the callback was called with the correct reaction
      expect(pickedReaction, isNotNull);
      // Updated to match first reaction type in the list
      expect(pickedReaction!.type, 'love');
    },
  );

  group('Golden tests', () {
    for (final brightness in [Brightness.light, Brightness.dark]) {
      final theme = brightness.name;

      goldenTest(
        'StreamReactionPicker in $theme theme',
        fileName: 'stream_reaction_picker_$theme',
        constraints: const BoxConstraints.tightFor(width: 400, height: 100),
        builder: () {
          final message = Message(
            id: 'test-message',
            text: 'Hello world',
            user: User(id: 'test-user'),
          );

          return _wrapWithMaterialApp(
            brightness: brightness,
            StreamReactionPicker(
              message: message,
              reactionIcons: reactionIcons,
              onReactionPicked: (_) {},
            ),
          );
        },
      );

      goldenTest(
        'StreamReactionPicker with selected reaction in $theme theme',
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
            brightness: brightness,
            StreamReactionPicker(
              message: message,
              reactionIcons: reactionIcons,
              onReactionPicked: (_) {},
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
