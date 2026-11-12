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
    final pill = tester.getRect(
      find.descendant(of: find.byType(StreamScheduledMessagesBanner), matching: find.byType(DecoratedBox)).first,
    );
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
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(margin: const EdgeInsets.all(16)),
        channel: scheduleChannel(),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.getSize(find.byType(StreamScheduledMessagesBanner)), Size.zero);
  });

  testWidgets('StreamScheduledMessagesBanner calls onViewAllPressed when View all is tapped', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onViewAllPressed: () => taps += 1),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('View all'));

    expect(taps, 1);
  });

  testWidgets('StreamScheduledMessagesBanner calls onViewAllPressed when the count is tapped', (tester) async {
    var taps = 0;

    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onViewAllPressed: () => taps += 1),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a')]),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('1 scheduled message'));

    expect(taps, 1);
  });

  testWidgets('StreamScheduledMessagesBanner hides View all without onViewAllPressed', (tester) async {
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

    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(onViewAllPressed: () {}),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a')]),
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
      wrapWithMaterialApp(
        StreamScheduledMessagesBanner(),
        channel: scheduleChannel(scheduledMessages: [scheduledMessage('a')]),
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

  testWidgets("StreamScheduledMessagesBanner doesn't rebuild when a change leaves its counts as they are", (
    tester,
  ) async {
    final scheduled = scheduledMessage('a');
    final updates = StreamController<List<ScheduledMessage>>();
    addTearDown(updates.close);
    final channel = scheduleChannel(scheduledMessages: [scheduled], scheduledMessagesStream: updates.stream);

    await tester.pumpWidget(wrapWithMaterialApp(StreamScheduledMessagesBanner(), channel: channel));
    await tester.pumpAndSettle();
    final countBefore = tester.widget<Text>(find.text('1 scheduled message'));

    updates.add([scheduled.copyWith(scheduledAt: DateTime(2026, 10, 24, 9))]);
    await tester.pumpAndSettle();

    // A rebuild would create a new Text.
    expect(tester.widget<Text>(find.text('1 scheduled message')), same(countBefore));
  });
}
