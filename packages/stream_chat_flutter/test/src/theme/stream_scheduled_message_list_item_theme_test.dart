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
    const scheduledAtStyle = TextStyle(fontSize: 12);
    late StreamScheduledMessageListItemThemeData theme;

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(
            scheduledMessageListItemTheme: const StreamScheduledMessageListItemThemeData(
              scheduledAtStyle: scheduledAtStyle,
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

    expect(theme.scheduledAtStyle, scheduledAtStyle);
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
      contentPadding: const EdgeInsets.all(16),
    );

    expect(copied.backgroundColor?.resolve({}), Colors.blue);
    expect(copied.contentPadding, const EdgeInsets.all(16));
  });

  test('StreamScheduledMessageListItemThemeData.copyWith keeps the other values', () {
    final original = _fullTheme();

    final copied = original.copyWith(backgroundColor: const WidgetStatePropertyAll(Colors.blue));

    expect(copied.channelNameStyle, original.channelNameStyle);
    expect(copied.scheduledAtFormatter, original.scheduledAtFormatter);
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

    expect(merged.channelNameStyle, original.channelNameStyle);
    expect(merged.scheduledAtFormatter, original.scheduledAtFormatter);
  });

  test('StreamScheduledMessageListItemThemeData.merge with null returns the same theme', () {
    final original = _fullTheme();

    expect(original.merge(null), original);
  });

  test('StreamScheduledMessageListItemThemeData.lerp at 0 returns the first theme', () {
    final lerped = StreamScheduledMessageListItemThemeData.lerp(_lerpStart, _lerpEnd, 0)!;

    expect(lerped.backgroundColor?.resolve({}), Colors.black);
    expect(lerped.contentPadding, _lerpStart.contentPadding);
    expect(lerped.scheduledAtFormatter, _lerpStart.scheduledAtFormatter);
  });

  test('StreamScheduledMessageListItemThemeData.lerp at 1 returns the second theme', () {
    final lerped = StreamScheduledMessageListItemThemeData.lerp(_lerpStart, _lerpEnd, 1)!;

    expect(lerped.backgroundColor?.resolve({}), Colors.white);
    expect(lerped.contentPadding, _lerpEnd.contentPadding);
    expect(lerped.scheduledAtFormatter, _lerpEnd.scheduledAtFormatter);
  });

  test('StreamScheduledMessageListItemThemeData.lerp halfway blends colors and content padding', () {
    final lerped = StreamScheduledMessageListItemThemeData.lerp(_lerpStart, _lerpEnd, 0.5)!;

    expect(lerped.backgroundColor?.resolve({}), Color.lerp(Colors.black, Colors.white, 0.5));
    expect(lerped.contentPadding, EdgeInsetsGeometry.lerp(const EdgeInsets.all(8), const EdgeInsets.all(16), 0.5));
  });

  test('StreamScheduledMessageListItemThemeData.lerp halfway takes the second formatter', () {
    final lerped = StreamScheduledMessageListItemThemeData.lerp(_lerpStart, _lerpEnd, 0.5)!;

    expect(lerped.scheduledAtFormatter, _lerpEnd.scheduledAtFormatter);
  });
}

StreamScheduledMessageListItemThemeData _fullTheme() {
  return const StreamScheduledMessageListItemThemeData(
    backgroundColor: WidgetStatePropertyAll(Colors.red),
    contentPadding: EdgeInsets.all(8),
    scheduledAtStyle: TextStyle(fontSize: 12),
    failedScheduledAtStyle: TextStyle(fontSize: 12),
    scheduledAtFormatter: _dummyFormatter,
    channelNameStyle: TextStyle(fontSize: 14),
    messagePreviewStyle: TextStyle(fontSize: 16),
    messagePreviewTextTheme: StreamMessagePreviewTextThemeData(iconSize: 20),
    statusStyle: TextStyle(fontSize: 12),
    failedStatusStyle: TextStyle(fontSize: 12),
  );
}

const _lerpStart = StreamScheduledMessageListItemThemeData(
  backgroundColor: WidgetStatePropertyAll(Colors.black),
  contentPadding: EdgeInsets.all(8),
  scheduledAtFormatter: _dummyFormatter,
);

const _lerpEnd = StreamScheduledMessageListItemThemeData(
  backgroundColor: WidgetStatePropertyAll(Colors.white),
  contentPadding: EdgeInsets.all(16),
  scheduledAtFormatter: _otherFormatter,
);

String _dummyFormatter(BuildContext context, DateTime date) => 'formatted';

String _otherFormatter(BuildContext context, DateTime date) => 'other';
