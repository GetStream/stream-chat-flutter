import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'scheduled_message_list_item_harness.dart';

void main() {
  testWidgets('StreamScheduledMessageListItem merges into one accessible node with the spelled-out scheduled time', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();

    await tester.pumpWidget(
      wrapWithMaterialApp(StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage())),
    );

    expect(
      find.bySemanticsLabel(
        RegExp('Scheduled for Wednesday, October 21, 2026, 8:00 AM.*General.*venue shortlist', dotAll: true),
      ),
      findsOneWidget,
    );
    handle.dispose();
  });

  testWidgets('StreamScheduledMessageListItem truncates instead of overflowing on a narrow width', (tester) async {
    final item = StreamScheduledMessageListItem(scheduledMessage: failed());

    await tester.pumpWidget(wrapWithMaterialApp(SizedBox(width: 240, child: item)));

    expect(tester.takeException(), isNull);
  });

  testWidgets('StreamScheduledMessageListItem truncates a long quoted author instead of overflowing', (tester) async {
    final quoted = Message(
      id: 'quoted',
      text: 'Ready?',
      user: User(id: 'alex', name: 'Alexandra Montgomery-Fitzwilliam the Third'),
    );
    final item = StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage(quotedMessage: quoted));

    await tester.pumpWidget(wrapWithMaterialApp(SizedBox(width: 240, child: item)));

    expect(tester.takeException(), isNull);
  });

  testWidgets('StreamScheduledMessageListItem builds what a registered component builder returns', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterialApp(
        StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage()),
        componentBuilders: StreamComponentBuilders(
          extensions: streamChatComponentBuilders(
            scheduledMessageListItem: (_, props) => Text('custom ${props.scheduledMessage.id}'),
          ),
        ),
      ),
    );

    expect(find.text('custom scheduled-id'), findsOneWidget);
  });

  test('StreamScheduledMessageListItemProps.copyWith replaces selected', () {
    final item = StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage());

    final copy = item.props.copyWith(selected: true);

    expect(copy.selected, isTrue);
  });

  test('StreamScheduledMessageListItemProps.copyWith keeps the scheduled message', () {
    final item = StreamScheduledMessageListItem(scheduledMessage: fakeScheduledMessage());

    final copy = item.props.copyWith(selected: true);

    expect(copy.scheduledMessage, item.props.scheduledMessage);
  });
}
