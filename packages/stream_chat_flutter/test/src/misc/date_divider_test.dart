import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  testWidgets(
    'it should show basic channel information',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: StreamDateDivider(
                dateTime: DateTime.now(),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Today'), findsOneWidget);
    },
  );

  testWidgets(
    'it should use custom formatter when provided',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final testDate = DateTime(2024, 1, 15);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: StreamDateDivider(
                dateTime: testDate,
                formatter: (context, date) => 'Custom: ${date.day}/${date.month}',
              ),
            ),
          ),
        ),
      );

      expect(find.text('Custom: 15/1'), findsOneWidget);
      expect(find.text('Today'), findsNothing);
    },
  );

  testWidgets(
    'it should apply uppercase when uppercase is true',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: StreamDateDivider(
                dateTime: DateTime.now(),
                uppercase: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('TODAY'), findsOneWidget);
      expect(find.text('Today'), findsNothing);
    },
  );

  testWidgets(
    'it should apply uppercase to custom formatter output',
    (WidgetTester tester) async {
      final client = MockClient();
      final clientState = MockClientState();
      final testDate = DateTime(2024, 1, 15);

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChat(
            client: client,
            child: Scaffold(
              body: StreamDateDivider(
                dateTime: testDate,
                formatter: (context, date) => 'custom format',
                uppercase: true,
              ),
            ),
          ),
        ),
      );

      expect(find.text('CUSTOM FORMAT'), findsOneWidget);
      expect(find.text('custom format'), findsNothing);
    },
  );
}
