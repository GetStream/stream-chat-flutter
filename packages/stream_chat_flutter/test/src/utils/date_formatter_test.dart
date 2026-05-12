import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('formatRecentDateTime', () {
    final referenceDate = DateTime(2026, 4, 7, 10, 0);

    testWidgets('formats dates within a minute as Just now', (tester) async {
      await tester.pumpWidget(
        _wrapWithStreamChat(
          Builder(
            builder: (context) {
              return Text(
                formatRecentDateTime(
                  context,
                  DateTime(2026, 4, 7, 9, 59, 30),
                  referenceDate: referenceDate,
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Just now'), findsOneWidget);
    });

    testWidgets('formats same-day dates as Today at H:mm', (tester) async {
      await tester.pumpWidget(
        _wrapWithStreamChat(
          Builder(
            builder: (context) {
              return Text(
                formatRecentDateTime(
                  context,
                  DateTime(2026, 4, 7, 9, 41),
                  referenceDate: referenceDate,
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Today at 9:41'), findsOneWidget);
    });

    testWidgets('formats previous-day dates as Yesterday at H:mm', (tester) async {
      await tester.pumpWidget(
        _wrapWithStreamChat(
          Builder(
            builder: (context) {
              return Text(
                formatRecentDateTime(
                  context,
                  DateTime(2026, 4, 6, 9, 41),
                  referenceDate: referenceDate,
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Yesterday at 9:41'), findsOneWidget);
    });

    testWidgets('formats recent dates within a week as Weekday at H:mm', (tester) async {
      await tester.pumpWidget(
        _wrapWithStreamChat(
          Builder(
            builder: (context) {
              return Text(
                formatRecentDateTime(
                  context,
                  DateTime(2026, 4, 4, 9, 41),
                  referenceDate: referenceDate,
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Saturday at 9:41'), findsOneWidget);
    });

    testWidgets('formats older dates as MMM do at H:mm', (tester) async {
      await tester.pumpWidget(
        _wrapWithStreamChat(
          Builder(
            builder: (context) {
              return Text(
                formatRecentDateTime(
                  context,
                  DateTime(2026, 1, 1, 9, 41),
                  referenceDate: referenceDate,
                ),
              );
            },
          ),
        ),
      );

      expect(find.text('Jan 1st at 9:41'), findsOneWidget);
    });
  });
}

Widget _wrapWithStreamChat(Widget child) {
  final client = MockClient();
  final clientState = MockClientState();

  when(() => client.state).thenReturn(clientState);
  when(() => clientState.currentUser).thenReturn(OwnUser(id: 'current-user-id', name: 'Current User'));

  return MaterialApp(
    home: StreamChat(
      client: client,
      child: Scaffold(body: child),
    ),
  );
}
