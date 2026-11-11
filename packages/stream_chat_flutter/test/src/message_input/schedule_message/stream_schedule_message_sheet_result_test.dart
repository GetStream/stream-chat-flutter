import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';

import 'schedule_message_harness.dart';

void main() {
  testWidgets('showStreamScheduleMessageSheet resolves with the time picked in the custom time sheet', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      final results = await showMessageSheet(tester, scheduleChannel());
      await tester.tap(find.text('Custom time'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      // The custom time sheet starts an hour from now.
      expect(results, [DateTime(2026, 10, 21, 11)]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet stays open when the custom time sheet is canceled', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      final results = await showMessageSheet(tester, scheduleChannel());
      await tester.tap(find.text('Custom time'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.text('Custom time'), findsOneWidget);
      expect(results, isEmpty);
    });
  });
}
