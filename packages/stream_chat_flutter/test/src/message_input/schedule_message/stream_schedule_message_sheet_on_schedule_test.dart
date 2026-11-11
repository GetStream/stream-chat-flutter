import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'schedule_message_harness.dart';

void main() {
  testWidgets('showStreamScheduleMessageSheet returns a custom time scheduled with onSchedule', (tester) async {
    final scheduled = <DateTime>[];

    await withClock(Clock.fixed(wednesday), () async {
      final results = await showMessageSheet(
        tester,
        scheduleChannel(),
        onSchedule: (scheduledAt) async => scheduled.add(scheduledAt),
      );
      await tester.tap(find.text('Custom time'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(results, scheduled);
    });
  });

  testWidgets("showStreamScheduleMessageSheet doesn't schedule a custom time again", (tester) async {
    final scheduled = <DateTime>[];

    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(
        tester,
        scheduleChannel(),
        onSchedule: (scheduledAt) async => scheduled.add(scheduledAt),
      );
      await tester.tap(find.text('Custom time'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(scheduled, hasLength(1));
    });
  });

  testWidgets('showStreamScheduleMessageSheet schedules a tapped preset with onSchedule', (tester) async {
    final scheduled = <DateTime>[];

    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(tester, scheduleChannel(), onSchedule: (scheduledAt) async => scheduled.add(scheduledAt));

      await tester.tap(find.text('Tomorrow at 9:00\u202fAM'));
      await tester.pumpAndSettle();

      expect(scheduled, [DateTime(2026, 10, 22, 9)]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet completes with the error when scheduling a preset fails', (
    tester,
  ) async {
    final errors = <Object>[];

    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(
        tester,
        scheduleChannel(),
        onSchedule: (_) async => throw const StreamChatError('Boom'),
        onError: errors.add,
      );

      await tester.tap(find.text('Tomorrow at 9:00\u202fAM'));
      await tester.pumpAndSettle();

      expect(errors, [const StreamChatError('Boom')]);
    });
  });
}
