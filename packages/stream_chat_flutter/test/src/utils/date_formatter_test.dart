import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import '../mocks.dart';

void main() {
  group('formatRecentDateTime', () {
    final referenceDate = DateTime(2026, 4, 7, 10, 0);

    Future<void> pumpFormatted(WidgetTester tester, DateTime date) async {
      await tester.pumpWidget(
        _wrapWithStreamChat(
          Builder(
            builder: (context) => Text(formatRecentDateTime(context, date)),
          ),
        ),
      );
    }

    testWidgets('formats dates within a minute as Just now', (tester) async {
      await withClock(Clock.fixed(referenceDate), () async {
        await pumpFormatted(tester, DateTime(2026, 4, 7, 9, 59, 30));
        expect(find.text('Just now'), findsOneWidget);
      });
    });

    testWidgets('formats same-day dates as Today at time', (tester) async {
      await withClock(Clock.fixed(referenceDate), () async {
        await pumpFormatted(tester, DateTime(2026, 4, 7, 9, 41));
        expect(find.text('Today at 9:41 AM'), findsOneWidget);
      });
    });

    testWidgets('formats previous-day dates as Yesterday at time', (tester) async {
      await withClock(Clock.fixed(referenceDate), () async {
        await pumpFormatted(tester, DateTime(2026, 4, 6, 9, 41));
        expect(find.text('Yesterday at 9:41 AM'), findsOneWidget);
      });
    });

    testWidgets('formats recent dates within a week as Weekday at time', (tester) async {
      await withClock(Clock.fixed(referenceDate), () async {
        await pumpFormatted(tester, DateTime(2026, 4, 4, 9, 41));
        expect(find.text('Saturday at 9:41 AM'), findsOneWidget);
      });
    });

    testWidgets('formats older dates as MMM do at time', (tester) async {
      await withClock(Clock.fixed(referenceDate), () async {
        await pumpFormatted(tester, DateTime(2026, 1, 1, 9, 41));
        expect(find.text('Jan 1st at 9:41 AM'), findsOneWidget);
      });
    });
  });

  group('DateTimeComparisonUtils', () {
    group('isSame at DateTimeUnit.day', () {
      test('returns true for the same instant', () {
        final date = DateTime(2026, 4, 7, 9, 41);
        expect(date.isSame(date, unit: DateTimeUnit.day), isTrue);
      });

      test('returns true for different times on the same calendar day', () {
        final morning = DateTime(2026, 4, 7, 0, 0);
        final evening = DateTime(2026, 4, 7, 23, 59, 59);
        expect(morning.isSame(evening, unit: DateTimeUnit.day), isTrue);
      });

      test('returns false for adjacent days', () {
        final today = DateTime(2026, 4, 7, 23, 59, 59);
        final tomorrow = DateTime(2026, 4, 8, 0, 0, 0);
        expect(today.isSame(tomorrow, unit: DateTimeUnit.day), isFalse);
      });

      test('returns false across a month boundary', () {
        final lastDayOfMarch = DateTime(2026, 3, 31, 12, 0);
        final firstDayOfApril = DateTime(2026, 4, 1, 12, 0);
        expect(
          lastDayOfMarch.isSame(firstDayOfApril, unit: DateTimeUnit.day),
          isFalse,
        );
      });

      test('returns false across a year boundary', () {
        final newYearsEve = DateTime(2025, 12, 31, 23, 59);
        final newYearsDay = DateTime(2026, 1, 1, 0, 1);
        expect(
          newYearsEve.isSame(newYearsDay, unit: DateTimeUnit.day),
          isFalse,
        );
      });

      test('is symmetric', () {
        final a = DateTime(2026, 4, 7, 8, 0);
        final b = DateTime(2026, 4, 7, 18, 0);
        expect(
          a.isSame(b, unit: DateTimeUnit.day),
          b.isSame(a, unit: DateTimeUnit.day),
        );
      });
    });

    group('isSame at DateTimeUnit.minute', () {
      test('returns true for the same instant', () {
        final date = DateTime(2026, 4, 7, 9, 41);
        expect(date.isSame(date, unit: DateTimeUnit.minute), isTrue);
      });

      test('returns true for different seconds within the same minute', () {
        final a = DateTime(2026, 4, 7, 9, 41, 0);
        final b = DateTime(2026, 4, 7, 9, 41, 59);
        expect(a.isSame(b, unit: DateTimeUnit.minute), isTrue);
      });

      test('returns false across a minute boundary', () {
        // Two timestamps 2 seconds apart that straddle the 9:41 → 9:42 flip
        // show different `H:mm` labels, so they should be treated as
        // different minutes — matches Jiffy's `isSame(unit: Unit.minute)`.
        final a = DateTime(2026, 4, 7, 9, 41, 59);
        final b = DateTime(2026, 4, 7, 9, 42, 1);
        expect(a.isSame(b, unit: DateTimeUnit.minute), isFalse);
      });

      test('returns false across an hour boundary', () {
        final a = DateTime(2026, 4, 7, 9, 59);
        final b = DateTime(2026, 4, 7, 10, 0);
        expect(a.isSame(b, unit: DateTimeUnit.minute), isFalse);
      });

      test('returns false across a day boundary at the same minute label', () {
        final a = DateTime(2026, 4, 7, 9, 41);
        final b = DateTime(2026, 4, 8, 9, 41);
        expect(a.isSame(b, unit: DateTimeUnit.minute), isFalse);
      });

      test('is symmetric', () {
        final a = DateTime(2026, 4, 7, 9, 41, 5);
        final b = DateTime(2026, 4, 7, 9, 41, 45);
        expect(
          a.isSame(b, unit: DateTimeUnit.minute),
          b.isSame(a, unit: DateTimeUnit.minute),
        );
      });
    });

    group('isSame at other units', () {
      test('DateTimeUnit.year matches on year only', () {
        final a = DateTime(2026, 1, 1);
        final b = DateTime(2026, 12, 31);
        final c = DateTime(2025, 6, 15);
        expect(a.isSame(b, unit: DateTimeUnit.year), isTrue);
        expect(a.isSame(c, unit: DateTimeUnit.year), isFalse);
      });

      test('DateTimeUnit.month matches on year and month', () {
        final a = DateTime(2026, 4, 1);
        final b = DateTime(2026, 4, 30);
        final c = DateTime(2026, 5, 1);
        expect(a.isSame(b, unit: DateTimeUnit.month), isTrue);
        expect(a.isSame(c, unit: DateTimeUnit.month), isFalse);
      });

      test('DateTimeUnit.hour matches down to the hour', () {
        final a = DateTime(2026, 4, 7, 9, 0);
        final b = DateTime(2026, 4, 7, 9, 59, 59);
        final c = DateTime(2026, 4, 7, 10, 0);
        expect(a.isSame(b, unit: DateTimeUnit.hour), isTrue);
        expect(a.isSame(c, unit: DateTimeUnit.hour), isFalse);
      });

      test('DateTimeUnit.second matches down to the second', () {
        final a = DateTime(2026, 4, 7, 9, 41, 30, 0);
        final b = DateTime(2026, 4, 7, 9, 41, 30, 999);
        final c = DateTime(2026, 4, 7, 9, 41, 31, 0);
        expect(a.isSame(b, unit: DateTimeUnit.second), isTrue);
        expect(a.isSame(c, unit: DateTimeUnit.second), isFalse);
      });

      test('DateTimeUnit.microsecond requires every field to match', () {
        final a = DateTime(2026, 4, 7, 9, 41, 30, 500, 1);
        final b = DateTime(2026, 4, 7, 9, 41, 30, 500, 1);
        final c = DateTime(2026, 4, 7, 9, 41, 30, 500, 2);
        expect(a.isSame(b, unit: DateTimeUnit.microsecond), isTrue);
        expect(a.isSame(c, unit: DateTimeUnit.microsecond), isFalse);
      });
    });

    group('isToday', () {
      test('returns true for the current instant', () {
        expect(DateTime.now().isToday, isTrue);
      });

      test('returns false for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isToday, isFalse);
      });

      test('returns false for tomorrow', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.isToday, isFalse);
      });
    });

    group('isYesterday', () {
      test('returns true for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isYesterday, isTrue);
      });

      test('returns false for the current instant', () {
        expect(DateTime.now().isYesterday, isFalse);
      });

      test('returns false for two days ago', () {
        final twoDaysAgo = DateTime.now().subtract(const Duration(days: 2));
        expect(twoDaysAgo.isYesterday, isFalse);
      });
    });

    group('isWithinLastMinute', () {
      test('returns true for the current instant', () {
        expect(DateTime.now().isWithinLastMinute, isTrue);
      });

      test('returns true 30 seconds ago', () {
        final thirtySecondsAgo = DateTime.now().subtract(const Duration(seconds: 30));
        expect(thirtySecondsAgo.isWithinLastMinute, isTrue);
      });

      test('returns true 30 seconds in the future (clock-skew tolerance)', () {
        final thirtySecondsFuture = DateTime.now().add(const Duration(seconds: 30));
        expect(thirtySecondsFuture.isWithinLastMinute, isTrue);
      });

      test('returns false 2 minutes ago', () {
        final twoMinutesAgo = DateTime.now().subtract(const Duration(minutes: 2));
        expect(twoMinutesAgo.isWithinLastMinute, isFalse);
      });

      test('returns false at exact 1-minute boundary', () {
        final oneMinuteAgo = DateTime.now().subtract(const Duration(minutes: 1));
        expect(oneMinuteAgo.isWithinLastMinute, isFalse);
      });
    });

    group('isWithinLastWeek', () {
      test('returns true for the current instant', () {
        expect(DateTime.now().isWithinLastWeek, isTrue);
      });

      test('returns true for yesterday', () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        expect(yesterday.isWithinLastWeek, isTrue);
      });

      test('returns true 6 days ago', () {
        final sixDaysAgo = DateTime.now().subtract(const Duration(days: 6));
        expect(sixDaysAgo.isWithinLastWeek, isTrue);
      });

      test('returns false 7 days ago (excluded to avoid weekday collision)', () {
        // Exactly 7 days ago shares today's weekday, so showing the weekday
        // label would be ambiguous. The 6-day window excludes that boundary.
        final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
        expect(sevenDaysAgo.isWithinLastWeek, isFalse);
      });

      test('returns false 8 days ago', () {
        final eightDaysAgo = DateTime.now().subtract(const Duration(days: 8));
        expect(eightDaysAgo.isWithinLastWeek, isFalse);
      });

      test('returns false for future dates', () {
        final tomorrow = DateTime.now().add(const Duration(days: 1));
        expect(tomorrow.isWithinLastWeek, isFalse);
      });
    });

    group('isInSameYear', () {
      test('returns true for the current instant', () {
        expect(DateTime.now().isInSameYear, isTrue);
      });

      test('returns false for a date in the previous year', () {
        final lastYear = DateTime(DateTime.now().year - 1, 6, 15);
        expect(lastYear.isInSameYear, isFalse);
      });

      test('returns false across a year boundary even when 1 day apart', () {
        // Same-calendar-year semantics: Dec 31 and the following Jan 1
        // are in different years, no sliding 365-day window.
        final now = DateTime.now();
        final yearEnd = DateTime(now.year - 1, 12, 31);
        expect(yearEnd.isInSameYear, isFalse);
      });
    });

    // Cross-checks against the Jiffy package using the same DateTime inputs
    // as Jiffy's own `isSame` test suite
    // (https://github.com/jama5262/jiffy/blob/master/test/src/query_test.dart
    // — `isSameDateTimeTestData`), so we lock in behavioural parity.
    group('Jiffy parity', () {
      bool jiffyIsSameDay(DateTime a, DateTime b) => Jiffy.parseFromDateTime(a).isSame(
        Jiffy.parseFromDateTime(b),
        unit: Unit.day,
      );

      bool jiffyIsSameMinute(DateTime a, DateTime b) => Jiffy.parseFromDateTime(a).isSame(
        Jiffy.parseFromDateTime(b),
        unit: Unit.minute,
      );

      test('matches Jiffy.isSame(unit: Unit.day)', () {
        // The first three rows are the exact `Unit.day` inputs from
        // Jiffy's `isSameDateTimeTestData`. The rest cover boundaries
        // Jiffy doesn't test but our impl must handle correctly.
        final cases = <(DateTime, DateTime)>[
          (DateTime(1997, 9, 1), DateTime(1997, 9, 2)),
          (DateTime(1997, 9, 3), DateTime(1997, 9, 2)),
          (DateTime(1997, 9, 2), DateTime(1997, 9, 2)),
          (DateTime(2026, 4, 7, 23, 59, 59), DateTime(2026, 4, 7, 0, 0, 0)),
          (DateTime(2026, 4, 7, 23, 59, 59), DateTime(2026, 4, 8, 0, 0, 0)),
          (DateTime(2025, 12, 31), DateTime(2026, 1, 1)),
          (DateTime(2026, 3, 31, 12), DateTime(2026, 4, 1, 12)),
        ];
        for (final (a, b) in cases) {
          expect(
            a.isSame(b, unit: DateTimeUnit.day),
            jiffyIsSameDay(a, b),
            reason: 'isSame($a, $b, unit: day) disagrees with Jiffy',
          );
        }
      });

      test('matches Jiffy.isSame(unit: Unit.minute)', () {
        // The first three rows are the exact `Unit.minute` inputs from
        // Jiffy's `isSameDateTimeTestData`. The rest cover boundaries
        // Jiffy doesn't test but our impl must handle correctly.
        final cases = <(DateTime, DateTime)>[
          (DateTime(1997, 9, 23, 12, 1), DateTime(1997, 9, 23, 12, 2)),
          (DateTime(1997, 9, 23, 12, 3), DateTime(1997, 9, 23, 12, 2)),
          (DateTime(1997, 9, 23, 12, 2), DateTime(1997, 9, 23, 12, 2)),
          // 2s apart but straddle the minute flip — should be different.
          (DateTime(2026, 4, 7, 12, 1, 59), DateTime(2026, 4, 7, 12, 2, 1)),
          // 59s apart within the same minute — should be same.
          (DateTime(2026, 4, 7, 9, 41, 0), DateTime(2026, 4, 7, 9, 41, 59)),
          // Same minute label on different days — should be different.
          (DateTime(2026, 4, 7, 9, 41), DateTime(2026, 4, 8, 9, 41)),
        ];
        for (final (a, b) in cases) {
          expect(
            a.isSame(b, unit: DateTimeUnit.minute),
            jiffyIsSameMinute(a, b),
            reason: 'isSame($a, $b, unit: minute) disagrees with Jiffy',
          );
        }
      });
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
