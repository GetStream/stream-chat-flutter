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
              child: PlatformWidgetBuilder(
                mobile: (context, child) => Text(
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
      TargetPlatform.android,
      TargetPlatform.iOS,
    }),
  );

  testWidgets(
    'PlatformWidgetBuilder builds the correct widget for desktop',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PlatformWidgetBuilder(
                desktop: (context, child) => Text(
                  '$debugDefaultTargetPlatformOverride',
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.text('$debugDefaultTargetPlatformOverride'), findsOneWidget);
    },
    variant: TargetPlatformVariant.desktop(),
  );

  testWidgets(
    'PlatformWidgetBuilder builds the correct widget for web',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PlatformWidgetBuilder(
                web: (context, child) => const Text('Web'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Web'), findsOneWidget);
    },
    variant: const TargetPlatformVariant({TargetPlatform.fuchsia}), // hacky :/
  );

  testWidgets(
    'PlatformWidgetBuilder builds the correct widget for desktopOrWeb',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: PlatformWidgetBuilder(
                desktopOrWeb: (context, child) => const Text('DesktopOrWeb'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('DesktopOrWeb'), findsOneWidget);
    },
    variant: const TargetPlatformVariant({
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.fuchsia, // Quick hack for web variant.
    }),
  );
}
