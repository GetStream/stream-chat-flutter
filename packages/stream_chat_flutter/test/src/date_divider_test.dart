import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show basic channel information',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(client.state).thenReturn(clientState);
      when(clientState.user).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: Scaffold(
            body: DateDivider(
              dateTime: DateTime.now(),
            ),
          ),
        ),
      ));

      expect(find.text('Today'), findsOneWidget);
    },
  );
}
