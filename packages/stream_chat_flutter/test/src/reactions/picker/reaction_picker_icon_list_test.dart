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

  group('ReactionIconButton', () {
    testWidgets(
      'renders correctly with selected state',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionIconButton(
              icon: ReactionPickerIcon(
                isSelected: true,
                type: reactionIcons.first.type,
                builder: reactionIcons.first.builder,
              ),
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
              icon: ReactionPickerIcon(
                type: reactionIcons.first.type,
                builder: reactionIcons.first.builder,
              ),
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
              icon: ReactionPickerIcon(
                type: reactionIcons.first.type,
                builder: reactionIcons.first.builder,
              ),
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
              icon: ReactionPickerIcon(
                isSelected: true,
                type: reactionIcons.first.type,
                builder: reactionIcons.first.builder,
              ),
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
        final pickerIcons = reactionIcons.map((icon) {
          return ReactionPickerIcon(
            type: icon.type,
            builder: icon.builder,
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              reactionIcons: [...pickerIcons],
              onIconPicked: (_) {},
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
      'triggers onIconPicked when a reaction icon is tapped',
      (WidgetTester tester) async {
        final pickerIcons = reactionIcons.map((icon) {
          return ReactionPickerIcon(
            type: icon.type,
            builder: icon.builder,
          );
        });

        ReactionPickerIcon? pickedIcon;

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              reactionIcons: [...pickerIcons],
              onIconPicked: (icon) => pickedIcon = icon,
            ),
          ),
        );

        // Wait for animations to complete
        await tester.pumpAndSettle();

        // Tap the first reaction icon
        await tester.tap(find.byType(IconButton).first);
        await tester.pump();

        // Verify callback was triggered with correct reaction type
        expect(pickedIcon, isNotNull);
        expect(pickedIcon!.type, 'love');
      },
    );

    testWidgets(
      'shows reaction icons with animation',
      (WidgetTester tester) async {
        final pickerIcons = reactionIcons.map((icon) {
          return ReactionPickerIcon(
            type: icon.type,
            builder: icon.builder,
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              reactionIcons: [...pickerIcons],
              onIconPicked: (_) {},
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
      'properly handles icons with selected state',
      (WidgetTester tester) async {
        // Create icons with one being selected
        final pickerIcons = reactionIcons.map((icon) {
          return ReactionPickerIcon(
            type: icon.type,
            builder: icon.builder,
            isSelected: icon.type == 'love', // First icon is selected
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            Material(
              child: ReactionPickerIconList(
                reactionIcons: [...pickerIcons],
                onIconPicked: (_) {},
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
        // Build with initial set of reaction icons
        final initialIcons = reactionIcons.sublist(0, 2).map((icon) {
          return ReactionPickerIcon(
            type: icon.type,
            builder: icon.builder,
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              reactionIcons: [...initialIcons],
              onIconPicked: (_) {},
            ),
          ),
        );

        await tester.pumpAndSettle();
        expect(find.byType(IconButton), findsNWidgets(2));

        // Rebuild with all reaction icons
        final allIcons = reactionIcons.map((icon) {
          return ReactionPickerIcon(
            type: icon.type,
            builder: icon.builder,
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionPickerIconList(
              reactionIcons: [...allIcons],
              onIconPicked: (_) {},
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
            final pickerIcons = reactionIcons.map((icon) {
              return ReactionPickerIcon(
                type: icon.type,
                builder: icon.builder,
              );
            });

            return _wrapWithMaterialApp(
              brightness: brightness,
              ReactionPickerIconList(
                reactionIcons: [...pickerIcons],
                onIconPicked: (_) {},
              ),
            );
          },
        );

        goldenTest(
          'ReactionPickerIconList with selected reaction in $theme theme',
          fileName: 'reaction_picker_icon_list_selected_$theme',
          constraints: const BoxConstraints.tightFor(width: 400, height: 100),
          builder: () {
            final pickerIcons = reactionIcons.map((icon) {
              return ReactionPickerIcon(
                type: icon.type,
                builder: icon.builder,
                isSelected: icon.type == 'love', // First icon is selected
              );
            });

            return _wrapWithMaterialApp(
              brightness: brightness,
              ReactionPickerIconList(
                reactionIcons: [...pickerIcons],
                onIconPicked: (_) {},
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
          backgroundColor: theme.colorTheme.overlay,
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
