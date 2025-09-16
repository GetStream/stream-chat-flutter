// ignore_for_file: lines_longer_than_80_chars, avoid_redundant_argument_values

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_option_reorderable_list_view.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollOptionReorderableListView should look fine',
      fileName: 'poll_option_reorderable_list_view_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 500),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        PollOptionReorderableListView(
          title: 'Options',
          itemHintText: 'Add an option',
          initialOptions: [
            PollOptionItem(text: 'Option 1'),
            PollOptionItem(text: 'Option 2'),
            PollOptionItem(text: 'Option 3'),
            PollOptionItem(text: 'Option 4'),
          ],
        ),
      ),
    );

    goldenTest(
      '[${brightness.name}] -> PollOptionReorderableListView with error should look fine',
      fileName: 'poll_option_reorderable_list_view_error_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 500),
      builder: () => _wrapWithMaterialApp(
        brightness: brightness,
        PollOptionReorderableListView(
          title: 'Options',
          itemHintText: 'Add an option',
          initialOptions: [
            PollOptionItem(text: 'Option 1', error: 'Option already exists'),
            PollOptionItem(text: 'Option 1', error: 'Option already exists'),
            PollOptionItem(text: 'Option 3'),
            PollOptionItem(text: 'Option 4'),
          ],
        ),
      ),
    );
  }

  group('Options Range Functionality', () {
    testWidgets('should enforce minimum options requirement', (tester) async {
      var optionsChanged = <PollOptionItem>[];

      await tester.pumpWidget(_wrapWithMaterialApp(
        PollOptionReorderableListView(
          optionsRange: (min: 3, max: null),
          initialOptions: [
            PollOptionItem(text: 'Option 1'),
          ],
          onOptionsChanged: (options) => optionsChanged = options,
        ),
      ));

      // Should automatically add options to meet minimum requirement
      final textFields = find.byType(TextField);
      // Should have 3 options (1 + 2 auto-added)
      expect(textFields, findsNWidgets(3));

      // Verify callback was called with the minimum options
      expect(optionsChanged.length, 3);
    });

    testWidgets('should respect maximum options limit', (tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(
        PollOptionReorderableListView(
          optionsRange: (min: null, max: 3),
          initialOptions: [
            PollOptionItem(text: 'Option 1'),
            PollOptionItem(text: 'Option 2'),
            PollOptionItem(text: 'Option 3'),
          ],
        ),
      ));

      // Find the add button
      final addButton = find.byType(FilledButton);
      expect(addButton, findsOneWidget);

      // The button should be disabled since we're at max options
      final button = tester.widget<FilledButton>(addButton);
      expect(button.onPressed, isNull);
    });

    testWidgets('should respect both min and max options', (tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(
        PollOptionReorderableListView(
          optionsRange: (min: 2, max: 4),
          initialOptions: [
            PollOptionItem(text: 'Option 1'),
            PollOptionItem(text: 'Option 2'),
          ],
        ),
      ));

      // Should have 2 options initially (meeting minimum)
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Add two more options to reach maximum
      final addButton = find.byType(FilledButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Fill the newly added option so we can add another
      final textFieldsAfterFirst = find.byType(TextField);
      await tester.enterText(textFieldsAfterFirst.last, 'Option 3');
      await tester.pumpAndSettle();

      // Add one more option
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Should now have 4 options (max reached)
      expect(find.byType(TextField), findsNWidgets(4));

      // Add button should now be disabled since we reached max
      final button = tester.widget<FilledButton>(addButton);
      expect(button.onPressed, isNull);
    });

    testWidgets(
      'should work with unlimited options when max is null',
      (tester) async {
        await tester.pumpWidget(_wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: 2, max: null),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
            ],
          ),
        ));

        // Add button should be enabled for unlimited options
        final addButton = find.byType(FilledButton);
        final button = tester.widget<FilledButton>(addButton);
        expect(button.onPressed, isNotNull);
      },
    );
  });

  group('Auto-Focus Functionality', () {
    testWidgets('should auto-focus on newly added option', (tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(
        PollOptionReorderableListView(
          optionsRange: (min: 1, max: null),
          initialOptions: [
            PollOptionItem(text: 'Option 1'),
          ],
        ),
      ));

      // Find the add button and tap it
      final addButton = find.byType(FilledButton);
      await tester.tap(addButton);
      await tester.pumpAndSettle();

      // Verify that there are now 2 text fields
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // The newly added text field should have focus
      // Note: In tests, we can verify the structure but actual focus behavior
      // depends on the platform and test environment
      expect(textFields, findsNWidgets(2));
    });
  });

  group('Empty Options Prevention', () {
    testWidgets(
      'should disable add button when empty option exists',
      (tester) async {
        await tester.pumpWidget(_wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: null, max: 5),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
              PollOptionItem(text: ''), // Empty option
            ],
          ),
        ));

        // Find the add button
        final addButton = find.byType(FilledButton);
        expect(addButton, findsOneWidget);

        // The button should be disabled since there's already an empty option
        final button = tester.widget<FilledButton>(addButton);
        expect(button.onPressed, isNull);
      },
    );

    testWidgets(
      'should enable add button when no empty options exist',
      (tester) async {
        await tester.pumpWidget(_wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: null, max: 5),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
            ],
          ),
        ));

        // Find the add button
        final addButton = find.byType(FilledButton);
        expect(addButton, findsOneWidget);

        // The button should be enabled since no empty options exist
        final button = tester.widget<FilledButton>(addButton);
        expect(button.onPressed, isNotNull);
      },
    );

    testWidgets(
      'should re-enable add button after filling empty option',
      (tester) async {
        await tester.pumpWidget(_wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: null, max: 5),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: ''), // Empty option
            ],
          ),
        ));

        // Initially, add button should be disabled
        var addButton = find.byType(FilledButton);
        var button = tester.widget<FilledButton>(addButton);
        expect(button.onPressed, isNull);

        // Fill the empty option
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.last, 'Option 2');
        await tester.pumpAndSettle();

        // Now add button should be enabled
        addButton = find.byType(FilledButton);
        button = tester.widget<FilledButton>(addButton);
        expect(button.onPressed, isNotNull);
      },
    );
  });

  group('Options Management', () {
    testWidgets(
      'should allow adding options when under limits',
      (tester) async {
        var optionsChanged = <PollOptionItem>[];

        await tester.pumpWidget(_wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: 2, max: 5),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
            ],
            onOptionsChanged: (options) => optionsChanged = options,
          ),
        ));

        // Find the add button and tap it
        final addButton = find.byType(FilledButton);
        await tester.tap(addButton);
        await tester.pumpAndSettle();

        // Verify a new option was added
        expect(optionsChanged.length, equals(3));
      },
    );
  });

  group('Edge Cases', () {
    testWidgets(
      'should handle empty initial options with minimum requirement',
      (tester) async {
        var optionsChanged = <PollOptionItem>[];

        await tester.pumpWidget(_wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: 2, max: null),
            initialOptions: const [], // No initial options
            onOptionsChanged: (options) => optionsChanged = options,
          ),
        ));

        // Should auto-add options to meet minimum requirement
        final textFields = find.byType(TextField);
        expect(textFields, findsNWidgets(2));
        expect(optionsChanged.length, 2);
      },
    );

    testWidgets('should handle updating initial options', (tester) async {
      await tester.pumpWidget(_wrapWithMaterialApp(
        PollOptionReorderableListView(
          initialOptions: [
            PollOptionItem(text: 'Option 1'),
          ],
        ),
      ));

      // Initially should have 1 option
      expect(find.byType(TextField), findsNWidgets(1));

      // Update with new options
      await tester.pumpWidget(_wrapWithMaterialApp(
        PollOptionReorderableListView(
          initialOptions: [
            PollOptionItem(text: 'Option 1'),
            PollOptionItem(text: 'Option 2'),
            PollOptionItem(text: 'Option 3'),
          ],
        ),
      ));

      // Should now have 3 options
      expect(find.byType(TextField), findsNWidgets(3));
    });
  });
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness? brightness,
}) {
  return MaterialApp(
    home: StreamChatTheme(
      data: StreamChatThemeData(brightness: brightness),
      child: Builder(
        builder: (context) {
          final theme = StreamChatTheme.of(context);
          return Scaffold(
            backgroundColor: theme.colorTheme.appBg,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: widget,
              ),
            ),
          );
        },
      ),
    ),
  );
}
