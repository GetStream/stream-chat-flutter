import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:stream_chat_flutter/src/message_list_view/floating_date_divider.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('FloatingDateDivider', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              FloatingDateDivider(
                reverse: false,
                itemCount: 3,
                itemPositionListener: ItemPositionsListener.create(),
                messages: [
                  Message(),
                  Message(),
                  Message(),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(Positioned), findsOneWidget);
  });
}
