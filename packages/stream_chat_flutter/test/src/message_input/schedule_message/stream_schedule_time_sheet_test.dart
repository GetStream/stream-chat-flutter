import 'dart:async';

import 'package:alchemist/alchemist.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamScheduleTimeSheet looks fine',
      fileName: 'stream_schedule_time_sheet_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 480),
      builder: () {
        // A fixed time the channel allows, so the image doesn't change with
        // today's date.
        final config = ChannelConfig(scheduledMessagesMaxLeadTime: const Duration(days: 365 * 100));
        final channel = _channel(config: config);
        return _wrapWithMaterialApp(
          StreamScheduleTimeSheet(
            channel: channel,
            message: _message(),
            initialScheduledAt: DateTime(2099, 1, 15, 9),
          ),
          channel: channel,
          brightness: brightness,
        );
      },
    );
  }

  testWidgets('showStreamScheduleTimeSheet shows the date it starts at', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(), initialScheduledAt: DateTime(2026, 10, 23, 9));

      expect(find.text('Fri, Oct 23'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet shows the time it starts at', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(), initialScheduledAt: DateTime(2026, 10, 23, 9));

      expect(find.text('9:00 AM'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet is headed by the given title', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(), title: const Text('Reschedule message'));

      expect(find.text('Reschedule message'), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet names the message's channel", (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel());

      expect(find.text('Message to General'), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet previews the message's text", (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel());

      expect(find.textContaining('the launch moved to Monday', findRichText: true), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says how soon a new message can be scheduled', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      final config = ChannelConfig(scheduledMessagesMinLeadTime: const Duration(hours: 2));
      await _showSheet(tester, _channel(config: config));

      expect(find.text('Pick a time at least 120 minutes from now'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says to pick a later time when rescheduling too soon', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(), initialScheduledAt: _wednesday.add(const Duration(seconds: 30)));

      expect(find.text("Pick a later time. Editing can't send a message right away."), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet can't schedule a time too soon", (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(), initialScheduledAt: _wednesday.add(const Duration(seconds: 30)));

      expect(_scheduleButton(tester).props.onPressed, isNull);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says the time is too far ahead', (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxLeadTime: const Duration(days: 7));

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(
        tester,
        _channel(config: config),
        initialScheduledAt: _wednesday.add(const Duration(days: 8)),
      );

      expect(find.text("That's further ahead than your app allows"), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet can't schedule a time too far ahead", (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxLeadTime: const Duration(days: 7));

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(
        tester,
        _channel(config: config),
        initialScheduledAt: _wednesday.add(const Duration(days: 8)),
      );

      expect(_scheduleButton(tester).props.onPressed, isNull);
    });
  });

  testWidgets('showStreamScheduleTimeSheet says the message is sent in the local time zone', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel());

      expect(find.textContaining('Sent in your time zone (GMT'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleTimeSheet resolves with the time when Schedule is tapped', (tester) async {
    final scheduledAt = DateTime(2026, 10, 23, 9);

    await withClock(Clock.fixed(_wednesday), () async {
      final results = await _showSheet(tester, _channel(), initialScheduledAt: scheduledAt);

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(results, [scheduledAt]);
    });
  });

  testWidgets('showStreamScheduleTimeSheet passes the picked time to onSchedule', (tester) async {
    final scheduledAt = DateTime(2026, 10, 23, 9);
    final scheduled = <DateTime>[];

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(
        tester,
        _channel(),
        initialScheduledAt: scheduledAt,
        onSchedule: (time) async => scheduled.add(time),
      );

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(scheduled, [scheduledAt]);
    });
  });

  testWidgets('showStreamScheduleTimeSheet stays open with the error when scheduling fails', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      final results = await _showSheet(
        tester,
        _channel(),
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
    final limitReached = StreamChatNetworkError.raw(code: _scheduledLimitUserCode, message: 'Limit reached');

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(
        tester,
        _channel(config: config),
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
    final limitReached = StreamChatNetworkError.raw(code: _scheduledLimitChannelCode, message: 'Limit reached');

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(
        tester,
        _channel(config: config),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
        onSchedule: (_) async => throw limitReached,
      );

      await tester.tap(find.text('Schedule'));
      await tester.pumpAndSettle();

      expect(find.text('Limit reached (10 max)'), findsOneWidget);
    });
  });

  testWidgets("showStreamScheduleTimeSheet can't be cancelled while it schedules", (tester) async {
    final scheduling = Completer<void>();

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(
        tester,
        _channel(),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
        onSchedule: (_) => scheduling.future,
      );

      await tester.tap(find.text('Schedule'));
      await tester.pump();

      expect(_cancelButton(tester).props.onPressed, isNull);
    });
  });

  testWidgets("showStreamScheduleTimeSheet isn't closed by back while it schedules", (tester) async {
    final scheduling = Completer<void>();

    await withClock(Clock.fixed(_wednesday), () async {
      final results = await _showSheet(
        tester,
        _channel(),
        initialScheduledAt: DateTime(2026, 10, 23, 9),
        onSchedule: (_) => scheduling.future,
      );

      await tester.tap(find.text('Schedule'));
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pump();

      expect(find.byType(StreamScheduleTimeSheet), findsOneWidget);
      expect(results, isEmpty);
    });
  });

  testWidgets('showStreamScheduleTimeSheet resolves null when Cancel is tapped', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      final results = await _showSheet(tester, _channel());

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(results, [null]);
    });
  });
}

