import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import 'schedule_message_harness.dart';

void main() {
  testWidgets('showStreamScheduleTimeSheet resolves with the time when Schedule is tapped', (tester) async {
    final scheduledAt = DateTime(2026, 10, 23, 9);

    await withClock(Clock.fixed(wednesday), () async {
      final results = await showTimeSheet(tester, scheduleChannel(), initialScheduledAt: scheduledAt);

      await tester.tap(confirmButton());
      await tester.pumpAndSettle();

      expect(results, [scheduledAt]);
    });
  });

  testWidgets('showStreamScheduleTimeSheet resolves null when its close button is tapped', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      final results = await showTimeSheet(tester, scheduleChannel());

      await tester.tap(closeButton());
      await tester.pumpAndSettle();

      expect(results, [null]);
    });
  });

  testWidgets('showStreamScheduleTimeSheet resolves null when dismissed', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      final results = await showTimeSheet(tester, scheduleChannel());

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(results, [null]);
    });
  });

  testWidgets('showStreamScheduleTimeSheet opened on its own is headed by a close button', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel());

      expect(closeButton(), findsOneWidget);
      expect(backButton(), findsNothing);
    });
  });
}
