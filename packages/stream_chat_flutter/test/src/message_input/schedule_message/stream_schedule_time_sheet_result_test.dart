import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import 'schedule_message_harness.dart';

void main() {
  testWidgets('showStreamScheduleTimeSheet resolves with the time when Schedule is tapped', (tester) async {
    final scheduledAt = DateTime(2026, 10, 23, 9);

    await withClock(Clock.fixed(wednesday), () async {
      final results = await showTimeSheet(tester, scheduleChannel(), initialScheduledAt: scheduledAt);

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(results, [scheduledAt]);
    });
  });

  testWidgets('showStreamScheduleTimeSheet resolves null when Cancel is tapped', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      final results = await showTimeSheet(tester, scheduleChannel());

      await tester.tap(find.text('Cancel'));
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
}
