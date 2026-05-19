import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('StreamPollResultsSheetTheme', () {
    testWidgets('merges local theme with ancestor global theme', (tester) async {
      const globalBg = Color(0xFF111111);
      const globalTotalVoteCountTextStyle = TextStyle(fontSize: 17);
      const localSectionSpacing = 42.0;
      const localOptionTextStyle = TextStyle(fontSize: 19);

      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData().copyWith(
              pollResultsSheetTheme: const StreamPollResultsSheetThemeData(
                backgroundColor: globalBg,
                totalVoteCountTextStyle: globalTotalVoteCountTextStyle,
              ),
            ),
            child: Builder(
              builder: (context) {
                return StreamPollResultsSheetTheme(
                  data: const StreamPollResultsSheetThemeData(
                    sectionSpacing: localSectionSpacing,
                    optionStyle: StreamPollOptionVotesStyle(
                      textStyle: localOptionTextStyle,
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      capturedContext = context;
                      return const SizedBox();
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      final theme = StreamPollResultsSheetTheme.of(capturedContext);
      // Inherited from the global theme.
      expect(theme.backgroundColor, globalBg);
      expect(theme.totalVoteCountTextStyle, globalTotalVoteCountTextStyle);
      // Overridden locally.
      expect(theme.sectionSpacing, localSectionSpacing);
      expect(theme.optionStyle?.textStyle, localOptionTextStyle);
    });
  });

  group('StreamPollResultsSheetThemeData', () {
    const full = StreamPollResultsSheetThemeData(
      backgroundColor: Colors.red,
      contentPadding: EdgeInsets.all(8),
      sectionSpacing: 16,
      questionStyle: StreamPollQuestionStyle(
        cardStyle: StreamPollCardStyle(
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(4),
        ),
        headerTextStyle: TextStyle(fontSize: 12),
        textStyle: TextStyle(fontSize: 18),
      ),
      optionsItemSpacing: 6,
      optionStyle: StreamPollOptionVotesStyle(
        cardStyle: StreamPollCardStyle(
          backgroundColor: Colors.grey,
          padding: EdgeInsets.all(6),
        ),
        numberTextStyle: TextStyle(fontSize: 10),
        textStyle: TextStyle(fontSize: 14),
        voteCountTextStyle: TextStyle(fontSize: 11),
        winnerIconColor: Colors.amber,
        winnerIconSize: 24,
      ),
      totalVoteCountTextStyle: TextStyle(fontSize: 13),
    );

    test('equality + hashCode', () {
      const identical = StreamPollResultsSheetThemeData(
        backgroundColor: Colors.red,
        contentPadding: EdgeInsets.all(8),
        sectionSpacing: 16,
        questionStyle: StreamPollQuestionStyle(
          cardStyle: StreamPollCardStyle(
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(4),
          ),
          headerTextStyle: TextStyle(fontSize: 12),
          textStyle: TextStyle(fontSize: 18),
        ),
        optionsItemSpacing: 6,
        optionStyle: StreamPollOptionVotesStyle(
          cardStyle: StreamPollCardStyle(
            backgroundColor: Colors.grey,
            padding: EdgeInsets.all(6),
          ),
          numberTextStyle: TextStyle(fontSize: 10),
          textStyle: TextStyle(fontSize: 14),
          voteCountTextStyle: TextStyle(fontSize: 11),
          winnerIconColor: Colors.amber,
          winnerIconSize: 24,
        ),
        totalVoteCountTextStyle: TextStyle(fontSize: 13),
      );

      const different = StreamPollResultsSheetThemeData(
        backgroundColor: Colors.blue, // changed
      );

      expect(full, identical);
      expect(full, isNot(different));
      expect(full.hashCode, identical.hashCode);
    });

    test('copyWith overrides only specified fields', () {
      final copied = full.copyWith(
        backgroundColor: Colors.blue,
        sectionSpacing: 99,
      );

      expect(copied.backgroundColor, Colors.blue);
      expect(copied.sectionSpacing, 99);
      // Untouched fields remain.
      expect(copied.contentPadding, full.contentPadding);
      expect(copied.questionStyle, full.questionStyle);
      expect(copied.optionsItemSpacing, full.optionsItemSpacing);
      expect(copied.optionStyle, full.optionStyle);
      expect(copied.totalVoteCountTextStyle, full.totalVoteCountTextStyle);
    });

    test('merge prefers non-null fields from other', () {
      const other = StreamPollResultsSheetThemeData(
        backgroundColor: Colors.green,
        optionsItemSpacing: 99,
        totalVoteCountTextStyle: TextStyle(fontSize: 99),
      );

      final merged = full.merge(other);

      // Fields present on `other` win.
      expect(merged.backgroundColor, Colors.green);
      expect(merged.optionsItemSpacing, 99);
      expect(merged.totalVoteCountTextStyle, const TextStyle(fontSize: 99));
      // Fields null on `other` preserve `full`.
      expect(merged.sectionSpacing, full.sectionSpacing);
      expect(merged.questionStyle, full.questionStyle);
      expect(merged.optionStyle, full.optionStyle);

      // Merging with null returns `this`.
      expect(full.merge(null), full);
    });

    test('lerp at boundaries returns endpoints; at 0.5 interpolates', () {
      const a = StreamPollResultsSheetThemeData(
        backgroundColor: Colors.black,
        sectionSpacing: 0,
      );
      const b = StreamPollResultsSheetThemeData(
        backgroundColor: Colors.white,
        sectionSpacing: 10,
      );

      final at0 = StreamPollResultsSheetThemeData.lerp(a, b, 0)!;
      expect(at0.backgroundColor, a.backgroundColor);
      expect(at0.sectionSpacing, a.sectionSpacing);

      final at1 = StreamPollResultsSheetThemeData.lerp(a, b, 1)!;
      expect(at1.backgroundColor, b.backgroundColor);
      expect(at1.sectionSpacing, b.sectionSpacing);

      final mid = StreamPollResultsSheetThemeData.lerp(a, b, 0.5)!;
      expect(mid.backgroundColor, Color.lerp(Colors.black, Colors.white, 0.5));
      expect(mid.sectionSpacing, 5);
    });
  });
}
