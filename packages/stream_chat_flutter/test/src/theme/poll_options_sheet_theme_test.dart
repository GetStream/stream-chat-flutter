import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('StreamPollOptionsSheetTheme', () {
    testWidgets('merges local theme with ancestor global theme', (tester) async {
      const globalBg = Color(0xFF111111);
      const localSectionSpacing = 42.0;
      const localOptionStyleTextStyle = TextStyle(fontSize: 19);

      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData().copyWith(
              pollOptionsSheetTheme: const StreamPollOptionsSheetThemeData(
                backgroundColor: globalBg,
              ),
            ),
            child: Builder(
              builder: (context) {
                return StreamPollOptionsSheetTheme(
                  data: const StreamPollOptionsSheetThemeData(
                    sectionSpacing: localSectionSpacing,
                    optionStyle: StreamPollOptionStyle(
                      textStyle: localOptionStyleTextStyle,
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

      final theme = StreamPollOptionsSheetTheme.of(capturedContext);
      // Inherited from the global theme.
      expect(theme.backgroundColor, globalBg);
      // Overridden locally.
      expect(theme.sectionSpacing, localSectionSpacing);
      expect(theme.optionStyle?.textStyle, localOptionStyleTextStyle);
    });
  });

  group('StreamPollOptionsSheetThemeData', () {
    const full = StreamPollOptionsSheetThemeData(
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
      optionsCardStyle: StreamPollCardStyle(
        backgroundColor: Colors.grey,
        padding: EdgeInsets.all(6),
      ),
      optionsItemSpacing: 4,
      optionStyle: StreamPollOptionStyle(
        textStyle: TextStyle(fontSize: 14),
      ),
    );

    test('equality + hashCode', () {
      const identical = StreamPollOptionsSheetThemeData(
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
        optionsCardStyle: StreamPollCardStyle(
          backgroundColor: Colors.grey,
          padding: EdgeInsets.all(6),
        ),
        optionsItemSpacing: 4,
        optionStyle: StreamPollOptionStyle(
          textStyle: TextStyle(fontSize: 14),
        ),
      );

      const different = StreamPollOptionsSheetThemeData(
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
      expect(copied.optionsCardStyle, full.optionsCardStyle);
      expect(copied.optionsItemSpacing, full.optionsItemSpacing);
      expect(copied.optionStyle, full.optionStyle);
    });

    test('merge prefers non-null fields from other', () {
      const other = StreamPollOptionsSheetThemeData(
        backgroundColor: Colors.green,
        optionsItemSpacing: 99,
      );

      final merged = full.merge(other);

      // Fields present on `other` win.
      expect(merged.backgroundColor, Colors.green);
      expect(merged.optionsItemSpacing, 99);
      // Fields null on `other` preserve `full`.
      expect(merged.sectionSpacing, full.sectionSpacing);
      expect(merged.questionStyle, full.questionStyle);
      expect(merged.optionStyle, full.optionStyle);

      // Merging with null returns `this`.
      expect(full.merge(null), full);
    });

    test('lerp at boundaries returns endpoints; at 0.5 interpolates', () {
      const a = StreamPollOptionsSheetThemeData(
        backgroundColor: Colors.black,
        sectionSpacing: 0,
      );
      const b = StreamPollOptionsSheetThemeData(
        backgroundColor: Colors.white,
        sectionSpacing: 10,
      );

      final at0 = StreamPollOptionsSheetThemeData.lerp(a, b, 0)!;
      expect(at0.backgroundColor, a.backgroundColor);
      expect(at0.sectionSpacing, a.sectionSpacing);

      final at1 = StreamPollOptionsSheetThemeData.lerp(a, b, 1)!;
      expect(at1.backgroundColor, b.backgroundColor);
      expect(at1.sectionSpacing, b.sectionSpacing);

      final mid = StreamPollOptionsSheetThemeData.lerp(a, b, 0.5)!;
      expect(mid.backgroundColor, Color.lerp(Colors.black, Colors.white, 0.5));
      expect(mid.sectionSpacing, 5);
    });
  });

  group('StreamPollQuestionStyle', () {
    const full = StreamPollQuestionStyle(
      cardStyle: StreamPollCardStyle(
        backgroundColor: Colors.white,
        padding: EdgeInsets.all(4),
      ),
      headerTextStyle: TextStyle(fontSize: 12),
      textStyle: TextStyle(fontSize: 18),
    );

    test('equality + hashCode', () {
      const identical = StreamPollQuestionStyle(
        cardStyle: StreamPollCardStyle(
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(4),
        ),
        headerTextStyle: TextStyle(fontSize: 12),
        textStyle: TextStyle(fontSize: 18),
      );
      const different = StreamPollQuestionStyle(
        headerTextStyle: TextStyle(fontSize: 99),
      );

      expect(full, identical);
      expect(full, isNot(different));
      expect(full.hashCode, identical.hashCode);
    });

    test('copyWith overrides only specified fields', () {
      final copied = full.copyWith(
        headerTextStyle: const TextStyle(fontSize: 30),
      );
      expect(copied.headerTextStyle, const TextStyle(fontSize: 30));
      expect(copied.cardStyle, full.cardStyle);
      expect(copied.textStyle, full.textStyle);
    });

    test('merge prefers non-null fields from other', () {
      const other = StreamPollQuestionStyle(
        textStyle: TextStyle(fontSize: 30),
      );
      final merged = full.merge(other);

      expect(merged.textStyle, const TextStyle(fontSize: 18).merge(const TextStyle(fontSize: 30)));
      expect(merged.cardStyle, full.cardStyle);
      expect(merged.headerTextStyle, full.headerTextStyle);

      expect(full.merge(null), full);
    });

    test('lerp interpolates common fields', () {
      const a = StreamPollQuestionStyle(
        headerTextStyle: TextStyle(fontSize: 10),
      );
      const b = StreamPollQuestionStyle(
        headerTextStyle: TextStyle(fontSize: 20),
      );

      final at0 = StreamPollQuestionStyle.lerp(a, b, 0)!;
      expect(at0.headerTextStyle, a.headerTextStyle);

      final at1 = StreamPollQuestionStyle.lerp(a, b, 1)!;
      expect(at1.headerTextStyle, b.headerTextStyle);

      final mid = StreamPollQuestionStyle.lerp(a, b, 0.5)!;
      expect(mid.headerTextStyle?.fontSize, 15);
    });
  });

  group('StreamPollCardStyle', () {
    const full = StreamPollCardStyle(
      backgroundColor: Colors.red,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      padding: EdgeInsets.all(8),
    );

    test('equality', () {
      const identical = StreamPollCardStyle(
        backgroundColor: Colors.red,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        padding: EdgeInsets.all(8),
      );
      const different = StreamPollCardStyle(backgroundColor: Colors.blue);

      expect(full, identical);
      expect(full, isNot(different));
    });

    test('copyWith overrides only specified fields', () {
      final copied = full.copyWith(backgroundColor: Colors.blue);
      expect(copied.backgroundColor, Colors.blue);
      expect(copied.borderRadius, full.borderRadius);
      expect(copied.padding, full.padding);
    });

    test('merge prefers non-null fields from other', () {
      const other = StreamPollCardStyle(backgroundColor: Colors.green);
      final merged = full.merge(other);
      expect(merged.backgroundColor, Colors.green);
      expect(merged.borderRadius, full.borderRadius);
      expect(merged.padding, full.padding);

      expect(full.merge(null), full);
    });

    test('lerp interpolates common fields', () {
      const a = StreamPollCardStyle(backgroundColor: Colors.black);
      const b = StreamPollCardStyle(backgroundColor: Colors.white);

      final at0 = StreamPollCardStyle.lerp(a, b, 0)!;
      expect(at0.backgroundColor, a.backgroundColor);

      final at1 = StreamPollCardStyle.lerp(a, b, 1)!;
      expect(at1.backgroundColor, b.backgroundColor);

      final mid = StreamPollCardStyle.lerp(a, b, 0.5)!;
      expect(mid.backgroundColor, Color.lerp(Colors.black, Colors.white, 0.5));
    });
  });
}
