import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'mocks.dart';

void main() {
  testWidgets(
    'it should show basic channel information',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(MaterialApp(
        home: StreamChat(
          client: client,
          child: Scaffold(
            body: StreamDateDivider(
              dateTime: DateTime.now(),
            ),
          ),
        ),
      ));

      expect(find.text('Today'), findsOneWidget);
    },
  );
}
