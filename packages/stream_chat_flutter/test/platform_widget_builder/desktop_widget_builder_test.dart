import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/platform_widget_builder/platform_widget_builder.dart';

void main() {
  testWidgets(
    'PlatformWidgetBuilder builds the correct widget for mobile',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DesktopWidgetBuilder(
                macOS: (context, child) => Text(
                  '$debugDefaultTargetPlatformOverride',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('$debugDefaultTargetPlatformOverride'), findsOneWidget);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.macOS,
    }),
  );

  testWidgets(
    'PlatformWidgetBuilder builds the correct widget for desktop',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DesktopWidgetBuilder(
                windows: (context, child) => Text(
                  '$debugDefaultTargetPlatformOverride',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('$debugDefaultTargetPlatformOverride'), findsOneWidget);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.windows,
    }),
  );

  testWidgets(
    'PlatformWidgetBuilder builds the correct widget for web',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: DesktopWidgetBuilder(
                linux: (context, child) => const Text('Web'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Web'), findsOneWidget);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.linux,
    }),
  );
}
