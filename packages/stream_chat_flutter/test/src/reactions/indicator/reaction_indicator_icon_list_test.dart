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

  group('ReactionIndicatorIconList', () {
    testWidgets(
      'renders all reaction icons',
      (WidgetTester tester) async {
        final indicatorIcons = reactionIcons.map((icon) {
          return ReactionIndicatorIcon(
            type: icon.type,
            builder: icon.builder,
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionIndicatorIconList(
              indicatorIcons: [...indicatorIcons],
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should find the ReactionIndicatorIconList widget
        expect(find.byType(ReactionIndicatorIconList), findsOneWidget);
      },
    );

    testWidgets(
      'uses custom iconBuilder when provided',
      (WidgetTester tester) async {
        final indicatorIcons = reactionIcons.map((icon) {
          return ReactionIndicatorIcon(
            type: icon.type,
            builder: icon.builder,
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionIndicatorIconList(
              indicatorIcons: [...indicatorIcons],
              iconBuilder: (context, icon) {
                return Container(
                  key: Key('custom-icon-${icon.type}'),
                  child: icon.build(context),
                );
              },
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Verify custom builder was used
        expect(find.byKey(const Key('custom-icon-love')), findsOneWidget);
      },
    );

    testWidgets(
      'properly handles icons with selected state',
      (WidgetTester tester) async {
        final indicatorIcons = reactionIcons.map((icon) {
          return ReactionIndicatorIcon(
            type: icon.type,
            builder: icon.builder,
            isSelected: icon.type == 'love', // First icon is selected
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionIndicatorIconList(
              indicatorIcons: [...indicatorIcons],
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should render all icons
        expect(find.byType(ReactionIndicatorIconList), findsOneWidget);
      },
    );

    testWidgets(
      'updates when indicatorIcons change',
      (WidgetTester tester) async {
        // Build with initial set of reaction icons
        final initialIcons = reactionIcons.sublist(0, 2).map((icon) {
          return ReactionIndicatorIcon(
            type: icon.type,
            builder: icon.builder,
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionIndicatorIconList(
              indicatorIcons: [...initialIcons],
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Rebuild with all reaction icons
        final allIcons = reactionIcons.map((icon) {
          return ReactionIndicatorIcon(
            type: icon.type,
            builder: icon.builder,
          );
        });

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            ReactionIndicatorIconList(
              indicatorIcons: [...allIcons],
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Should have all icons rendered
        expect(find.byType(ReactionIndicatorIconList), findsOneWidget);
      },
    );

    group('Golden tests', () {
      for (final brightness in [Brightness.light, Brightness.dark]) {
        final theme = brightness.name;

        goldenTest(
          'ReactionIndicatorIconList in $theme theme',
          fileName: 'reaction_indicator_icon_list_$theme',
          constraints: const BoxConstraints.tightFor(width: 400, height: 100),
          builder: () {
            final indicatorIcons = reactionIcons.map((icon) {
              return ReactionIndicatorIcon(
                type: icon.type,
                builder: icon.builder,
              );
            });

            return _wrapWithMaterialApp(
              brightness: brightness,
              ReactionIndicatorIconList(
                indicatorIcons: [...indicatorIcons],
              ),
            );
          },
        );

        goldenTest(
          'ReactionIndicatorIconList with selected icon in $theme theme',
          fileName: 'reaction_indicator_icon_list_selected_$theme',
          constraints: const BoxConstraints.tightFor(width: 400, height: 100),
          builder: () {
            final indicatorIcons = reactionIcons.map((icon) {
              return ReactionIndicatorIcon(
                type: icon.type,
                builder: icon.builder,
                isSelected: icon.type == 'love',
              );
            });

            return _wrapWithMaterialApp(
              brightness: brightness,
              ReactionIndicatorIconList(
                indicatorIcons: [...indicatorIcons],
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
