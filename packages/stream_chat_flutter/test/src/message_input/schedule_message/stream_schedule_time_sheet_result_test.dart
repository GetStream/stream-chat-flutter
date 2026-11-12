import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

  testWidgets('showStreamScheduleTimeSheet keeps the sheet open when the time became too soon', (tester) async {
    var now = wednesday;
    final results = await withClock(Clock(() => now), () => showTimeSheet(tester, scheduleChannel()));

    // The sheet starts an hour ahead; two hours later that has passed.
    now = wednesday.add(const Duration(hours: 2));
    await withClock(Clock(() => now), () async {
      await tester.tap(confirmButton());
      await tester.pumpAndSettle();
    });

    expect(results, isEmpty);
    expect(find.text('Pick a time at least 1 minute from now'), findsOneWidget);
  });

  testWidgets('showStreamScheduleTimeSheet rounds a minimum under a minute up to one', (tester) async {
    final config = ChannelConfig(scheduledMessagesMinLeadTime: const Duration(seconds: 30));
    var now = wednesday;
    await withClock(Clock(() => now), () => showTimeSheet(tester, scheduleChannel(config: config)));

    now = wednesday.add(const Duration(hours: 2));
    await withClock(Clock(() => now), () async {
      await tester.tap(confirmButton());
      await tester.pumpAndSettle();
    });

    expect(find.text('Pick a time at least 1 minute from now'), findsOneWidget);
  });
}