// The error codes of a user and a channel holding their limit of scheduled
// messages.
const _scheduledLimitUserCode = 118;
const _scheduledLimitChannelCode = 117;

// A Wednesday morning in local time.
final _wednesday = DateTime(2026, 10, 21, 10);

const _cid = 'test-chanel-type:test-channel-id';

Message _message() => Message(id: 'message-id', text: 'Heads up: the launch moved to Monday.');

MockChannel _channel({ChannelConfig? config}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();
  final model = ChannelModel(cid: _cid, extraData: const {'name': 'General'});

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user'));
  when(() => clientState.scheduledMessages).thenReturn([]);
  when(() => channel.client).thenReturn(client);
  when(() => channel.config).thenReturn(config ?? ChannelConfig());
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.channelState).thenReturn(ChannelState(channel: model));
  when(() => channelState.members).thenReturn([]);

  return channel;
}

StreamButton _cancelButton(WidgetTester tester) {
  return tester.widget<StreamButton>(find.widgetWithText(StreamButton, 'Cancel'));
}

StreamButton _scheduleButton(WidgetTester tester) {
  return tester.widget<StreamButton>(find.widgetWithText(StreamButton, 'Schedule'));
}

// Opens the custom time sheet for [channel] and returns the list its result
// is added to once the sheet resolves.
Future<List<DateTime?>> _showSheet(
  WidgetTester tester,
  MockChannel channel, {
  DateTime? initialScheduledAt,
  Widget? title,
  Future<void> Function(DateTime scheduledAt)? onSchedule,
}) async {
  final results = <DateTime?>[];
  await tester.pumpWidget(
    _wrapWithMaterialApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showStreamScheduleTimeSheet(
            context,
            channel: channel,
            message: _message(),
            initialScheduledAt: initialScheduledAt,
            title: title,
            onSchedule: onSchedule,
          ).then(results.add),
          child: const Text('Open'),
        ),
      ),
      channel: channel,
    ),
  );

  await tester.tap(find.text('Open'));
  await tester.pumpAndSettle();
  return results;
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  required MockChannel channel,
  Brightness brightness = Brightness.light,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    // Above the navigator, so the sheet's route is within it too.
    builder: (context, child) => StreamChat(
      client: channel.client,
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      child: child,
    ),
    home: Builder(
      builder: (context) => Scaffold(
        backgroundColor: context.streamColorScheme.backgroundApp,
        body: Center(child: widget),
      ),
    ),
  );
}
