import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('StreamPollOptionVotesStyle', () {
    const full = StreamPollOptionVotesStyle(
      cardStyle: StreamPollCardStyle(
        backgroundColor: Colors.grey,
        padding: EdgeInsets.all(6),
      ),
      numberTextStyle: TextStyle(fontSize: 10),
      textStyle: TextStyle(fontSize: 14),
      voteCountTextStyle: TextStyle(fontSize: 11),
      winnerIconColor: Colors.amber,
      winnerIconSize: 24,
      footerDividerColor: Colors.pink,
      footerButtonStyle: StreamButtonThemeStyle(
        backgroundColor: WidgetStatePropertyAll(Colors.black),
      ),
    );

    test('equality + hashCode', () {
      const identical = StreamPollOptionVotesStyle(
        cardStyle: StreamPollCardStyle(
          backgroundColor: Colors.grey,
          padding: EdgeInsets.all(6),
        ),
        numberTextStyle: TextStyle(fontSize: 10),
        textStyle: TextStyle(fontSize: 14),
        voteCountTextStyle: TextStyle(fontSize: 11),
        winnerIconColor: Colors.amber,
        winnerIconSize: 24,
        footerDividerColor: Colors.pink,
        footerButtonStyle: StreamButtonThemeStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.black),
        ),
      );
      const different = StreamPollOptionVotesStyle(winnerIconSize: 99);

      expect(full, identical);
      expect(full, isNot(different));
      expect(full.hashCode, identical.hashCode);
    });

    test('copyWith overrides only specified fields', () {
      final copied = full.copyWith(winnerIconSize: 99);
      expect(copied.winnerIconSize, 99);
      expect(copied.cardStyle, full.cardStyle);
      expect(copied.numberTextStyle, full.numberTextStyle);
      expect(copied.textStyle, full.textStyle);
      expect(copied.voteCountTextStyle, full.voteCountTextStyle);
      expect(copied.winnerIconColor, full.winnerIconColor);
      expect(copied.footerDividerColor, full.footerDividerColor);
      expect(copied.footerButtonStyle, full.footerButtonStyle);
    });

    test('merge prefers non-null fields from other', () {
      const other = StreamPollOptionVotesStyle(
        winnerIconSize: 99,
        winnerIconColor: Colors.red,
        footerDividerColor: Colors.green,
      );
      final merged = full.merge(other);

      expect(merged.winnerIconSize, 99);
      expect(merged.winnerIconColor, Colors.red);
      expect(merged.footerDividerColor, Colors.green);
      expect(merged.cardStyle, full.cardStyle);
      expect(merged.numberTextStyle, full.numberTextStyle);
      expect(merged.textStyle, full.textStyle);

      expect(full.merge(null), full);
    });

    test('lerp interpolates common fields', () {
      const a = StreamPollOptionVotesStyle(winnerIconSize: 10);
      const b = StreamPollOptionVotesStyle(winnerIconSize: 20);

      final at0 = StreamPollOptionVotesStyle.lerp(a, b, 0)!;
      expect(at0.winnerIconSize, a.winnerIconSize);

      final at1 = StreamPollOptionVotesStyle.lerp(a, b, 1)!;
      expect(at1.winnerIconSize, b.winnerIconSize);

      final mid = StreamPollOptionVotesStyle.lerp(a, b, 0.5)!;
      expect(mid.winnerIconSize, 15);
    });
  });
}
