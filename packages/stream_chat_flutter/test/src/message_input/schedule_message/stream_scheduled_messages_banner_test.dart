import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../../mocks.dart';

void main() {
  for (final brightness in Brightness.values) {
    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessagesBanner looks fine',
      fileName: 'stream_scheduled_messages_banner_scheduled_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 80),
      builder: () => _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onViewAllPressed: () {}),
        channel: _channel(scheduledMessages: [_scheduledMessage('a'), _scheduledMessage('b')]),
        brightness: brightness,
      ),
    );

    goldenTest(
      '[${brightness.name}] -> StreamScheduledMessagesBanner with failed messages looks fine',
      fileName: 'stream_scheduled_messages_banner_failed_${brightness.name}',
      constraints: const BoxConstraints.tightFor(width: 412, height: 80),
      builder: () => _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onViewAllPressed: () {}),
        channel: _channel(scheduledMessages: [_scheduledMessage('a', status: ScheduledMessageStatus.failed)]),
        brightness: brightness,
      ),
    );
  }

  testWidgets('StreamScheduledMessagesBanner is empty without scheduled messages', (tester) async {
    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: _channel()));
    await tester.pumpAndSettle();

    expect(find.byType(Text), findsNothing);
  });

  testWidgets("StreamScheduledMessagesBanner counts the channel's scheduled messages", (tester) async {
    final channel = _channel(
      scheduledMessages: [_scheduledMessage('a'), _scheduledMessage('b')],
    );

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.text('2 scheduled messages'), findsOneWidget);
  });

  testWidgets("StreamScheduledMessagesBanner counts a thread's scheduled replies", (tester) async {
    final channel = _channel(
      scheduledMessages: [_scheduledMessage('a'), _scheduledMessage('b')],
      threadReplies: [_scheduledMessage('reply', parentId: 'parent')],
    );

    await tester.pumpWidget(
      _wrapWithMaterialApp(StreamScheduledMessagesBanner(parentId: 'parent'), channel: channel),
    );
    await tester.pumpAndSettle();

    expect(find.text('1 scheduled reply'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessagesBanner shows the failed count instead of the scheduled count', (tester) async {
    final channel = _channel(
      scheduledMessages: [
        _scheduledMessage('a'),
        _scheduledMessage('b', status: ScheduledMessageStatus.failed),
      ],
    );

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.text('1 failed to send'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessagesBanner shows the count out of the limit once the channel reaches it', (
    tester,
  ) async {
    final scheduledMessages = [_scheduledMessage('a'), _scheduledMessage('b')];
    final channel = _channel(
      config: ChannelConfig(scheduledMessagesMaxPerChannel: 2),
      scheduledMessages: scheduledMessages,
      clientScheduledMessages: scheduledMessages,
    );

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.text('2 of 2 scheduled messages'), findsOneWidget);
  });

  testWidgets("StreamScheduledMessagesBanner hides pending ones when the channel can't schedule", (tester) async {
    final channel = _channel(
      canSchedule: false,
      scheduledMessages: [_scheduledMessage('a')],
    );

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.byType(Text), findsNothing);
  });

  testWidgets("StreamScheduledMessagesBanner shows failed ones when the channel can't schedule", (tester) async {
    final channel = _channel(
      canSchedule: false,
      scheduledMessages: [_scheduledMessage('a', status: ScheduledMessageStatus.failed)],
    );

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.text('1 failed to send'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessagesBanner adds no space around its pill', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(),
        channel: _channel(scheduledMessages: [_scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();

    final banner = tester.getRect(find.byType(StreamScheduledMessagesBanner));
    final pill = tester.getRect(
      find.descendant(of: find.byType(StreamScheduledMessagesBanner), matching: find.byType(DecoratedBox)).first,
    );
    expect(pill, banner);
  });

  testWidgets('StreamScheduledMessagesBanner applies its margin around the pill', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(margin: const EdgeInsets.fromLTRB(4, 8, 12, 16)),
        channel: _channel(scheduledMessages: [_scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();

    final banner = tester.getRect(find.byType(StreamScheduledMessagesBanner));
    final pill = tester.getRect(
      find.descendant(of: find.byType(StreamScheduledMessagesBanner), matching: find.byType(DecoratedBox)).first,
    );
    expect(pill.left - banner.left, 4);
    expect(pill.top - banner.top, 8);
    expect(banner.right - pill.right, 12);
    expect(banner.bottom - pill.bottom, 16);
  });

  testWidgets('StreamScheduledMessagesBanner takes no space with a margin while it shows nothing', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(margin: const EdgeInsets.all(16)),
        channel: _channel(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(StreamScheduledMessagesBanner)), Size.zero);
  });

  testWidgets('StreamScheduledMessagesBanner calls onViewAllPressed when View all is tapped', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onViewAllPressed: () => taps += 1),
        channel: _channel(scheduledMessages: [_scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('View all'));

    expect(taps, 1);
  });

  testWidgets('StreamScheduledMessagesBanner counts thread replies toward the limit', (tester) async {
    final topLevel = [for (var i = 0; i < 8; i++) _scheduledMessage('m$i')];
    final replies = [
      _scheduledMessage('r0', parentId: 'parent'),
      _scheduledMessage('r1', parentId: 'parent'),
    ];
    final channel = _channel(
      config: ChannelConfig(scheduledMessagesMaxPerChannel: 10),
      scheduledMessages: topLevel,
      threadReplies: replies,
      clientScheduledMessages: [...topLevel, ...replies],
    );

    await tester.pumpWidget(_wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    expect(find.text('10 of 10 scheduled messages'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessagesBanner calls onViewAllPressed when the count is tapped', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onViewAllPressed: () => taps += 1),
        channel: _channel(scheduledMessages: [_scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('1 scheduled message'));

    expect(taps, 1);
  });

  testWidgets('StreamScheduledMessagesBanner hides View all without onViewAllPressed', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(),
        channel: _channel(scheduledMessages: [_scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('View all'), findsNothing);
  });

  testWidgets('StreamScheduledMessagesBanner builds what a registered component builder returns', (tester) async {
    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(parentId: 'parent'),
        channel: _channel(),
        componentBuilders: StreamComponentBuilders(
          extensions: streamChatComponentBuilders(
            scheduledMessagesBanner: (_, props) => Text('custom ${props.parentId}'),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('custom parent'), findsOneWidget);
  });

  testWidgets('StreamScheduledMessagesBanner announces the count as one tappable live region', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onViewAllPressed: () {}),
        channel: _channel(scheduledMessages: [_scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();

    final banner = find.bySemanticsLabel(RegExp('1 scheduled message.*View all', dotAll: true));
    expect(
      tester.getSemantics(banner),
      isSemantics(isLiveRegion: true, isButton: true, hasTapAction: true),
    );
    handle.dispose();
  });

  testWidgets('StreamScheduledMessagesBanner is not tappable without onViewAllPressed', (tester) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      _wrapWithMaterialApp(
        StreamScheduledMessagesBanner(),
        channel: _channel(scheduledMessages: [_scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSemantics(find.bySemanticsLabel('1 scheduled message')),
      isSemantics(isLiveRegion: true, isButton: false, hasTapAction: false),
    );
    handle.dispose();
  });

  test('StreamScheduledMessagesBannerProps.copyWith replaces parentId', () {
    const props = StreamScheduledMessagesBannerProps(parentId: 'parent');

    expect(props.copyWith(parentId: 'other').parentId, 'other');
  });

  test('StreamScheduledMessagesBannerProps.copyWith keeps onViewAllPressed', () {
    void onViewAllPressed() {}
    final props = StreamScheduledMessagesBannerProps(onViewAllPressed: onViewAllPressed);

    expect(props.copyWith(parentId: 'other').onViewAllPressed, onViewAllPressed);
  });
}

const _cid = 'test-chanel-type:test-channel-id';

ScheduledMessage _scheduledMessage(
  String id, {
  ScheduledMessageStatus status = ScheduledMessageStatus.scheduled,
  String? parentId,
}) {
  return ScheduledMessage(
    id: id,
    cid: _cid,
    user: User(id: 'current-user'),
    message: Message(id: id, text: 'Hello', parentId: parentId),
    scheduledAt: DateTime(2026, 10, 23, 9),
    status: status,
  );
}

MockChannel _channel({
  bool canSchedule = true,
  ChannelConfig? config,
  List<ScheduledMessage> scheduledMessages = const [],
  List<ScheduledMessage> threadReplies = const [],
  List<ScheduledMessage> clientScheduledMessages = const [],
}) {
  final client = MockClient();
  final clientState = MockClientState();
  final channel = MockChannel(
    ownCapabilities: [
      ChannelCapability.sendMessage,
      if (canSchedule) ChannelCapability.scheduleMessage,
    ],
  );
  final channelState = MockChannelState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user'));
  when(() => clientState.scheduledMessages).thenReturn(clientScheduledMessages);
  when(() => clientState.scheduledMessagesStream).thenAnswer((_) => Stream.value(clientScheduledMessages));
  when(() => channel.client).thenReturn(client);
  when(() => channel.config).thenReturn(config ?? ChannelConfig());
  when(() => channel.state).thenReturn(channelState);
  when(() => channelState.scheduledMessages).thenReturn(scheduledMessages);
  when(() => channelState.scheduledMessagesStream).thenAnswer((_) => Stream.value(scheduledMessages));
  when(() => channelState.scheduledThreadReplies('parent')).thenReturn(threadReplies);
  when(() => channelState.scheduledThreadRepliesStream('parent')).thenAnswer((_) => Stream.value(threadReplies));

  return channel;
}

Widget _wrapWithMaterialApp(
  Widget widget, {
  required MockChannel channel,
  Brightness brightness = Brightness.light,
  StreamComponentBuilders? componentBuilders,
}) {
  return MaterialApp(
    theme: ThemeData(brightness: brightness),
    home: StreamChat(
      client: channel.client,
      componentBuilders: componentBuilders,
      connectivityStream: Stream.value([ConnectivityResult.wifi]),
      child: StreamChannel(
        channel: channel,
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: context.streamColorScheme.backgroundApp,
            body: Center(
              child: Padding(padding: const EdgeInsets.all(16), child: widget),
            ),
          ),
        ),
      ),
    ),
  );
}
