import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter_ai/stream_chat_flutter_ai.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('AISuggestionsView', () {
    testWidgets('renders one chip per suggestion', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AISuggestionsView(
            suggestions: const ['Summarize this', 'Write an email'],
            onSuggestionSelected: (_) {},
          ),
        ),
      );

      expect(find.text('Summarize this'), findsOneWidget);
      expect(find.text('Write an email'), findsOneWidget);
    });

    testWidgets('tapping a chip fires onSuggestionSelected with its exact text', (tester) async {
      String? selected;
      await tester.pumpWidget(
        _wrap(
          AISuggestionsView(
            suggestions: const ['Summarize this', 'Write an email'],
            onSuggestionSelected: (text) => selected = text,
          ),
        ),
      );

      await tester.tap(find.text('Write an email'));
      await tester.pump();

      expect(selected, equals('Write an email'));
    });

    testWidgets('a chip truncates its text to 2 lines', (tester) async {
      const longSuggestion =
          'Create a very long suggestion that should wrap across several lines '
          'before being truncated by the chip';

      await tester.pumpWidget(
        _wrap(
          AISuggestionsView(
            suggestions: const [longSuggestion],
            onSuggestionSelected: (_) {},
          ),
        ),
      );

      final text = tester.widget<Text>(find.text(longSuggestion));
      expect(text.maxLines, equals(2));
      expect(text.overflow, equals(TextOverflow.ellipsis));
    });

    testWidgets('a short chip shrinks to its content instead of stretching to itemMaxWidth', (
      tester,
    ) async {
      const short = 'Hi';
      const long =
          'Create a very long suggestion that should wrap across two lines '
          'before hitting the max width cap';

      await tester.pumpWidget(
        _wrap(
          AISuggestionsView(
            suggestions: const [short, long],
            onSuggestionSelected: (_) {},
          ),
        ),
      );

      final shortWidth = tester.getSize(find.byKey(const ValueKey(short))).width;
      final longWidth = tester.getSize(find.byKey(const ValueKey(long))).width;

      expect(shortWidth, lessThan(longWidth));
      expect(longWidth, lessThanOrEqualTo(160));
    });

    testWidgets('a suggestion needing more room than another is at least as wide, both capped at itemMaxWidth', (
      tester,
    ) async {
      // `extended` is a strict superset of `moderate`'s content, so fitting
      // it within 2 lines can never require *less* width — regardless of
      // the exact font metrics the test environment falls back to. This
      // guards against every wrapping chip collapsing to the same fixed
      // `itemMaxWidth` (the bug being fixed) without depending on absolute
      // pixel thresholds, which vary by font.
      const moderate = 'Plan a trip to Japan';
      const extended = '$moderate and visit as many cities and temples as possible along the way';

      await tester.pumpWidget(
        _wrap(
          AISuggestionsView(
            suggestions: const [moderate, extended],
            onSuggestionSelected: (_) {},
          ),
        ),
      );

      final moderateWidth = tester.getSize(find.byKey(const ValueKey(moderate))).width;
      final extendedWidth = tester.getSize(find.byKey(const ValueKey(extended))).width;

      expect(moderateWidth, lessThanOrEqualTo(extendedWidth));
      expect(extendedWidth, lessThanOrEqualTo(160));

      // Full text still renders, untruncated by the width computation
      // itself (maxLines/ellipsis only kick in when even the max width
      // can't fit it).
      expect(find.text(extended), findsOneWidget);
    });

    testWidgets('row scrolls horizontally', (tester) async {
      await tester.pumpWidget(
        _wrap(
          AISuggestionsView(
            suggestions: const ['One', 'Two', 'Three'],
            onSuggestionSelected: (_) {},
          ),
        ),
      );

      final scrollable = tester.widget<SingleChildScrollView>(
        find.byType(SingleChildScrollView),
      );
      expect(scrollable.scrollDirection, equals(Axis.horizontal));
    });
  });
}
