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
        final channel = scheduleChannel();
        final button = openButton(
          (context) => showStreamScheduleTimeSheet(
            context: context,
            channel: channel,
            message: messageToSchedule(),
          ),
        );
        return wrapWithMaterialApp(button, channel: channel, brightness: brightness);
      },
      // The sheet starts an hour from now, so today's date is fixed for the
      // image.
      whilePerforming: (tester) => withClock(Clock.fixed(wednesday), () => tapOpenButton(tester)),
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

  testWidgets('showStreamScheduleTimeSheet is headed for scheduling without a time to start at', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel());

      expect(find.text('Schedule message'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet is headed for rescheduling when it starts at a time', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(), initialScheduledAt: DateTime(2026, 10, 23, 9));

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

  testWidgets('showStreamScheduleTimeSheet says the user holds their limit of scheduled messages', (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxPerUser: 2);
    final pending = [scheduledMessage('a'), scheduledMessage('b')];

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(config: config, scheduledMessages: pending));

      expect(find.text("You've reached your limit of 2 scheduled messages."), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet can't schedule while the user holds their limit", (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxPerUser: 2);
    final pending = [scheduledMessage('a'), scheduledMessage('b')];

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(config: config, scheduledMessages: pending));

      expect(scheduleButton(tester).props.onPressed, isNull);
    });
  });

  testWidgets('showStreamScheduleTimeSheet can reschedule while the user holds their limit', (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxPerUser: 2);
    final pending = [scheduledMessage('a'), scheduledMessage('b')];

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(
        tester,
        scheduleChannel(config: config, scheduledMessages: pending),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
      );

      expect(scheduleButton(tester).props.onPressed, isNotNull);
    });
  });

  testWidgets('showStreamScheduleTimeSheet previews when a rescheduled message is sent', (tester) async {
    final scheduledAt = DateTime(2026, 10, 23, 9);

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(), initialScheduledAt: scheduledAt);

      final label = DefaultTranslations.instance.scheduledMessageScheduledForText(scheduledAt: scheduledAt);
      expect(find.text(label), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet opens the time picker for typing the time', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel());

      await tester.tap(find.text('Time'));
      await tester.pumpAndSettle();

      final picker = tester.widget<TimePickerDialog>(find.byType(TimePickerDialog));
      expect(picker.initialEntryMode, TimePickerEntryMode.input);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says the channel holds its limit for a new message', (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 2);
    final pending = [scheduledMessage('a'), scheduledMessage('b')];

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(config: config, scheduledMessages: pending));

      expect(find.text('Limit reached (2 max)'), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet can't schedule a new message while the channel holds its limit", (
    tester,
  ) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 2);
    final pending = [scheduledMessage('a'), scheduledMessage('b')];

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, scheduleChannel(config: config, scheduledMessages: pending));

      expect(scheduleButton(tester).props.onPressed, isNull);
    });
  });

  testWidgets('showStreamScheduleTimeSheet can reschedule while the channel holds its limit', (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 2);
    final pending = [scheduledMessage('a'), scheduledMessage('b')];

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(
        tester,
        scheduleChannel(config: config, scheduledMessages: pending),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
      );

      expect(scheduleButton(tester).props.onPressed, isNotNull);
    });
  });

  testWidgets('showStreamScheduleTimeSheet names a channel whose members have no names as untitled', (
    tester,
  ) async {
    // A member without a user has no name to show.
    final channel = scheduleChannel(name: null, members: [Member(userId: 'other')]);

    await withClock(Clock.fixed(wednesday), () async {
      await showTimeSheet(tester, channel);

      expect(find.text('Message to No title'), findsOneWidget);
    });
  });
}
