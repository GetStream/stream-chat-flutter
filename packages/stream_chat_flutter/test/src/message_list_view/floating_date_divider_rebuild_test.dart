import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets(
    'FloatingDateDivider does not schedule a frame when a new message pushes a message of the same day to the top',
    (tester) async {
      final messages = _messagesSentMinutesApart(4);
      final positions = _positions([_reversedItem(2, top: -0.1, bottom: 0.4)]);
      final builder = _recordingBuilder([]);
      await tester.pumpWidget(_divider(messages: messages, positions: positions, builder: builder));
      await tester.pumpWidget(_divider(messages: [_newMessage(), ...messages], positions: positions, builder: builder));

      // Rows differ in height, so once the new message is laid out another
      // message of the same day is at the top.
      positions.value = [_reversedItem(3, top: -0.1, bottom: 0.4)];

      expect(tester.binding.hasScheduledFrame, isFalse);
    },
  );

  testWidgets('FloatingDateDivider rebuilds when a message of another day reaches the top', (tester) async {
    final messages = [
      Message(
        id: 'today',
        createdAt: DateTime(2026, 10, 16, 15),
        user: User(id: 'u'),
      ),
      Message(
        id: 'yesterday',
        createdAt: DateTime(2026, 10, 15, 15),
        user: User(id: 'u'),
      ),
    ];
    final positions = _positions([_reversedItem(0, top: -0.1, bottom: 0.9)]);
    final builtDates = <DateTime>[];
    await tester.pumpWidget(_divider(messages: messages, positions: positions, builder: _recordingBuilder(builtDates)));

    positions.value = [_reversedItem(1, top: -0.1, bottom: 0.4)];
    await tester.pump();

    expect(builtDates, [DateTime(2026, 10, 16), DateTime(2026, 10, 15)]);
  });

  testWidgets('FloatingDateDivider follows a positions source that replaced the previous one', (tester) async {
    final messages = [
      Message(
        id: 'today',
        createdAt: DateTime(2026, 10, 16, 15),
        user: User(id: 'u'),
      ),
      Message(
        id: 'yesterday',
        createdAt: DateTime(2026, 10, 15, 15),
        user: User(id: 'u'),
      ),
    ];
    final oldPositions = _positions([_reversedItem(0, top: -0.1, bottom: 0.9)]);
    final newPositions = _positions([_reversedItem(0, top: -0.1, bottom: 0.9)]);
    Widget builder(DateTime date) => Text('$date');
    await tester.pumpWidget(_divider(messages: messages, positions: oldPositions, builder: builder));
    await tester.pumpWidget(_divider(messages: messages, positions: newPositions, builder: builder));

    newPositions.value = [_reversedItem(1, top: -0.1, bottom: 0.4)];
    await tester.pump();

    expect(find.text('${DateTime(2026, 10, 15)}'), findsOneWidget);
  });

  testWidgets('FloatingDateDivider shows the divider from a builder that replaced the previous one', (tester) async {
    final messages = _messagesSentMinutesApart(2);
    final positions = _positions([_reversedItem(0, top: -0.1, bottom: 0.9)]);
    await tester.pumpWidget(_divider(messages: messages, positions: positions, builder: (date) => const Text('first')));

    await tester.pumpWidget(
      _divider(messages: messages, positions: positions, builder: (date) => const Text('replaced')),
    );

    expect(find.text('replaced'), findsOneWidget);
  });
}

// [count] messages, newest first, sent a minute apart on one day.
List<Message> _messagesSentMinutesApart(int count) => [
  for (var minute = count; minute > 0; minute -= 1)
    Message(
      id: 'm$minute',
      createdAt: DateTime(2026, 10, 16, 15, minute),
      user: User(id: 'u$minute'),
    ),
];

// A message sent after every one from [_messagesSentMinutesApart].
//
// It is sent on the same day.
Message _newMessage() {
  return Message(
    id: 'new',
    createdAt: DateTime(2026, 10, 16, 15, 59),
    user: User(id: 'u'),
  );
}

// The position of the item at [index] in a reversed list.
//
// [top] and [bottom] are fractions of the viewport, measured down from its top.
ItemPosition _reversedItem(int index, {required double top, required double bottom}) {
  return ItemPosition(index: index, itemLeadingEdge: 1.0 - bottom, itemTrailingEdge: 1.0 - top);
}

ValueNotifier<Iterable<ItemPosition>> _positions(List<ItemPosition> positions) {
  final notifier = ValueNotifier<Iterable<ItemPosition>>(positions);
  addTearDown(notifier.dispose);
  return notifier;
}

// A reversed [FloatingDateDivider] that builds its date widget with [builder].
Widget _divider({
  required List<Message> messages,
  required ValueNotifier<Iterable<ItemPosition>> positions,
  required Widget Function(DateTime) builder,
}) {
  return MaterialApp(
    home: StreamChatTheme(
      data: StreamChatThemeData(),
      child: Scaffold(
        body: FloatingDateDivider(
          itemPositionListener: positions,
          reverse: true,
          messageAt: _itemsOf(messages),
          dateDividerBuilder: builder,
        ),
      ),
    ),
  );
}

// A divider builder that records in [builtDates] each date it builds for.
Widget Function(DateTime) _recordingBuilder(List<DateTime> builtDates) {
  return (date) {
    builtDates.add(date);
    return Text('$date');
  };
}

// A lookup that shows [messages] as list items 0 to `messages.length - 1`.
Message? Function(int index) _itemsOf(List<Message> messages) {
  return (index) {
    if (index < 0) return null;
    if (index >= messages.length) return null;
    return messages[index];
  };
}
