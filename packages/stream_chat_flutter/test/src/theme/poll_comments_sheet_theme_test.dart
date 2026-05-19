import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  group('StreamPollCommentsSheetTheme', () {
    testWidgets('merges local theme with ancestor global theme', (tester) async {
      const globalBg = Color(0xFF111111);
      const localItemSpacing = 42.0;
      const localCommentCardColor = Color(0xFF222222);

      late BuildContext capturedContext;

      await tester.pumpWidget(
        MaterialApp(
          home: StreamChatTheme(
            data: StreamChatThemeData().copyWith(
              pollCommentsSheetTheme: const StreamPollCommentsSheetThemeData(
                backgroundColor: globalBg,
              ),
            ),
            child: Builder(
              builder: (context) {
                return StreamPollCommentsSheetTheme(
                  data: const StreamPollCommentsSheetThemeData(
                    itemSpacing: localItemSpacing,
                    commentStyle: StreamPollOptionVotesStyle(
                      cardStyle: StreamPollCardStyle(
                        backgroundColor: localCommentCardColor,
                      ),
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

      final theme = StreamPollCommentsSheetTheme.of(capturedContext);
      // Inherited from the global theme.
      expect(theme.backgroundColor, globalBg);
      // Overridden locally.
      expect(theme.itemSpacing, localItemSpacing);
      expect(theme.commentStyle?.cardStyle?.backgroundColor, localCommentCardColor);
    });
  });

  group('StreamPollCommentsSheetThemeData', () {
    const full = StreamPollCommentsSheetThemeData(
      backgroundColor: Colors.red,
      contentPadding: EdgeInsets.all(8),
      itemSpacing: 16,
      commentStyle: StreamPollOptionVotesStyle(
        cardStyle: StreamPollCardStyle(
          backgroundColor: Colors.white,
          padding: EdgeInsets.all(4),
        ),
        footerDividerColor: Colors.pink,
        footerButtonStyle: StreamButtonThemeStyle(
          backgroundColor: WidgetStatePropertyAll(Colors.black),
        ),
      ),
    );

    test('equality + hashCode', () {
      const identical = StreamPollCommentsSheetThemeData(
        backgroundColor: Colors.red,
        contentPadding: EdgeInsets.all(8),
        itemSpacing: 16,
        commentStyle: StreamPollOptionVotesStyle(
          cardStyle: StreamPollCardStyle(
            backgroundColor: Colors.white,
            padding: EdgeInsets.all(4),
          ),
          footerDividerColor: Colors.pink,
          footerButtonStyle: StreamButtonThemeStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.black),
          ),
        ),
      );

      const different = StreamPollCommentsSheetThemeData(
        backgroundColor: Colors.blue,
      );

      expect(full, identical);
      expect(full, isNot(different));
      expect(full.hashCode, identical.hashCode);
    });

    test('copyWith overrides only specified fields', () {
      final copied = full.copyWith(
        backgroundColor: Colors.blue,
        itemSpacing: 99,
      );

      expect(copied.backgroundColor, Colors.blue);
      expect(copied.itemSpacing, 99);
      // Untouched fields remain.
      expect(copied.contentPadding, full.contentPadding);
      expect(copied.commentStyle, full.commentStyle);
    });

    test('merge prefers non-null fields from other', () {
      const other = StreamPollCommentsSheetThemeData(
        backgroundColor: Colors.green,
        itemSpacing: 99,
      );

      final merged = full.merge(other);

      // Fields present on `other` win.
      expect(merged.backgroundColor, Colors.green);
      expect(merged.itemSpacing, 99);
      // Fields null on `other` preserve `full`.
      expect(merged.contentPadding, full.contentPadding);
      expect(merged.commentStyle, full.commentStyle);

      // Merging with null returns `this`.
      expect(full.merge(null), full);
    });

    test('lerp at boundaries returns endpoints; at 0.5 interpolates', () {
      const a = StreamPollCommentsSheetThemeData(
        backgroundColor: Colors.black,
        itemSpacing: 0,
      );
      const b = StreamPollCommentsSheetThemeData(
        backgroundColor: Colors.white,
        itemSpacing: 10,
      );

      final at0 = StreamPollCommentsSheetThemeData.lerp(a, b, 0)!;
      expect(at0.backgroundColor, a.backgroundColor);
      expect(at0.itemSpacing, a.itemSpacing);

      final at1 = StreamPollCommentsSheetThemeData.lerp(a, b, 1)!;
      expect(at1.backgroundColor, b.backgroundColor);
      expect(at1.itemSpacing, b.itemSpacing);

      final mid = StreamPollCommentsSheetThemeData.lerp(a, b, 0.5)!;
      expect(mid.backgroundColor, Color.lerp(Colors.black, Colors.white, 0.5));
      expect(mid.itemSpacing, 5);
    });
  });
}
