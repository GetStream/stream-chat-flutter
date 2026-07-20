import 'package:alchemist/alchemist.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/src/misc/timestamp.dart';
import 'package:stream_chat_flutter/src/theme/stream_chat_theme.dart';
import 'package:stream_core_flutter/chat.dart';

void main() {
  group('StreamTimestamp a11y', () {
    testWidgets('semanticsLabel: null (default) — bucketed natural-language phrasing', (tester) async {
      final handle = tester.ensureSemantics();

      // Pin "now" so the bucketing is deterministic — the date passed to the
      // widget is 2 days before now, so it falls in the "within last week"
      // bucket and announces as a weekday name.
      await withClock(Clock.fixed(DateTime(2026, 6, 15, 12)), () async {
        await tester.pumpWidget(
          _wrapWithMaterialApp(
            StreamTimestamp(date: DateTime(2026, 6, 13, 14, 30)),
          ),
        );
      });

      // The a11y label is bucketed via formatRecentDateTime — for a within-
      // last-week date, the weekday name appears with "at HH:mm".
      expect(find.bySemanticsLabel(RegExp('at 14:30')), findsOneWidget);
      handle.dispose();
    });

    testWidgets('semanticsLabel explicit — overrides the default', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(
        _wrapWithMaterialApp(
          StreamTimestamp(
            date: DateTime(2026, 1, 15, 10, 30),
            semanticsLabel: 'sent 2 hours ago',
          ),
        ),
      );

      expect(find.bySemanticsLabel('sent 2 hours ago'), findsOneWidget);
      // The default bucketed label is NOT applied when the override is set.
      expect(find.bySemanticsLabel(RegExp('at 10:30')), findsNothing);

      handle.dispose();
    });
  });

  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamTimestamp looks fine',
      fileName: 'stream_timestamp_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 400, height: 100),
      builder: () => _wrapWithMaterialApp(
        Builder(
          builder: (context) {
            return StreamTimestamp(
              date: DateTime.parse('2021-07-20T16:00:00.000Z'),
              style: context.streamTextTheme.captionDefault.copyWith(
                color: context.streamColorScheme.textPrimary,
              ),
            );
          },
        ),
        brightness: brightness,
      ),
    );
  }
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: context.streamColorScheme.backgroundApp,
            body: Center(child: widget),
          );
        },
      ),
    ),
  );
}
