import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets('FloatingDateDivider', (tester) async {
    final client = MockClient();
    final clientState = MockClientState();

    when(() => client.state).thenReturn(clientState);
    when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

    final createdAt = DateTime.now();

    final itemPositionsListener = ValueNotifier(
      [
        const ItemPosition(
          index: 0,
          itemLeadingEdge: 0,
          itemTrailingEdge: 0,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              FloatingDateDivider(
                reverse: false,
                itemCount: 3,
                itemPositionListener: itemPositionsListener,
                messages: [Message(createdAt: createdAt)],
                dateDividerBuilder: (dateTime) => Text('$dateTime'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('$createdAt'), findsOneWidget);
  });
}
