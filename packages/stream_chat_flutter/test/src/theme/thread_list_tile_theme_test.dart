import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

String _dummyFormatter(BuildContext context, DateTime date) => 'formatted';

void main() {
  testWidgets('StreamThreadListTileTheme merges with ancestor theme', (tester) async {
    const backgroundColor = Colors.blue;
    const childBackgroundColor = Colors.red;

    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(
            threadListTileTheme: const StreamThreadListTileThemeData(
              backgroundColor: backgroundColor,
            ),
          ),
          child: Builder(
            builder: (context) {
              return StreamThreadListTileTheme(
                data: const StreamThreadListTileThemeData(
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
    final theme = StreamThreadListTileTheme.of(capturedContext);
    expect(theme.backgroundColor, childBackgroundColor);
  });

  test('StreamThreadListTileThemeData equality', () {
    const themeData1 = StreamThreadListTileThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      threadChannelNameStyle: TextStyle(fontSize: 16),
      threadReplyToMessageStyle: TextStyle(fontSize: 14),
      threadLatestReplyUsernameStyle: TextStyle(fontSize: 14),
      threadLatestReplyMessageStyle: TextStyle(fontSize: 14),
      threadLatestReplyTimestampStyle: TextStyle(fontSize: 12),
      threadLatestReplyTimestampFormatter: _dummyFormatter,
      threadUnreadMessageCountStyle: TextStyle(fontSize: 12),
      threadUnreadMessageCountBackgroundColor: Colors.red,
    );

    const themeData2 = StreamThreadListTileThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      threadChannelNameStyle: TextStyle(fontSize: 16),
      threadReplyToMessageStyle: TextStyle(fontSize: 14),
      threadLatestReplyUsernameStyle: TextStyle(fontSize: 14),
      threadLatestReplyMessageStyle: TextStyle(fontSize: 14),
      threadLatestReplyTimestampStyle: TextStyle(fontSize: 12),
      threadLatestReplyTimestampFormatter: _dummyFormatter,
      threadUnreadMessageCountStyle: TextStyle(fontSize: 12),
      threadUnreadMessageCountBackgroundColor: Colors.red,
    );

    const themeData3 = StreamThreadListTileThemeData(
      backgroundColor: Colors.blue, // Different color
      padding: EdgeInsets.all(8),
      threadChannelNameStyle: TextStyle(fontSize: 16),
      threadReplyToMessageStyle: TextStyle(fontSize: 14),
      threadLatestReplyUsernameStyle: TextStyle(fontSize: 14),
      threadLatestReplyMessageStyle: TextStyle(fontSize: 14),
      threadLatestReplyTimestampStyle: TextStyle(fontSize: 12),
      threadLatestReplyTimestampFormatter: _dummyFormatter,
      threadUnreadMessageCountStyle: TextStyle(fontSize: 12),
      threadUnreadMessageCountBackgroundColor: Colors.red,
    );

    // Same properties should be equal
    expect(themeData1, themeData2);
    // Different properties should not be equal
    expect(themeData1, isNot(themeData3));

    // Hash codes should match for equal objects
    expect(themeData1.hashCode, themeData2.hashCode);
  });

  test('StreamThreadListTileThemeData copyWith', () {
    const original = StreamThreadListTileThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      threadChannelNameStyle: TextStyle(fontSize: 16),
      threadReplyToMessageStyle: TextStyle(fontSize: 14),
      threadLatestReplyTimestampStyle: TextStyle(fontSize: 12),
      threadLatestReplyTimestampFormatter: _dummyFormatter,
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
    expect(copied.threadChannelNameStyle, original.threadChannelNameStyle);
    expect(copied.threadReplyToMessageStyle, original.threadReplyToMessageStyle);
    expect(copied.threadLatestReplyTimestampStyle, original.threadLatestReplyTimestampStyle);
    expect(copied.threadLatestReplyTimestampFormatter, original.threadLatestReplyTimestampFormatter);
  });

  test('StreamThreadListTileThemeData merge', () {
    const original = StreamThreadListTileThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      threadChannelNameStyle: TextStyle(fontSize: 16),
      threadReplyToMessageStyle: TextStyle(fontSize: 14),
      threadLatestReplyTimestampStyle: TextStyle(fontSize: 12),
      threadLatestReplyTimestampFormatter: _dummyFormatter,
    );

    const other = StreamThreadListTileThemeData(
      backgroundColor: Colors.blue,
      padding: EdgeInsets.all(16),
      // Other properties are null
    );

    final merged = original.merge(other);

    // Properties from 'other' should override 'original'
    expect(merged.backgroundColor, other.backgroundColor);
    expect(merged.padding, other.padding);
    // Null properties in 'other' should not override 'original'
    expect(merged.threadChannelNameStyle, original.threadChannelNameStyle);
    expect(merged.threadReplyToMessageStyle, original.threadReplyToMessageStyle);
    expect(merged.threadLatestReplyTimestampStyle, original.threadLatestReplyTimestampStyle);
    expect(merged.threadLatestReplyTimestampFormatter, original.threadLatestReplyTimestampFormatter);

    // Merging with null should return original
    final mergedWithNull = original.merge(null);
    expect(mergedWithNull, original);
  });

  test('StreamThreadListTileThemeData lerp', () {
    const data1 = StreamThreadListTileThemeData(
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(8),
      threadLatestReplyTimestampFormatter: _dummyFormatter,
    );

    const data2 = StreamThreadListTileThemeData(
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(16),
      threadLatestReplyTimestampFormatter: _dummyFormatter,
    );

    // t = 0 should return data1
    final lerpedAt0 = data1.lerp(data1, data2, 0);
    expect(lerpedAt0.backgroundColor, data1.backgroundColor);
    expect(lerpedAt0.padding, data1.padding);
    expect(lerpedAt0.threadLatestReplyTimestampFormatter, data1.threadLatestReplyTimestampFormatter);

    // t = 1 should return data2
    final lerpedAt1 = data1.lerp(data1, data2, 1);
    expect(lerpedAt1.backgroundColor, data2.backgroundColor);
    expect(lerpedAt1.padding, data2.padding);
    expect(lerpedAt1.threadLatestReplyTimestampFormatter, data2.threadLatestReplyTimestampFormatter);

    // t = 0.5 should return something in between
    final lerpedAt05 = data1.lerp(data1, data2, 0.5);
    expect(lerpedAt05.backgroundColor, Color.lerp(Colors.black, Colors.white, 0.5));
    expect(
      lerpedAt05.padding,
      EdgeInsetsGeometry.lerp(
        const EdgeInsets.all(8),
        const EdgeInsets.all(16),
        0.5,
      ),
    );
    // For t < 0.5, should use data1's formatter
    expect(lerpedAt05.threadLatestReplyTimestampFormatter, data1.threadLatestReplyTimestampFormatter);
  });
}
