import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('StreamScheduledMessageListItemTheme.of prefers local values over the app-wide theme', (tester) async {
    late StreamScheduledMessageListItemThemeData theme;

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(
            scheduledMessageListItemTheme: const StreamScheduledMessageListItemThemeData(
              backgroundColor: WidgetStatePropertyAll(Colors.blue),
            ),
          ),
          child: StreamScheduledMessageListItemTheme(
            data: const StreamScheduledMessageListItemThemeData(backgroundColor: WidgetStatePropertyAll(Colors.red)),
            child: Builder(
              builder: (context) {
                theme = StreamScheduledMessageListItemTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );

    expect(theme.backgroundColor?.resolve({}), Colors.red);
  });

  testWidgets('StreamScheduledMessageListItemTheme.of keeps app-wide values the local theme leaves unset', (
    tester,
  ) async {
    const sendTimeStyle = TextStyle(fontSize: 12);
    late StreamScheduledMessageListItemThemeData theme;

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(
            scheduledMessageListItemTheme: const StreamScheduledMessageListItemThemeData(
              sendTimeStyle: sendTimeStyle,
            ),
          ),
          child: StreamScheduledMessageListItemTheme(
            data: const StreamScheduledMessageListItemThemeData(backgroundColor: WidgetStatePropertyAll(Colors.red)),
            child: Builder(
              builder: (context) {
                theme = StreamScheduledMessageListItemTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );

    expect(theme.sendTimeStyle, sendTimeStyle);
  });

  test('StreamScheduledMessageListItemThemeData with the same values are equal', () {
    expect(_fullTheme(), _fullTheme());
  });

  test('StreamScheduledMessageListItemThemeData with the same values share a hash code', () {
    expect(_fullTheme().hashCode, _fullTheme().hashCode);
  });

  test('StreamScheduledMessageListItemThemeData with a different value are not equal', () {
    expect(_fullTheme(), isNot(_fullTheme().copyWith(backgroundColor: const WidgetStatePropertyAll(Colors.blue))));
  });

  test('StreamScheduledMessageListItemThemeData.copyWith replaces the given values', () {
    final copied = _fullTheme().copyWith(
      backgroundColor: const WidgetStatePropertyAll(Colors.blue),
      padding: const EdgeInsets.all(16),
    );

    expect(copied.backgroundColor?.resolve({}), Colors.blue);
    expect(copied.padding, const EdgeInsets.all(16));
  });

  test('StreamScheduledMessageListItemThemeData.copyWith keeps the other values', () {
    final original = _fullTheme();

    final copied = original.copyWith(backgroundColor: const WidgetStatePropertyAll(Colors.blue));

    expect(copied.titleStyle, original.titleStyle);
    expect(copied.sendTimeFormatter, original.sendTimeFormatter);
  });

  test('StreamScheduledMessageListItemThemeData.merge takes the values the other theme sets', () {
    const other = StreamScheduledMessageListItemThemeData(backgroundColor: WidgetStatePropertyAll(Colors.blue));

    final merged = _fullTheme().merge(other);

    expect(merged.backgroundColor?.resolve({}), Colors.blue);
  });

  test('StreamScheduledMessageListItemThemeData.merge keeps the values the other theme leaves unset', () {
    final original = _fullTheme();
    const other = StreamScheduledMessageListItemThemeData(backgroundColor: WidgetStatePropertyAll(Colors.blue));

    final merged = original.merge(other);

    expect(merged.titleStyle, original.titleStyle);
    expect(merged.sendTimeFormatter, original.sendTimeFormatter);
  });

  test('StreamScheduledMessageListItemThemeData.merge with null returns the same theme', () {
    final original = _fullTheme();

    expect(original.merge(null), original);
  });

  test('StreamScheduledMessageListItemThemeData.lerp at 0 returns the first theme', () {
    final lerped = StreamScheduledMessageListItemThemeData.lerp(_lerpStart, _lerpEnd, 0)!;

    expect(lerped.backgroundColor?.resolve({}), Colors.black);
    expect(lerped.padding, _lerpStart.padding);
    expect(lerped.sendTimeFormatter, _lerpStart.sendTimeFormatter);
  });

  test('StreamScheduledMessageListItemThemeData.lerp at 1 returns the second theme', () {
    final lerped = StreamScheduledMessageListItemThemeData.lerp(_lerpStart, _lerpEnd, 1)!;

    expect(lerped.backgroundColor?.resolve({}), Colors.white);
    expect(lerped.padding, _lerpEnd.padding);
    expect(lerped.sendTimeFormatter, _lerpEnd.sendTimeFormatter);
  });

  test('StreamScheduledMessageListItemThemeData.lerp halfway blends colors and padding', () {
    final lerped = StreamScheduledMessageListItemThemeData.lerp(_lerpStart, _lerpEnd, 0.5)!;

    expect(lerped.backgroundColor?.resolve({}), Color.lerp(Colors.black, Colors.white, 0.5));
    expect(lerped.padding, EdgeInsetsGeometry.lerp(const EdgeInsets.all(8), const EdgeInsets.all(16), 0.5));
  });

  test('StreamScheduledMessageListItemThemeData.lerp halfway takes the second formatter', () {
    final lerped = StreamScheduledMessageListItemThemeData.lerp(_lerpStart, _lerpEnd, 0.5)!;

    expect(lerped.sendTimeFormatter, _lerpEnd.sendTimeFormatter);
  });
}

StreamScheduledMessageListItemThemeData _fullTheme() {
  return const StreamScheduledMessageListItemThemeData(
    backgroundColor: WidgetStatePropertyAll(Colors.red),
    padding: EdgeInsets.all(8),
    sendTimeStyle: TextStyle(fontSize: 12),
    failedSendTimeStyle: TextStyle(fontSize: 12),
    sendTimeFormatter: _dummyFormatter,
    titleStyle: TextStyle(fontSize: 14),
    messagePreviewStyle: TextStyle(fontSize: 16),
    messagePreviewTextTheme: StreamMessagePreviewTextThemeData(iconSize: 20),
    statusStyle: TextStyle(fontSize: 12),
    failedStatusStyle: TextStyle(fontSize: 12),
  );
}

const _lerpStart = StreamScheduledMessageListItemThemeData(
  backgroundColor: WidgetStatePropertyAll(Colors.black),
  padding: EdgeInsets.all(8),
  sendTimeFormatter: _dummyFormatter,
);

const _lerpEnd = StreamScheduledMessageListItemThemeData(
  backgroundColor: WidgetStatePropertyAll(Colors.white),
  padding: EdgeInsets.all(16),
  sendTimeFormatter: _otherFormatter,
);

String _dummyFormatter(BuildContext context, DateTime date) => 'formatted';

String _otherFormatter(BuildContext context, DateTime date) => 'other';
