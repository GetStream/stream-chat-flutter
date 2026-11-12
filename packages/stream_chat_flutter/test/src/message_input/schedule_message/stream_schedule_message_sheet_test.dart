import 'package:alchemist/alchemist.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'schedule_message_harness.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> showStreamScheduleMessageSheet looks fine',
      fileName: 'stream_schedule_message_sheet_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 360),
      builder: () {
        final channel = scheduleChannel();
        final button = openButton(
          (context) => showStreamScheduleMessageSheet(
            context: context,
            channel: channel,
            message: messageToSchedule(),
          ),
        );
        return wrapWithMaterialApp(button, channel: channel, brightness: brightness);
      },
      // The presets follow today's date, so it's fixed for the image.
      whilePerforming: (tester) => withClock(Clock.fixed(wednesday), () => tapOpenButton(tester)),
    );
  }

  testWidgets('showStreamScheduleMessageSheet offers tomorrow morning and afternoon and Monday morning', (
    tester,
  ) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(tester, scheduleChannel());

      expect(rowLabels(tester), [
        'Tomorrow at 9:00\u202fAM',
        'Tomorrow at 1:00\u202fPM',
        'Monday at 9:00\u202fAM',
        'Custom time',
      ]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet resolves with the tapped preset', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      final results = await showMessageSheet(tester, scheduleChannel());

      await tester.tap(find.text('Tomorrow at 1:00\u202fPM'));
      await tester.pumpAndSettle();

      expect(results, [DateTime(2026, 10, 22, 13)]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet offers the Monday a week later when tomorrow is Monday', (
    tester,
  ) async {
    await withClock(Clock.fixed(DateTime(2026, 10, 25, 10)), () async {
      final results = await showMessageSheet(tester, scheduleChannel());

      await tester.tap(find.text('Monday at 9:00\u202fAM'));
      await tester.pumpAndSettle();

      expect(results, [DateTime(2026, 11, 2, 9)]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet hides presets further ahead than the channel allows', (
    tester,
  ) async {
    final config = ChannelConfig(scheduledMessagesMaxLeadTime: const Duration(days: 1));

    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(tester, scheduleChannel(config: config));

      expect(rowLabels(tester), ['Tomorrow at 9:00\u202fAM', 'Custom time']);
    });
  });

  testWidgets('showStreamScheduleMessageSheet hides presets sooner than the channel allows', (tester) async {
    final config = ChannelConfig(scheduledMessagesMinLeadTime: const Duration(hours: 24));

    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(tester, scheduleChannel(config: config));

      expect(rowLabels(tester), ['Tomorrow at 1:00\u202fPM', 'Monday at 9:00\u202fAM', 'Custom time']);
    });
  });

  testWidgets('showStreamScheduleMessageSheet says the limit is reached when the channel holds its limit', (
    tester,
  ) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 2);
    final pending = [scheduledMessage('a'), scheduledMessage('b')];

    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(tester, scheduleChannel(config: config, scheduledMessages: pending));

      expect(find.text('Limit reached (2 max)'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleMessageSheet disables every row when the channel holds its limit', (
    tester,
  ) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 2);
    final pending = [scheduledMessage('a'), scheduledMessage('b')];

    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(tester, scheduleChannel(config: config, scheduledMessages: pending));

      final tiles = tester.widgetList<StreamListTile>(find.byType(StreamListTile));
      expect(tiles, isNotEmpty);
      expect(tiles.map((it) => it.props.enabled), everyElement(isFalse));
    });
  });

  testWidgets("showStreamScheduleMessageSheet doesn't count failed messages toward the limit", (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 2);
    final scheduledMessages = [
      scheduledMessage('a'),
      scheduledMessage('b', status: ScheduledMessageStatus.failed),
    ];

    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(tester, scheduleChannel(config: config, scheduledMessages: scheduledMessages));

      expect(find.text('Schedule message'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleMessageSheet opens the custom time sheet on top', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      await showMessageSheet(tester, scheduleChannel());

      await tester.tap(find.text('Custom time'));
      await tester.pumpAndSettle();

      expect(find.text('Date'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleMessageSheet resolves null when dismissed', (tester) async {
    await withClock(Clock.fixed(wednesday), () async {
      final results = await showMessageSheet(tester, scheduleChannel());

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(results, [null]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet keeps preset hours across a daylight saving change', (tester) async {
    // In zones that observe it, 2026-10-25 is the day clocks go back an hour.
    await withClock(Clock.fixed(DateTime(2026, 10, 24, 10)), () async {
      final results = await showMessageSheet(tester, scheduleChannel());

      await tester.tap(find.text('Tomorrow at 1:00\u202fPM'));
      await tester.pumpAndSettle();

      final scheduledAt = results.single!;
      expect((scheduledAt.day, scheduledAt.hour, scheduledAt.minute), (25, 13, 0));
    });
  });
}
