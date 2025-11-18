import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

String _dummyFormatter(BuildContext context, DateTime date) => 'formatted';

void main() {
  testWidgets('StreamDraftListTileTheme merges with ancestor theme',
      (tester) async {
    const backgroundColor = Colors.blue;
    const childBackgroundColor = Colors.red;

    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(
            draftListTileTheme: const StreamDraftListTileThemeData(
              backgroundColor: backgroundColor,
            ),
          ),
          child: Builder(
            builder: (context) {
              return StreamDraftListTileTheme(
                data: const StreamDraftListTileThemeData(
                  backgroundColor: childBackgroundColor,
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

    // Verify that the theme data is correctly merged
    final theme = StreamDraftListTileTheme.of(capturedContext);
    expect(theme.backgroundColor, childBackgroundColor);
  });

  test('StreamDraftListTileThemeData equality', () {
    const themeData1 = StreamDraftListTileThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      draftChannelNameStyle: TextStyle(fontSize: 16),
      draftMessageStyle: TextStyle(fontSize: 14),
      draftTimestampStyle: TextStyle(fontSize: 12),
      draftTimestampFormatter: _dummyFormatter,
    );

    const themeData2 = StreamDraftListTileThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      draftChannelNameStyle: TextStyle(fontSize: 16),
      draftMessageStyle: TextStyle(fontSize: 14),
      draftTimestampStyle: TextStyle(fontSize: 12),
      draftTimestampFormatter: _dummyFormatter,
    );

    const themeData3 = StreamDraftListTileThemeData(
      backgroundColor: Colors.blue, // Different color
      padding: EdgeInsets.all(8),
      draftChannelNameStyle: TextStyle(fontSize: 16),
      draftMessageStyle: TextStyle(fontSize: 14),
      draftTimestampStyle: TextStyle(fontSize: 12),
      draftTimestampFormatter: _dummyFormatter,
    );

    // Same properties should be equal
    expect(themeData1, themeData2);
    // Different properties should not be equal
    expect(themeData1, isNot(themeData3));

    // Hash codes should match for equal objects
    expect(themeData1.hashCode, themeData2.hashCode);
  });

  test('StreamDraftListTileThemeData copyWith', () {
    const original = StreamDraftListTileThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      draftChannelNameStyle: TextStyle(fontSize: 16),
      draftMessageStyle: TextStyle(fontSize: 14),
      draftTimestampStyle: TextStyle(fontSize: 12),
      draftTimestampFormatter: _dummyFormatter,
    );

    const newBackgroundColor = Colors.blue;
    const newPadding = EdgeInsets.all(16);

    final copied = original.copyWith(
      backgroundColor: newBackgroundColor,
      padding: newPadding,
    );

    // Verify copied properties
    expect(copied.backgroundColor, newBackgroundColor);
    expect(copied.padding, newPadding);
    // Unchanged properties should remain the same
    expect(copied.draftChannelNameStyle, original.draftChannelNameStyle);
    expect(copied.draftMessageStyle, original.draftMessageStyle);
    expect(copied.draftTimestampStyle, original.draftTimestampStyle);
    expect(copied.draftTimestampFormatter, original.draftTimestampFormatter);
  });

  test('StreamDraftListTileThemeData merge', () {
    const original = StreamDraftListTileThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      draftChannelNameStyle: TextStyle(fontSize: 16),
      draftMessageStyle: TextStyle(fontSize: 14),
      draftTimestampStyle: TextStyle(fontSize: 12),
      draftTimestampFormatter: _dummyFormatter,
    );

    const other = StreamDraftListTileThemeData(
      backgroundColor: Colors.blue,
      padding: EdgeInsets.all(16),
      // Other properties are null
    );

    final merged = original.merge(other);

    // Properties from 'other' should override 'original'
    expect(merged.backgroundColor, other.backgroundColor);
    expect(merged.padding, other.padding);
    // Null properties in 'other' should not override 'original'
    expect(merged.draftChannelNameStyle, original.draftChannelNameStyle);
    expect(merged.draftMessageStyle, original.draftMessageStyle);
    expect(merged.draftTimestampStyle, original.draftTimestampStyle);
    expect(merged.draftTimestampFormatter, original.draftTimestampFormatter);

    // Merging with null should return original
    final mergedWithNull = original.merge(null);
    expect(mergedWithNull, original);
  });

  test('StreamDraftListTileThemeData lerp', () {
    const data1 = StreamDraftListTileThemeData(
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(8),
    );

    const data2 = StreamDraftListTileThemeData(
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(16),
    );

    // t = 0 should return data1
    final lerpedAt0 = data1.lerp(data1, data2, 0);
    expect(lerpedAt0.backgroundColor, data1.backgroundColor);
    expect(lerpedAt0.padding, data1.padding);

    // t = 1 should return data2
    final lerpedAt1 = data1.lerp(data1, data2, 1);
    expect(lerpedAt1.backgroundColor, data2.backgroundColor);
    expect(lerpedAt1.padding, data2.padding);

    // t = 0.5 should return something in between
    final lerpedAt05 = data1.lerp(data1, data2, 0.5);
    expect(lerpedAt05.backgroundColor,
        Color.lerp(Colors.black, Colors.white, 0.5));
    expect(
        lerpedAt05.padding,
        EdgeInsetsGeometry.lerp(
          const EdgeInsets.all(8),
          const EdgeInsets.all(16),
          0.5,
        ));
  });
}
