import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

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

  testWidgets('showStreamScheduleTimeSheet passes the picked time to onSchedule', (tester) async {
    final scheduledAt = DateTime(2026, 10, 23, 9);
    final scheduled = <DateTime>[];

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(
        tester,
        scheduleChannel(),
        initialScheduledAt: scheduledAt,
        onSchedule: (time) async => scheduled.add(time),
      );

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(scheduled, [scheduledAt]);
    });
  });

  testWidgets('showStreamScheduleTimeSheet stays open with the error when scheduling fails', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      final results = await showTimeSheet(
        tester,
        scheduleChannel(),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
        onSchedule: (_) async => throw const StreamChatError('Boom'),
      );

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(find.text("Couldn't schedule message. Try again"), findsOneWidget);
      expect(results, isEmpty);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says the user holds their limit when scheduling fails for it', (
    tester,
  ) async {
    final config = ChannelConfig(scheduledMessagesMaxPerUser: 100);
    final limitReached = StreamChatNetworkError.raw(code: scheduledLimitUserCode, message: 'Limit reached');

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(
        tester,
        scheduleChannel(config: config),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
        onSchedule: (_) async => throw limitReached,
      );

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(find.text("You've reached your limit of 100 scheduled messages."), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says the channel holds its limit when scheduling fails for it', (
    tester,
  ) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 10);
    final limitReached = StreamChatNetworkError.raw(code: scheduledLimitChannelCode, message: 'Limit reached');

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(
        tester,
        scheduleChannel(config: config),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
        onSchedule: (_) async => throw limitReached,
      );

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(find.text('Limit reached (10 max)'), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet can't be canceled while it schedules", (tester) async {
    final scheduling = Completer<void>();

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(
        tester,
        scheduleChannel(),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
        onSchedule: (_) => scheduling.future,
      );

      await tester.tap(find.text('Schedule'));
      await tester.pump();

      expect(cancelButton(tester).props.onPressed, isNull);
    });
  });

  testWidgets("showStreamScheduleTimeSheet isn't closed by back while it schedules", (tester) async {
    final scheduling = Completer<void>();

    await withClock(Clock.fixed(wednesday), () async {
      final results = await showTimeSheet(
        tester,
        scheduleChannel(),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
        onSchedule: (_) => scheduling.future,
      );

      await tester.tap(find.text('Schedule'));
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(find.text('Date'), findsOneWidget);
      expect(results, isEmpty);
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
}
