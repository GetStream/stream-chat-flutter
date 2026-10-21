import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('FloatingDateDivider shows the day of the message at the top of a reversed list', (tester) async {
    final messages = _messagesOnConsecutiveDays(3);

    await _pumpDivider(
      tester,
      messages: messages,
      positions: [
        _reversedItem(0, top: 0.5, bottom: 1),
        _reversedItem(1, top: -0.1, bottom: 0.5),
      ],
    );

    expect(_shownDate(tester), DateTime(2026, 10, 2));
  });

  testWidgets('FloatingDateDivider shows the day of the message at the top of a list in reading order', (
    tester,
  ) async {
    final messages = _messagesOnConsecutiveDays(3);

    await _pumpDivider(
      tester,
      reverse: false,
      messages: messages,
      positions: const [
        ItemPosition(index: 0, itemLeadingEdge: -0.1, itemTrailingEdge: 0.5),
        ItemPosition(index: 1, itemLeadingEdge: 0.5, itemTrailingEdge: 1),
      ],
    );

    expect(_shownDate(tester), DateTime(2026, 10, 3));
  });

  testWidgets('FloatingDateDivider shows the day of a message taller than the viewport', (tester) async {
    final messages = _messagesOnConsecutiveDays(3);

    await _pumpDivider(
      tester,
      messages: messages,
      positions: [_reversedItem(1, top: -0.5, bottom: 1.5)],
    );

    expect(_shownDate(tester), DateTime(2026, 10, 2));
  });

  testWidgets('FloatingDateDivider skips items with no extent when finding the top message', (tester) async {
    final messages = _messagesOnConsecutiveDays(3);

    await _pumpDivider(
      tester,
      messages: messages,
      positions: [
        _reversedItem(0, top: 0.5, bottom: 1),
        _reversedItem(1, top: 0, bottom: 0.5),
        _reversedItem(2, top: 0, bottom: 0),
      ],
    );

    expect(_shownDate(tester), DateTime(2026, 10, 2));
  });

  testWidgets('FloatingDateDivider shows the divider from a custom builder', (tester) async {
    await _pumpDivider(
      tester,
      messages: _messagesOnConsecutiveDays(3),
      positions: [_reversedItem(1, top: 0, bottom: 1)],
      dateDividerBuilder: (date) => const Text('custom'),
    );

    expect(find.text('custom'), findsOneWidget);
  });

  testWidgets('FloatingDateDivider passes the day of the top message to a custom builder', (tester) async {
    final messages = _messagesOnConsecutiveDays(3);
    DateTime? builtDate;

    await _pumpDivider(
      tester,
      messages: messages,
      positions: [_reversedItem(1, top: 0, bottom: 1)],
      dateDividerBuilder: (date) {
        builtDate = date;
        return const Text('custom');
      },
    );

    expect(builtDate, DateTime(2026, 10, 2));
  });

  testWidgets('FloatingDateDivider is hidden before any item is laid out', (tester) async {
    await _pumpDivider(tester, messages: _messagesOnConsecutiveDays(3), positions: const []);

    expect(find.byType(StreamDateDivider), findsNothing);
  });

  testWidgets('FloatingDateDivider is hidden when every laid-out item has no extent', (tester) async {
    await _pumpDivider(
      tester,
      messages: _messagesOnConsecutiveDays(3),
      positions: [
        _reversedItem(0, top: 0.5, bottom: 0.5),
        _reversedItem(1, top: 0.2, bottom: 0.2),
      ],
    );

    expect(find.byType(StreamDateDivider), findsNothing);
  });

  testWidgets('FloatingDateDivider is hidden when the item at the top is not a message', (tester) async {
    await _pumpDivider(
      tester,
      messages: _messagesOnConsecutiveDays(3),
      positions: [_reversedItem(3, top: 0, bottom: 1)],
    );

    expect(find.byType(StreamDateDivider), findsNothing);
  });
}

// [count] messages, newest first, one per day.
//
// They are sent at noon on the first [count] days of October 2026.
List<Message> _messagesOnConsecutiveDays(int count) => [
  for (var day = count; day > 0; day -= 1)
    Message(
      id: 'm$day',
      createdAt: DateTime(2026, 10, day, 12),
      user: User(id: 'u$day'),
    ),
];

// The position of the item at [index] in a reversed list.
//
// [top] and [bottom] are fractions of the viewport, measured down from its top.
ItemPosition _reversedItem(int index, {required double top, required double bottom}) {
  return ItemPosition(index: index, itemLeadingEdge: 1.0 - bottom, itemTrailingEdge: 1.0 - top);
}

DateTime _shownDate(WidgetTester tester) => tester.widget<StreamDateDivider>(find.byType(StreamDateDivider)).dateTime;

Future<void> _pumpDivider(
  WidgetTester tester, {
  required List<Message> messages,
  required List<ItemPosition> positions,
  bool reverse = true,
  Widget Function(DateTime)? dateDividerBuilder,
}) async {
  final itemPositions = ValueNotifier<Iterable<ItemPosition>>(positions);
  addTearDown(itemPositions.dispose);

  await tester.pumpWidget(
    MaterialApp(
      home: StreamChatTheme(
        data: StreamChatThemeData(),
        child: Scaffold(
          body: FloatingDateDivider(
            itemPositionListener: itemPositions,
            reverse: reverse,
            messageAt: _itemsOf(messages),
            dateDividerBuilder: dateDividerBuilder,
          ),
        ),
      ),
    ),
  );
}

// A lookup that shows [messages] as list items 0 to `messages.length - 1`.
Message? Function(int index) _itemsOf(List<Message> messages) {
  return (index) {
    if (index < 0) return null;
    if (index >= messages.length) return null;
    return messages[index];
  };
}
