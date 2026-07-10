import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  // Pumps a screen that renders a button. When tapped, the button opens a
  // dialog via [showStreamDialog] whose body is [dialogBody]. The screen
  // is wrapped in a [StreamChatTheme] carrying [themeData] so we can verify
  // it propagates across the route boundary.
  Future<void> pumpAndOpenDialog(
    WidgetTester tester, {
    required StreamChatThemeData themeData,
    required Widget dialogBody,
    required bool useRootNavigator,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: themeData,
          child: Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: TextButton(
                  onPressed: () => showStreamDialog<void>(
                    context: context,
                    useRootNavigator: useRootNavigator,
                    builder: (_) => dialogBody,
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
  }

  for (final useRootNavigator in [false, true]) {
    final scope = useRootNavigator ? 'root Navigator' : 'nearest Navigator';

    testWidgets(
      'showStreamDialog propagates StreamChatTheme to descendants inside the dialog ($scope)',
      (tester) async {
        final themeData = StreamChatThemeData();

        StreamChatThemeData? capturedInsideDialog;

        await pumpAndOpenDialog(
          tester,
          themeData: themeData,
          useRootNavigator: useRootNavigator,
          dialogBody: Builder(
            builder: (context) {
              capturedInsideDialog = StreamChatTheme.of(context);
              return const Text('DialogBody');
            },
          ),
        );

        expect(find.text('DialogBody'), findsOneWidget);
        expect(capturedInsideDialog, isNotNull);
        // StreamChatTheme.of returns the same data reference the caller set up,
        // proving InheritedTheme.capture forwards it across the route boundary.
        expect(identical(capturedInsideDialog, themeData), isTrue);
      },
    );

    testWidgets(
      'showStreamDialog does not double-wrap StreamChatTheme in the dialog subtree ($scope)',
      (tester) async {
        await pumpAndOpenDialog(
          tester,
          themeData: StreamChatThemeData(),
          useRootNavigator: useRootNavigator,
          dialogBody: const Text('DialogBody'),
        );

        final ancestorStreamChatThemes = find.ancestor(
          of: find.text('DialogBody'),
          matching: find.byType(StreamChatTheme),
        );

        // Exactly one StreamChatTheme should sit between the dialog body and
        // the root — the one re-applied by `capturedThemes.wrap`. An extra
        // explicit `StreamChatTheme(data: theme, ...)` wrap in the pageBuilder
        // would produce two, which is redundant and adds a wasted rebuild
        // link. This test guards against reintroducing that double-wrap.
        expect(ancestorStreamChatThemes, findsOneWidget);
      },
    );
  }
}
