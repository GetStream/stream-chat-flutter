import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('StreamScheduledMessageListItemTheme merges with ancestor theme', (tester) async {
    const backgroundColor = Colors.blue;
    const childBackgroundColor = Colors.red;
    const sendTimeStyle = TextStyle(fontSize: 12);

    late BuildContext capturedContext;

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(
            scheduledMessageListItemTheme: const StreamScheduledMessageListItemThemeData(
              backgroundColor: backgroundColor,
              sendTimeStyle: sendTimeStyle,
            ),
          ),
          child: Builder(
            builder: (context) {
              return StreamScheduledMessageListItemTheme(
                data: const StreamScheduledMessageListItemThemeData(
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

    final theme = StreamScheduledMessageListItemTheme.of(capturedContext);
    expect(theme.backgroundColor, childBackgroundColor);
    expect(theme.sendTimeStyle, sendTimeStyle);
  });

  test('StreamScheduledMessageListItemThemeData equality', () {
    const themeData1 = StreamScheduledMessageListItemThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      sendTimeStyle: TextStyle(fontSize: 12),
      failedSendTimeStyle: TextStyle(fontSize: 12),
      sendTimeFormatter: _dummyFormatter,
      titleStyle: TextStyle(fontSize: 14),
      previewStyle: TextStyle(fontSize: 16),
      previewTextTheme: StreamMessagePreviewTextThemeData(iconSize: 20),
      statusStyle: TextStyle(fontSize: 12),
      failedStatusStyle: TextStyle(fontSize: 12),
    );

    const themeData2 = StreamScheduledMessageListItemThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      sendTimeStyle: TextStyle(fontSize: 12),
      failedSendTimeStyle: TextStyle(fontSize: 12),
      sendTimeFormatter: _dummyFormatter,
      titleStyle: TextStyle(fontSize: 14),
      previewStyle: TextStyle(fontSize: 16),
      previewTextTheme: StreamMessagePreviewTextThemeData(iconSize: 20),
      statusStyle: TextStyle(fontSize: 12),
      failedStatusStyle: TextStyle(fontSize: 12),
    );

    const themeData3 = StreamScheduledMessageListItemThemeData(
      backgroundColor: Colors.blue, // Different color
      padding: EdgeInsets.all(8),
      sendTimeStyle: TextStyle(fontSize: 12),
      failedSendTimeStyle: TextStyle(fontSize: 12),
      sendTimeFormatter: _dummyFormatter,
      titleStyle: TextStyle(fontSize: 14),
      previewStyle: TextStyle(fontSize: 16),
      previewTextTheme: StreamMessagePreviewTextThemeData(iconSize: 20),
      statusStyle: TextStyle(fontSize: 12),
      failedStatusStyle: TextStyle(fontSize: 12),
    );

    // Same properties should be equal
    expect(themeData1, themeData2);
    // Different properties should not be equal
    expect(themeData1, isNot(themeData3));

    // Hash codes should match for equal objects
    expect(themeData1.hashCode, themeData2.hashCode);
  });

  test('StreamScheduledMessageListItemThemeData copyWith', () {
    const original = StreamScheduledMessageListItemThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      titleStyle: TextStyle(fontSize: 14),
      sendTimeFormatter: _dummyFormatter,
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
    expect(copied.titleStyle, original.titleStyle);
    expect(copied.sendTimeFormatter, original.sendTimeFormatter);
  });

  test('StreamScheduledMessageListItemThemeData merge', () {
    const original = StreamScheduledMessageListItemThemeData(
      backgroundColor: Colors.red,
      padding: EdgeInsets.all(8),
      titleStyle: TextStyle(fontSize: 14),
      sendTimeFormatter: _dummyFormatter,
    );

    const other = StreamScheduledMessageListItemThemeData(
      backgroundColor: Colors.blue,
      padding: EdgeInsets.all(16),
      // Other properties are null
    );

    final merged = original.merge(other);

    // Properties from 'other' should override 'original'
    expect(merged.backgroundColor, other.backgroundColor);
    expect(merged.padding, other.padding);
    // Null properties in 'other' should not override 'original'
    expect(merged.titleStyle, original.titleStyle);
    expect(merged.sendTimeFormatter, original.sendTimeFormatter);

    // Merging with null should return original
    final mergedWithNull = original.merge(null);
    expect(mergedWithNull, original);
  });

  test('StreamScheduledMessageListItemThemeData lerp', () {
    const data1 = StreamScheduledMessageListItemThemeData(
      backgroundColor: Colors.black,
      padding: EdgeInsets.all(8),
      sendTimeFormatter: _dummyFormatter,
    );

    const data2 = StreamScheduledMessageListItemThemeData(
      backgroundColor: Colors.white,
      padding: EdgeInsets.all(16),
      sendTimeFormatter: _otherFormatter,
    );

    // t = 0 should return data1
    final lerpedAt0 = StreamScheduledMessageListItemThemeData.lerp(data1, data2, 0)!;
    expect(lerpedAt0.backgroundColor, data1.backgroundColor);
    expect(lerpedAt0.padding, data1.padding);
    expect(lerpedAt0.sendTimeFormatter, data1.sendTimeFormatter);

    // t = 1 should return data2
    final lerpedAt1 = StreamScheduledMessageListItemThemeData.lerp(data1, data2, 1)!;
    expect(lerpedAt1.backgroundColor, data2.backgroundColor);
    expect(lerpedAt1.padding, data2.padding);
    expect(lerpedAt1.sendTimeFormatter, data2.sendTimeFormatter);

    // t = 0.5 should return something in between
    final lerpedAt05 = StreamScheduledMessageListItemThemeData.lerp(data1, data2, 0.5)!;
    expect(lerpedAt05.backgroundColor, Color.lerp(Colors.black, Colors.white, 0.5));
    expect(
      lerpedAt05.padding,
      EdgeInsetsGeometry.lerp(
        const EdgeInsets.all(8),
        const EdgeInsets.all(16),
        0.5,
      ),
    );
    expect(lerpedAt05.sendTimeFormatter, data2.sendTimeFormatter);
  });
}

String _dummyFormatter(BuildContext context, DateTime date) => 'formatted';

String _otherFormatter(BuildContext context, DateTime date) => 'other';
