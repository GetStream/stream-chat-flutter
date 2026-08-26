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

  group('semantics', () {
    Widget buildDivider({required DateTime date, bool uppercase = false}) {
      final client = MockClient();
      final clientState = MockClientState();

      when(() => client.state).thenReturn(clientState);
      when(() => clientState.currentUser).thenReturn(OwnUser(id: 'user-id'));

      return MaterialApp(
        home: StreamChat(
          client: client,
          child: Scaffold(
            body: StreamDateDivider(dateTime: date, uppercase: uppercase),
          ),
        ),
      );
    }

    testWidgets('announces the date it shows, without a time', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildDivider(date: DateTime.now()));
      await tester.pumpAndSettle();

      final node = tester.semantics.find(find.byType(StreamDateDivider));
      expect(node.label, 'Today');
      // Left to its default, StreamTimestamp would announce
      // `formatRecentDateTime`'s "Today at 3:00 PM" and invent a clock time
      // that the divider never shows.
      expect(node.label, isNot(contains('at')));

      handle.dispose();
    });

    testWidgets('is exposed as a header so days can be jumped between', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildDivider(date: DateTime.now()));
      await tester.pumpAndSettle();

      expect(
        tester.semantics.find(find.byType(StreamDateDivider)),
        isSemantics(isHeader: true),
      );

      handle.dispose();
    });

    testWidgets('announces the date unshouted when displayed uppercase', (tester) async {
      final handle = tester.ensureSemantics();

      await tester.pumpWidget(buildDivider(date: DateTime.now(), uppercase: true));
      await tester.pumpAndSettle();

      expect(find.text('TODAY'), findsOneWidget);
      // Some screen readers spell out all-caps words letter by letter.
      expect(tester.semantics.find(find.byType(StreamDateDivider)).label, 'Today');

      handle.dispose();
    });
  });
}
