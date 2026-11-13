import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'schedule_message_harness.dart';

void main() {
  testWidgets('StreamScheduledMessagesBanner adds no space around its pill', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();

    final banner = tester.getRect(find.byType(StreamScheduledMessagesBanner));
    final pill = bannerPill(tester);
    expect(pill, banner);
  });

  testWidgets('StreamScheduledMessagesBanner applies its margin around the pill', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(margin: const EdgeInsets.fromLTRB(4, 8, 12, 16)),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();

    final banner = tester.getRect(find.byType(StreamScheduledMessagesBanner));
    final pill = bannerPill(tester);
    expect(pill.left - banner.left, 4);
    expect(pill.top - banner.top, 8);
    expect(banner.right - pill.right, 12);
    expect(banner.bottom - pill.bottom, 16);
  });

  testWidgets('StreamScheduledMessagesBanner takes no space with a margin while it shows nothing', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(margin: const EdgeInsets.all(16)),
        channel: scheduleChannel(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(StreamScheduledMessagesBanner)), Size.zero);
  });

  testWidgets('StreamScheduledMessagesBanner calls onTap when View all is tapped', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onTap: () => taps += 1),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a'), scheduledMessage('b')]),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('View all'));

    expect(taps, 1);
  });

  testWidgets('StreamScheduledMessagesBanner calls onTap when the count is tapped', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onTap: () => taps += 1),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a'), scheduledMessage('b')]),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('2 scheduled messages'));

    expect(taps, 1);
  });

  testWidgets('StreamScheduledMessagesBanner hides View all without onTap', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('View all'), findsNothing);
  });

  testWidgets('StreamScheduledMessagesBanner builds what a registered component builder returns', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(parentId: 'parent'),
        channel: scheduleChannel(),
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
    // Cleaned up in the test, as the handle is checked before teardown runs.
    try {
      await tester.pumpWidget(
        wrapWithMaterialApp(
          StreamScheduledMessagesBanner(onTap: () {}),
          channel: scheduleChannel(scheduledMessages: [scheduledMessage('a'), scheduledMessage('b')]),
        ),
      );
      await tester.pumpAndSettle();

      final banner = find.bySemanticsLabel(RegExp('2 scheduled messages.*View all', dotAll: true));
      expect(
        tester.getSemantics(banner),
        isSemantics(isLiveRegion: true, isButton: true, hasTapAction: true),
      );
    } finally {
      handle.dispose();
    }
  });

  testWidgets('StreamScheduledMessagesBanner is not tappable without onTap', (tester) async {
    final handle = tester.ensureSemantics();
    // Cleaned up in the test, as the handle is checked before teardown runs.
    try {
      await tester.pumpWidget(
        wrapWithMaterialApp(
          StreamScheduledMessagesBanner(),
          channel: scheduleChannel(scheduledMessages: [scheduledMessage('a'), scheduledMessage('b')]),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(find.bySemanticsLabel('2 scheduled messages')),
        isSemantics(isLiveRegion: true, isButton: false, hasTapAction: false),
      );
    } finally {
      handle.dispose();
    }
  });

  test('StreamScheduledMessagesBannerProps.copyWith replaces parentId', () {
    const props = StreamScheduledMessagesBannerProps(parentId: 'parent');

    expect(props.copyWith(parentId: 'other').parentId, 'other');
  });

  test('StreamScheduledMessagesBannerProps.copyWith keeps onTap', () {
    void onTap() {}
    final props = StreamScheduledMessagesBannerProps(onTap: onTap);

    expect(props.copyWith(parentId: 'other').onTap, onTap);
  });

  testWidgets("StreamScheduledMessagesBanner doesn't rebuild when a change leaves its counts as they are", (
    tester,
  ) async {
    final next = scheduledMessage('a');
    final later = scheduledMessage('b');
    final updates = StreamController<List<ScheduledMessage>>();
    addTearDown(updates.close);
    final channel = scheduleChannel(scheduledMessages: [next, later], scheduledMessagesStream: updates.stream);

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();
    final countBefore = tester.widget<Text>(find.text('2 scheduled messages'));

    updates.add([next, later.copyWith(scheduledAt: DateTime(2026, 10, 24, 9))]);
    await tester.pumpAndSettle();

    // A rebuild would create a new Text.
    expect(tester.widget<Text>(find.text('2 scheduled messages')), same(countBefore));
  });

  testWidgets('StreamScheduledMessagesBanner updates its count when a message is scheduled', (tester) async {
    final scheduled = scheduledMessage('a');
    final updates = StreamController<List<ScheduledMessage>>();
    addTearDown(updates.close);
    final channel = scheduleChannel(scheduledMessages: [scheduled], scheduledMessagesStream: updates.stream);

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();

    updates.add([scheduled, scheduledMessage('b')]);
    await tester.pumpAndSettle();

    expect(find.text('2 scheduled messages'), findsOneWidget);
  });
}
