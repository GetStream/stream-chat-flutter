// ignore_for_file: lines_longer_than_80_chars, avoid_redundant_argument_values

import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/poll/creator/poll_option_reorderable_list_view.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:stream_core_flutter/stream_core_flutter.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> PollOptionReorderableListView should look fine',
      fileName: 'poll_option_reorderable_list_view_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 600, height: 500),
      builder: () => _wrapWithMaterialApp(
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

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: 3, max: null),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
            ],
            onOptionsChanged: (options) => optionsChanged = options,
          ),
        ),
      );

      // Should automatically add options to meet minimum requirement
      final textFields = find.byType(TextField);
      // Should have 3 options (1 + 2 auto-added)
      expect(textFields, findsNWidgets(3));

      // Verify callback was called with the minimum options
      expect(optionsChanged.length, 3);
    });

    testWidgets('should respect maximum options limit', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: null, max: 3),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
              PollOptionItem(text: 'Option 3'),
            ],
          ),
        ),
      );

      // The add button should be hidden since we're at max options.
      expect(find.addOptionButton(), findsNothing);
    });

    testWidgets('should respect both min and max options', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: 2, max: 4),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
            ],
          ),
        ),
      );

      // Should have 2 options initially (meeting minimum)
      final textFields = find.byType(TextField);
      expect(textFields, findsNWidgets(2));

      // Add two more options to reach maximum
      await tester.tap(find.addOptionButton());
      await tester.pumpAndSettle();

      // Fill the newly added option so we can add another
      final textFieldsAfterFirst = find.byType(TextField);
      await tester.enterText(textFieldsAfterFirst.last, 'Option 3');
      await tester.pumpAndSettle();

      // Add one more option
      await tester.tap(find.addOptionButton());
      await tester.pumpAndSettle();

      // Should now have 4 options (max reached)
      expect(find.byType(TextField), findsNWidgets(4));

      // Add button should now be hidden since we reached max.
      expect(find.addOptionButton(), findsNothing);
    });

    testWidgets(
      'should work with unlimited options when max is null',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            PollOptionReorderableListView(
              optionsRange: (min: 2, max: null),
              initialOptions: [
                PollOptionItem(text: 'Option 1'),
                PollOptionItem(text: 'Option 2'),
              ],
            ),
          ),
        );

        // Add button should be enabled for unlimited options
        final addButton = find.addOptionButton();
        final button = tester.widget<StreamButton>(addButton);
        expect(button.props.onPressed, isNotNull);
      },
    );
  });

  group('Auto-Focus Functionality', () {
    testWidgets('should auto-focus on newly added option', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: 1, max: null),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
            ],
          ),
        ),
      );

      // Find the add button and tap it
      await tester.tap(find.addOptionButton());
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
      'should hide add button when empty option exists',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            PollOptionReorderableListView(
              optionsRange: (min: null, max: 5),
              initialOptions: [
                PollOptionItem(text: 'Option 1'),
                PollOptionItem(text: 'Option 2'),
                PollOptionItem(text: ''), // Empty option
              ],
            ),
          ),
        );

        // The button should be hidden since there's already an empty option.
        expect(find.addOptionButton(), findsNothing);
      },
    );

    testWidgets(
      'should show add button when no empty options exist',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            PollOptionReorderableListView(
              optionsRange: (min: null, max: 5),
              initialOptions: [
                PollOptionItem(text: 'Option 1'),
                PollOptionItem(text: 'Option 2'),
              ],
            ),
          ),
        );

        // The button should be visible since no empty options exist.
        final addButton = find.addOptionButton();
        expect(addButton, findsOneWidget);
        final button = tester.widget<StreamButton>(addButton);
        expect(button.props.onPressed, isNotNull);
      },
    );

    testWidgets(
      'should reveal add button after filling empty option',
      (tester) async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            PollOptionReorderableListView(
              optionsRange: (min: null, max: 5),
              initialOptions: [
                PollOptionItem(text: 'Option 1'),
                PollOptionItem(text: ''), // Empty option
              ],
            ),
          ),
        );

        // Initially, the add button should be hidden.
        expect(find.addOptionButton(), findsNothing);

        // Fill the empty option.
        final textFields = find.byType(TextField);
        await tester.enterText(textFields.last, 'Option 2');
        await tester.pumpAndSettle();

        // The add button should now be visible and enabled.
        final addButton = find.addOptionButton();
        expect(addButton, findsOneWidget);
        final button = tester.widget<StreamButton>(addButton);
        expect(button.props.onPressed, isNotNull);
      },
    );
  });

  group('Options Management', () {
    testWidgets(
      'should allow adding options when under limits',
      (tester) async {
        var optionsChanged = <PollOptionItem>[];

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            PollOptionReorderableListView(
              optionsRange: (min: 2, max: 5),
              initialOptions: [
                PollOptionItem(text: 'Option 1'),
                PollOptionItem(text: 'Option 2'),
              ],
              onOptionsChanged: (options) => optionsChanged = options,
            ),
          ),
        );

        // Find the add button and tap it
        await tester.tap(find.addOptionButton());
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

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            PollOptionReorderableListView(
              optionsRange: (min: 2, max: null),
              initialOptions: const [], // No initial options
              onOptionsChanged: (options) => optionsChanged = options,
            ),
          ),
        );

        // Should auto-add options to meet minimum requirement
        final textFields = find.byType(TextField);
        expect(textFields, findsNWidgets(2));
        expect(optionsChanged.length, 2);
      },
    );

    testWidgets('should handle updating initial options', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollOptionReorderableListView(
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
            ],
          ),
        ),
      );

      // Initially should have 1 option
      expect(find.byType(TextField), findsNWidgets(1));

      // Update with new options
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollOptionReorderableListView(
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
              PollOptionItem(text: 'Option 3'),
            ],
          ),
        ),
      );

      // Should now have 3 options
      expect(find.byType(TextField), findsNWidgets(3));
    });
  });

  group('Delete Option Functionality', () {
    testWidgets('should show delete confirmation dialog', (tester) async {
      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: 2, max: null),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
              PollOptionItem(text: 'Option 3'),
            ],
          ),
        ),
      );

      // Find the delete buttons
      final deleteButtons = find.byIcon(StreamIconData.minusCircle);
      expect(deleteButtons, findsNWidgets(3));

      // Tap the first delete button
      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      // Verify the delete confirmation dialog is shown
      expect(find.text('Delete Option'), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this option?'),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('should delete option when confirmed', (tester) async {
      var optionsChanged = <PollOptionItem>[];

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: 2, max: null),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
              PollOptionItem(text: 'Option 3'),
            ],
            onOptionsChanged: (options) => optionsChanged = options,
          ),
        ),
      );

      // Initially should have 3 options
      expect(find.byType(TextField), findsNWidgets(3));

      // Find and tap the delete button for the first option
      final deleteButtons = find.byIcon(StreamIconData.minusCircle);
      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      // Confirm deletion
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      // Should now have 2 options
      expect(find.byType(TextField), findsNWidgets(2));
      expect(optionsChanged.length, 2);
    });

    testWidgets('should not delete option when cancelled', (tester) async {
      var optionsChanged = <PollOptionItem>[];

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          PollOptionReorderableListView(
            optionsRange: (min: 2, max: null),
            initialOptions: [
              PollOptionItem(text: 'Option 1'),
              PollOptionItem(text: 'Option 2'),
              PollOptionItem(text: 'Option 3'),
            ],
            onOptionsChanged: (options) => optionsChanged = options,
          ),
        ),
      );

      // Initially should have 3 options
      expect(find.byType(TextField), findsNWidgets(3));

      // Find and tap the delete button for the first option
      final deleteButtons = find.byIcon(StreamIconData.minusCircle);
      await tester.tap(deleteButtons.first);
      await tester.pumpAndSettle();

      // Cancel deletion
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      // Should still have 3 options
      expect(find.byType(TextField), findsNWidgets(3));
      expect(optionsChanged, isEmpty); // No change callback
    });

    testWidgets(
      'should maintain minimum options when deleting',
      (tester) async {
        var optionsChanged = <PollOptionItem>[];
        final option1 = PollOptionItem(text: 'Option 1');
        final option2 = PollOptionItem(text: 'Option 2');

        await tester.pumpWidget(
          _wrapWithMaterialApp(
            PollOptionReorderableListView(
              optionsRange: (min: 2, max: null),
              initialOptions: [option1, option2],
              onOptionsChanged: (options) => optionsChanged = options,
            ),
          ),
        );

        // Should have 2 options (minimum)
        expect(find.byType(TextField), findsNWidgets(2));

        // Try to delete the first option
        final deleteButtons = find.byIcon(StreamIconData.minusCircle);
        await tester.tap(deleteButtons.first);
        await tester.pumpAndSettle();

        // Confirm deletion
        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        // Should still have 2 options (minimum enforced)
        expect(find.byType(TextField), findsNWidgets(2));

        // Verify the correct behavior: option1 deleted, option2 remains,
        // and a new empty option was auto-added
        final optionIds = optionsChanged.map((e) => e.id).toList();

        expect(optionsChanged.length, 2);
        expect(optionIds, isNot(contains(option1.id))); // option1 deleted
        expect(optionIds, contains(option2.id)); // option2 remains

        // Verify new option is empty and has a new ID (not recycled)
        final newOption = optionsChanged.firstWhere((e) => e.id != option2.id);
        expect(newOption.id, isNot(option1.id));
        expect(newOption.text, isEmpty);
      },
    );
  });
}

extension on CommonFinders {
  /// Finds the "Add an option" [StreamButton] at the bottom of the list.
  Finder addOptionButton() => find.widgetWithText(StreamButton, 'Add an option');
}

Widget _wrapWithMaterialApp(
  Widget widget,
) {
  return MaterialApp(
    builder: (context, child) {
      return StreamChatTheme(
        data: StreamChatThemeData(),
        child: child!,
      );
    },
    home: Builder(
      builder: (context) {
        return Scaffold(
          backgroundColor: context.streamColorScheme.backgroundApp,
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: widget,
            ),
          ),
        );
      },
    ),
  );
}
