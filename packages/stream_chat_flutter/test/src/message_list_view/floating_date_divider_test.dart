import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/src/misc/empty_widget.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  final itemPositionListener = ValueNotifier<Iterable<ItemPosition>>([]);

  const itemCount = 7;
  final messages = List<Message>.generate(
    5,
    (i) => Message(
      id: 'm$i',
      text: 'Message $i',
      createdAt: DateTime(2023, 1, i + 1, 10, 30),
      user: User(id: 'user$i'),
    ),
  );

  Widget buildTestWidget(Widget child) {
    return MaterialApp(
      home: StreamChatTheme(
        data: StreamChatThemeData.light(),
        child: Scaffold(body: child),
      ),
    );
  }

  group('Empty states', () {
    testWidgets('renders Empty when no positions or messages', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          FloatingDateDivider(
            itemPositionListener: itemPositionListener, // empty
            reverse: false,
            messages: const [], // empty
            itemCount: itemCount,
          ),
        ),
      );
      expect(find.byType(Empty), findsOneWidget);
      expect(find.byType(StreamDateDivider), findsNothing);
    });

    testWidgets(
      'renders Empty when message at calculated index is null',
      (tester) async {
        itemPositionListener.value = [
          const ItemPosition(
            index: 3,
            itemLeadingEdge: 0,
            itemTrailingEdge: 1,
          ),
        ];
        await tester.pumpWidget(
          buildTestWidget(
            FloatingDateDivider(
              itemPositionListener: itemPositionListener,
              reverse: false,
              messages: [messages[0]], // Only one message, but index-2=1
              // needs messages[1] which doesn't exist
              itemCount: itemCount,
            ),
          ),
        );
        expect(find.byType(Empty), findsOneWidget);
      },
    );

    testWidgets('renders Empty for all special indices', (tester) async {
      final specialIndices = [
        0,
        1,
        itemCount - 3,
        itemCount - 2,
        itemCount - 1,
      ];

      for (final idx in specialIndices) {
        itemPositionListener.value = [
          ItemPosition(
            index: idx,
            itemLeadingEdge: 0,
            itemTrailingEdge: 1,
          ),
        ];
        await tester.pumpWidget(
          buildTestWidget(
            FloatingDateDivider(
              itemPositionListener: itemPositionListener,
              reverse: false,
              messages: messages,
              itemCount: itemCount,
            ),
          ),
        );
        expect(
          find.byType(Empty),
          findsOneWidget,
          reason: 'Special index $idx should render Empty',
        );
      }
    });
  });

  group('Valid message rendering', () {
    testWidgets(
      'renders StreamDateDivider for valid message index',
      (tester) async {
        itemPositionListener.value = [
          const ItemPosition(
            index: 3,
            itemLeadingEdge: 0,
            itemTrailingEdge: 1,
          ),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            FloatingDateDivider(
              itemPositionListener: itemPositionListener,
              reverse: false,
              messages: messages,
              itemCount: itemCount,
            ),
          ),
        );

        expect(find.byType(StreamDateDivider), findsOneWidget);

        // Verify the correct date is used
        // (index 3 -> message index 1 -> messages[1])
        final dateDivider = tester.widget<StreamDateDivider>(
          find.byType(StreamDateDivider),
        );
        expect(dateDivider.dateTime, equals(messages[1].createdAt.toLocal()));
      },
    );

    testWidgets(
      'renders custom dateDividerBuilder when provided',
      (tester) async {
        itemPositionListener.value = [
          const ItemPosition(
            index: 3,
            itemLeadingEdge: 0,
            itemTrailingEdge: 1,
          ),
        ];

        const customKey = Key('custom_divider');
        DateTime? receivedDate;

        await tester.pumpWidget(
          buildTestWidget(
            FloatingDateDivider(
              itemPositionListener: itemPositionListener,
              reverse: false,
              messages: messages,
              itemCount: itemCount,
              floatingDateDividerBuilder: (date) {
                receivedDate = date;
                return Container(
                  key: customKey,
                  child: Text('Custom: ${date.day}'),
                );
              },
            ),
          ),
        );

        expect(find.byKey(customKey), findsOneWidget);
        expect(find.byType(StreamDateDivider), findsNothing);
        // Verify correct date is passed to custom builder
        expect(receivedDate, equals(messages[1].createdAt.toLocal()));
      },
    );
  });

  group('Reverse mode and boundaries', () {
    testWidgets('works correctly in both reverse modes', (tester) async {
      itemPositionListener.value = [
        const ItemPosition(
          index: 2,
          itemLeadingEdge: 0,
          itemTrailingEdge: 1,
        ),
        const ItemPosition(
          index: 3,
          itemLeadingEdge: 1,
          itemTrailingEdge: 2,
        ),
      ];

      // Test reverse = false
      await tester.pumpWidget(
        buildTestWidget(
          FloatingDateDivider(
            itemPositionListener: itemPositionListener,
            reverse: false,
            messages: messages,
            itemCount: itemCount,
          ),
        ),
      );
      expect(find.byType(StreamDateDivider), findsOneWidget);

      // Test reverse = true
      await tester.pumpWidget(
        buildTestWidget(
          FloatingDateDivider(
            itemPositionListener: itemPositionListener,
            reverse: true,
            messages: messages,
            itemCount: itemCount,
          ),
        ),
      );
      expect(find.byType(StreamDateDivider), findsOneWidget);
    });

    testWidgets('handles boundary message indices correctly', (tester) async {
      // Test with index 2 (the lowest valid message index)
      itemPositionListener.value = [
        const ItemPosition(
          index: 2,
          itemLeadingEdge: 0,
          itemTrailingEdge: 1,
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(
          FloatingDateDivider(
            itemPositionListener: itemPositionListener,
            reverse: false,
            messages: messages,
            itemCount: itemCount,
          ),
        ),
      );

      expect(find.byType(StreamDateDivider), findsOneWidget);

      // Verify it uses the correct message
      // (index 2 -> message index 0 -> messages[0])
      final dateDivider = tester.widget<StreamDateDivider>(
        find.byType(StreamDateDivider),
      );
      expect(dateDivider.dateTime, equals(messages[0].createdAt.toLocal()));
    });
  });

  group('Bug fixes', () {
    testWidgets(
      'shows correct date when message exceeds viewport size',
      (tester) async {
        // Bug fix: FloatingDateDivider not showing correct date when latest
        // message is too big and exceeds viewport main axis size
        itemPositionListener.value = [
          const ItemPosition(
            index: 3,
            itemLeadingEdge: -500, // Message starts way above viewport
            itemTrailingEdge: 1000, // Message extends way below viewport
          ),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            FloatingDateDivider(
              itemPositionListener: itemPositionListener,
              reverse: false,
              messages: messages,
              itemCount: itemCount,
            ),
          ),
        );

        expect(find.byType(StreamDateDivider), findsOneWidget);

        // Verify it shows the correct date for the message at index 3
        final dateDivider = tester.widget<StreamDateDivider>(
          find.byType(StreamDateDivider),
        );
        expect(dateDivider.dateTime, equals(messages[1].createdAt.toLocal()));
      },
    );

    testWidgets(
      'filters out zero-height items from viewport calculations',
      (tester) async {
        // Bug fix: items with itemLeadingEdge == itemTrailingEdge should be
        // filtered out
        itemPositionListener.value = [
          const ItemPosition(
            index: 2,
            itemLeadingEdge: 0.5,
            itemTrailingEdge: 0.5, // Zero height - should be filtered out
          ),
          const ItemPosition(
            index: 3,
            itemLeadingEdge: 0.3,
            itemTrailingEdge: 0.8, // Valid item with actual height
          ),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            FloatingDateDivider(
              itemPositionListener: itemPositionListener,
              reverse: false,
              messages: messages,
              itemCount: itemCount,
            ),
          ),
        );

        // Should use index 3 (the only valid non-zero-height item)
        expect(find.byType(StreamDateDivider), findsOneWidget);

        final dateDivider = tester.widget<StreamDateDivider>(
          find.byType(StreamDateDivider),
        );
        expect(dateDivider.dateTime, equals(messages[1].createdAt.toLocal()));
      },
    );

    testWidgets(
      'renders Empty when all items have zero height',
      (tester) async {
        // Edge case: all items have zero height -> getTopElementIndex
        // returns null
        itemPositionListener.value = [
          const ItemPosition(
            index: 2,
            itemLeadingEdge: 0.5,
            itemTrailingEdge: 0.5, // Zero height
          ),
          const ItemPosition(
            index: 3,
            itemLeadingEdge: 0.8,
            itemTrailingEdge: 0.8, // Zero height
          ),
        ];

        await tester.pumpWidget(
          buildTestWidget(
            FloatingDateDivider(
              itemPositionListener: itemPositionListener,
              reverse: false,
              messages: messages,
              itemCount: itemCount,
            ),
          ),
        );

        expect(find.byType(Empty), findsOneWidget);
        expect(find.byType(StreamDateDivider), findsNothing);
      },
    );

    testWidgets('zero-height filtering works in reverse mode', (tester) async {
      // Test zero-height filtering for getBottomElementIndex
      itemPositionListener.value = [
        const ItemPosition(
          index: 2,
          itemLeadingEdge: 0.2,
          itemTrailingEdge: 0.2, // Zero height - should be filtered out
        ),
        const ItemPosition(
          index: 3,
          itemLeadingEdge: 0.1,
          itemTrailingEdge: 0.6, // Valid item with actual height
        ),
      ];

      await tester.pumpWidget(
        buildTestWidget(
          FloatingDateDivider(
            itemPositionListener: itemPositionListener,
            reverse: true, // Use getBottomElementIndex
            messages: messages,
            itemCount: itemCount,
          ),
        ),
      );

      expect(find.byType(StreamDateDivider), findsOneWidget);

      final dateDivider = tester.widget<StreamDateDivider>(
        find.byType(StreamDateDivider),
      );
      expect(dateDivider.dateTime, equals(messages[1].createdAt.toLocal()));
    });
  });
}
