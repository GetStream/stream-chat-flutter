import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

// The fraction of the viewport over which the divider fades out.
//
// It matches the extent [FloatingDateDivider] fades over.
const _fadeExtent = 0.05;

void main() {
  testWidgets('FloatingDateDivider is opaque when the top message shares its day with both neighbors', (tester) async {
    await _pumpDivider(
      tester,
      messages: _messagesOnDays([16, 16, 16]),
      positions: [_reversedItem(1, top: 0.02, bottom: 0.03)],
    );

    expect(_shownOpacity(tester), 1.0);
  });

  testWidgets('FloatingDateDivider fades as the date divider above the first message of a day comes down', (
    tester,
  ) async {
    await _pumpDivider(
      tester,
      messages: _messagesOnDays([16, 16, 15]),
      positions: [_reversedItem(1, top: _fadeExtent / 2, bottom: 0.5)],
    );

    expect(_shownOpacity(tester), closeTo(0.5, 1e-9));
  });

  testWidgets('FloatingDateDivider is hidden once the date divider above the top message is in view', (tester) async {
    await _pumpDivider(
      tester,
      messages: _messagesOnDays([16, 16, 15]),
      positions: [_reversedItem(1, top: _fadeExtent, bottom: 0.5)],
    );

    expect(find.byType(StreamDateDivider), findsNothing);
  });

  testWidgets('FloatingDateDivider fades as the date divider for the next day nears the top', (tester) async {
    await _pumpDivider(
      tester,
      messages: _messagesOnDays([17, 16, 16]),
      positions: [_reversedItem(1, top: -0.5, bottom: _fadeExtent * 1.5)],
    );

    expect(_shownOpacity(tester), closeTo(0.5, 1e-9));
  });

  testWidgets('FloatingDateDivider fades above the oldest message of a reversed list', (tester) async {
    await _pumpDivider(
      tester,
      messages: _messagesOnDays([16, 16, 16]),
      positions: [_reversedItem(2, top: _fadeExtent / 2, bottom: 0.5)],
    );

    expect(_shownOpacity(tester), closeTo(0.5, 1e-9));
  });

  testWidgets('FloatingDateDivider updates its opacity as the top message moves', (tester) async {
    final positions = await _pumpDivider(
      tester,
      messages: _messagesOnDays([16, 16, 15]),
      positions: [_reversedItem(1, top: _fadeExtent / 4, bottom: 0.5)],
    );

    positions.value = [_reversedItem(1, top: _fadeExtent / 2, bottom: 0.5)];
    await tester.pump();

    expect(_shownOpacity(tester), closeTo(0.5, 1e-9));
  });

  testWidgets('FloatingDateDivider stays opaque near an inline date divider when fading is off', (tester) async {
    await _pumpDivider(
      tester,
      fadeNearInlineDivider: false,
      messages: _messagesOnDays([16, 16, 15]),
      positions: [_reversedItem(1, top: _fadeExtent, bottom: 0.5)],
    );

    expect(_shownOpacity(tester), 1.0);
  });
}

// Messages, newest first, sent at noon on each of [days] of October 2026.
List<Message> _messagesOnDays(List<int> days) => [
  for (final (index, day) in days.indexed)
    Message(
      id: 'm$index',
      createdAt: DateTime(2026, 10, day, 12),
      user: User(id: 'u$index'),
    ),
];

// The position of the item at [index] in a reversed list.
//
// [top] and [bottom] are fractions of the viewport, measured down from its top.
ItemPosition _reversedItem(int index, {required double top, required double bottom}) {
  return ItemPosition(index: index, itemLeadingEdge: 1.0 - bottom, itemTrailingEdge: 1.0 - top);
}

double _shownOpacity(WidgetTester tester) {
  final opacity = find.ancestor(of: find.byType(StreamDateDivider), matching: find.byType(Opacity));
  return tester.widget<Opacity>(opacity.first).opacity;
}

// Pumps a reversed [FloatingDateDivider] laid out at [positions].
//
// Returns the positions it listens to.
Future<ValueNotifier<Iterable<ItemPosition>>> _pumpDivider(
  WidgetTester tester, {
  required List<Message> messages,
  required List<ItemPosition> positions,
  bool fadeNearInlineDivider = true,
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
            reverse: true,
            fadeNearInlineDivider: fadeNearInlineDivider,
            messageAt: _itemsOf(messages),
          ),
        ),
      ),
    ),
  );
  return itemPositions;
}

// A lookup that shows [messages] as list items 0 to `messages.length - 1`.
Message? Function(int index) _itemsOf(List<Message> messages) {
  return (index) {
    if (index < 0) return null;
    if (index >= messages.length) return null;
    return messages[index];
  };
}
