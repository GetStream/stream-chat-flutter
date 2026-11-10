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
      '[${brightness.name}] -> StreamScheduleMessageSheet looks fine',
      fileName: 'stream_schedule_message_sheet_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 360),
      builder: () {
        final channel = _channel();
        return _wrapWithMaterialApp(
          StreamScheduleMessageSheet(channel: channel, message: _message()),
          channel: channel,
          brightness: brightness,
        );
      },
    );
  }

  testWidgets('showStreamScheduleMessageSheet offers tomorrow morning and afternoon and Monday morning', (
    tester,
  ) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel());

      expect(_rowLabels(tester), [
        'Tomorrow at 9:00\u202fAM',
        'Tomorrow at 1:00\u202fPM',
        'Monday at 9:00\u202fAM',
        'Custom time',
      ]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet resolves with the tapped preset', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      final results = await _showSheet(tester, _channel());

      await tester.tap(find.text('Tomorrow at 1:00\u202fPM'));
      await tester.pumpAndSettle();

      expect(results, [DateTime(2026, 10, 22, 13)]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet offers the Monday a week later when tomorrow is Monday', (
    tester,
  ) async {
    await withClock(Clock.fixed(DateTime(2026, 10, 25, 10)), () async {
      final results = await _showSheet(tester, _channel());

      await tester.tap(find.text('Monday at 9:00\u202fAM'));
      await tester.pumpAndSettle();

      expect(results, [DateTime(2026, 11, 2, 9)]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet hides presets further ahead than the channel allows', (
    tester,
  ) async {
    final config = ChannelConfig(scheduledMessagesMaxLeadTime: const Duration(days: 1));

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(config: config));

      expect(_rowLabels(tester), ['Tomorrow at 9:00\u202fAM', 'Custom time']);
    });
  });

  testWidgets('showStreamScheduleMessageSheet hides presets sooner than the channel allows', (tester) async {
    final config = ChannelConfig(scheduledMessagesMinLeadTime: const Duration(hours: 24));

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(config: config));

      expect(_rowLabels(tester), ['Tomorrow at 1:00\u202fPM', 'Monday at 9:00\u202fAM', 'Custom time']);
    });
  });

  testWidgets('showStreamScheduleMessageSheet says the limit is reached when the channel holds its limit', (
    tester,
  ) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 2);
    final pending = [_scheduledMessage('a'), _scheduledMessage('b')];

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(config: config, scheduledMessages: pending));

      expect(find.text('Limit reached (2 max)'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleMessageSheet disables every row when the channel holds its limit', (
    tester,
  ) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 2);
    final pending = [_scheduledMessage('a'), _scheduledMessage('b')];

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(config: config, scheduledMessages: pending));

      final tiles = tester.widgetList<StreamListTile>(find.byType(StreamListTile));
      expect(tiles, isNotEmpty);
      expect(tiles.map((it) => it.props.enabled), everyElement(isFalse));
    });
  });

  testWidgets("showStreamScheduleMessageSheet doesn't count failed messages toward the limit", (tester) async {
    final config = ChannelConfig(scheduledMessagesMaxPerChannel: 2);
    final scheduledMessages = [
      _scheduledMessage('a'),
      _scheduledMessage('b', status: ScheduledMessageStatus.failed),
    ];

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(config: config, scheduledMessages: scheduledMessages));

      expect(find.text('Schedule message'), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleMessageSheet opens the custom time sheet on top', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel());

      await tester.tap(find.text('Custom time'));
      await tester.pumpAndSettle();

      expect(find.byType(StreamScheduleTimeSheet), findsOneWidget);
    });
  });

  testWidgets('showStreamScheduleMessageSheet resolves null when dismissed', (tester) async {
    await withClock(Clock.fixed(_wednesday), () async {
      final results = await _showSheet(tester, _channel());

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(results, [null]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet keeps preset hours across a daylight saving change', (tester) async {
    // In zones that observe it, 2026-10-25 is the day clocks go back an hour.
    await withClock(Clock.fixed(DateTime(2026, 10, 24, 10)), () async {
      final results = await _showSheet(tester, _channel());

      await tester.tap(find.text('Tomorrow at 1:00\u202fPM'));
      await tester.pumpAndSettle();

      final scheduledAt = results.single!;
      expect((scheduledAt.day, scheduledAt.hour, scheduledAt.minute), (25, 13, 0));
    });
  });

  testWidgets('showStreamScheduleMessageSheet returns a custom time scheduled with onSchedule', (tester) async {
    final scheduled = <DateTime>[];

    await withClock(Clock.fixed(_wednesday), () async {
      final results = await _showSheet(
        tester,
        _channel(),
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

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(
        tester,
        _channel(),
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

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(tester, _channel(), onSchedule: (scheduledAt) async => scheduled.add(scheduledAt));

      await tester.tap(find.text('Tomorrow at 9:00\u202fAM'));
      await tester.pumpAndSettle();

      expect(scheduled, [DateTime(2026, 10, 22, 9)]);
    });
  });

  testWidgets('showStreamScheduleMessageSheet completes with the error when scheduling a preset fails', (
    tester,
  ) async {
    final errors = <Object>[];

    await withClock(Clock.fixed(_wednesday), () async {
      await _showSheet(
        tester,
        _channel(),
        onSchedule: (_) async => throw const StreamChatError('Boom'),
        onError: errors.add,
      );

      await tester.tap(find.text('Tomorrow at 9:00\u202fAM'));
      await tester.pumpAndSettle();

      expect(errors, [const StreamChatError('Boom')]);
    });
  });
}

// A Wednesday morning in local time.
final _wednesday = DateTime(2026, 10, 21, 10);

const _cid = 'test-chanel-type:test-channel-id';

Message _message() => Message(id: 'message-id', text: 'Heads up: the launch moved to Monday.');

ScheduledMessage _scheduledMessage(
  String id, {
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
}) {
  return ScheduledMessage(
    id: id,
    cid: _cid,
    user: User(id: 'current-user'),
    message: Message(id: id, text: 'Hello'),
    scheduledAt: DateTime(2026, 10, 23, 9),
    status: status,
  );
}

MockChannel _channel({
  ChannelConfig? config,
  List<ScheduledMessage> scheduledMessages = const [],
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel();
  final channelState = MockChannelState();
  final model = ChannelModel(cid: _cid, extraData: const {'name': 'General'});

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user'));
  when(() => clientState.scheduledMessages).thenReturn(scheduledMessages);
  when(() => channel.client).thenReturn(client);
  when(() => channel.config).thenReturn(config ?? ChannelConfig());
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.channelState).thenReturn(ChannelState(channel: model));
  when(() => channelState.members).thenReturn([]);

  return channel;
}

List<String?> _rowLabels(WidgetTester tester) {
  final tiles = tester.widgetList<StreamListTile>(find.byType(StreamListTile));
  return [for (final tile in tiles) (tile.props.title! as Text).data];
}

// Opens the schedule sheet for [channel] and returns the list its result is
// added to once the sheet resolves.
Future<List<DateTime?>> _showSheet(
  WidgetTester tester,
  MockChannel channel, {
  Future<void> Function(DateTime scheduledAt)? onSchedule,
  void Function(Object error)? onError,
}) async {
  final results = <DateTime?>[];
  await tester.pumpWidget(
    _wrapWithMaterialApp(
      Builder(
        builder: (context) => TextButton(
          onPressed: () => showStreamScheduleMessageSheet(
            context,
            channel: channel,
            message: _message(),
            onSchedule: onSchedule,
          ).then(results.add, onError: (Object error) => onError?.call(error)),
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
    // Above the navigator, so the sheets' routes are within it too.
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
