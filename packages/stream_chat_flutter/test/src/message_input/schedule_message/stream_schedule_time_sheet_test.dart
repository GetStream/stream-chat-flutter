import 'package:alchemist/alchemist.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'schedule_message_harness.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> showStreamScheduleTimeSheet looks fine',
      fileName: 'stream_schedule_time_sheet_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 480),
      builder: () {
        // A fixed time the channel allows, so the image doesn't change with
        // today's date.
        final config = ChannelConfig(scheduledMessagesMaxLeadTime: const Duration(days: 365 * 100));
        final channel = scheduleChannel(config: config);
        final button = openButton(
          (context) => showStreamScheduleTimeSheet(
            context: context,
            channel: channel,
            message: messageToSchedule(),
            initialScheduledAt: DateTime(2099, 1, 15, 9),
          ),
        );
        return wrapWithMaterialApp(button, channel: channel, brightness: brightness);
      },
      whilePerforming: tapOpenButton,
    );
  }

  testWidgets('showStreamScheduleTimeSheet shows the date it starts at', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(), initialScheduledAt: DateTime(2026, 10, 23, 9));

      expect(find.text('Fri, Oct 23'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet shows the time it starts at', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(), initialScheduledAt: DateTime(2026, 10, 23, 9));

      expect(find.text('9:00 AM'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet is headed by the given title', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(), title: const Text('Reschedule message'));

      expect(find.text('Reschedule message'), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet names the message's channel", (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel());

      expect(find.text('Message to General'), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet previews the message's text", (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel());

      expect(find.textContaining('the launch moved to Monday', findRichText: true), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says how soon a new message can be scheduled', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      final config = ChannelConfig(scheduledMessagesMinLeadTime: const Duration(hours: 2));
      await showTimeSheet(tester, scheduleChannel(config: config));

      expect(find.text('Pick a time at least 120 minutes from now'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says to pick a later time when rescheduling too soon', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(), initialScheduledAt: wednesday.add(const Duration(seconds: 30)));

      expect(find.text("Pick a later time. Editing can't send a message right away."), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet can't schedule a time too soon", (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(), initialScheduledAt: wednesday.add(const Duration(seconds: 30)));

      expect(scheduleButton(tester).props.onPressed, isNull);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says the time is too far ahead', (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxLeadTime: const Duration(days: 7));

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(
        tester,
        scheduleChannel(config: config),
        initialScheduledAt: wednesday.add(const Duration(days: 8)),
      );

      expect(find.text("That's further ahead than your app allows"), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet can't schedule a time too far ahead", (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxLeadTime: const Duration(days: 7));

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(
        tester,
        scheduleChannel(config: config),
        initialScheduledAt: wednesday.add(const Duration(days: 8)),
      );

      expect(scheduleButton(tester).props.onPressed, isNull);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says the message is sent in the local time zone', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel());

      expect(find.textContaining('Sent in your time zone (GMT'), findsOneWidget);
    });
  });
}
