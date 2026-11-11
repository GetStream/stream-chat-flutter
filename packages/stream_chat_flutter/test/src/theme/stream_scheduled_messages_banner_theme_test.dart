import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  testWidgets('StreamScheduledMessagesBannerTheme.of prefers local values over the app-wide theme', (tester) async {
    late StreamScheduledMessagesBannerThemeData theme;

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(
            scheduledMessagesBannerTheme: const StreamScheduledMessagesBannerThemeData(
              backgroundColor: Colors.blue,
            ),
          ),
          child: StreamScheduledMessagesBannerTheme(
            data: const StreamScheduledMessagesBannerThemeData(backgroundColor: Colors.red),
            child: Builder(
              builder: (context) {
                theme = StreamScheduledMessagesBannerTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );

    expect(theme.backgroundColor, Colors.red);
  });

  testWidgets('StreamScheduledMessagesBannerTheme.of keeps app-wide values the local theme leaves unset', (
    tester,
  ) async {
    const viewAllStyle = TextStyle(fontSize: 12);
    late StreamScheduledMessagesBannerThemeData theme;

    await tester.pumpWidget(
      MaterialApp(
        home: StreamChatTheme(
          data: StreamChatThemeData(
            scheduledMessagesBannerTheme: const StreamScheduledMessagesBannerThemeData(
              viewAllStyle: viewAllStyle,
            ),
          ),
          child: StreamScheduledMessagesBannerTheme(
            data: const StreamScheduledMessagesBannerThemeData(backgroundColor: Colors.red),
            child: Builder(
              builder: (context) {
                theme = StreamScheduledMessagesBannerTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );

    expect(theme.viewAllStyle, viewAllStyle);
  });

  test('StreamScheduledMessagesBannerThemeData with the same values are equal', () {
    expect(_fullTheme(), _fullTheme());
  });

  test('StreamScheduledMessagesBannerThemeData with the same values share a hash code', () {
    expect(_fullTheme().hashCode, _fullTheme().hashCode);
  });

  test('StreamScheduledMessagesBannerThemeData with a different value are not equal', () {
    expect(_fullTheme(), isNot(_fullTheme().copyWith(backgroundColor: Colors.blue)));
  });

  test('StreamScheduledMessagesBannerThemeData.copyWith replaces the given values', () {
    final copied = _fullTheme().copyWith(backgroundColor: Colors.blue, padding: const EdgeInsets.all(16));

    expect(copied.backgroundColor, Colors.blue);
    expect(copied.padding, const EdgeInsets.all(16));
  });

  test('StreamScheduledMessagesBannerThemeData.copyWith keeps the other values', () {
    final original = _fullTheme();

    final copied = original.copyWith(backgroundColor: Colors.blue);

    expect(copied.side, original.side);
    expect(copied.boxShadow, original.boxShadow);
  });

  test('StreamScheduledMessagesBannerThemeData.merge takes the values the other theme sets', () {
    const other = StreamScheduledMessagesBannerThemeData(backgroundColor: Colors.blue);

    final merged = _fullTheme().merge(other);

    expect(merged.backgroundColor, Colors.blue);
  });

  test('StreamScheduledMessagesBannerThemeData.merge keeps the values the other theme leaves unset', () {
    final original = _fullTheme();
    const other = StreamScheduledMessagesBannerThemeData(backgroundColor: Colors.blue);

    final merged = original.merge(other);

    expect(merged.side, original.side);
    expect(merged.countStyle, original.countStyle);
  });

  test('StreamScheduledMessagesBannerThemeData.merge with null returns the same theme', () {
    final original = _fullTheme();

    expect(original.merge(null), original);
  });

  test('StreamScheduledMessagesBannerThemeData.lerp at 0 returns the first theme', () {
    final lerped = StreamScheduledMessagesBannerThemeData.lerp(_lerpStart, _lerpEnd, 0)!;

    expect(lerped.backgroundColor, _lerpStart.backgroundColor);
    expect(lerped.side, _lerpStart.side);
    expect(lerped.boxShadow, _lerpStart.boxShadow);
  });

  test('StreamScheduledMessagesBannerThemeData.lerp at 1 returns the second theme', () {
    final lerped = StreamScheduledMessagesBannerThemeData.lerp(_lerpStart, _lerpEnd, 1)!;

    expect(lerped.backgroundColor, _lerpEnd.backgroundColor);
    expect(lerped.side, _lerpEnd.side);
    expect(lerped.boxShadow, _lerpEnd.boxShadow);
  });

  test('StreamScheduledMessagesBannerThemeData.lerp halfway blends colors and the border', () {
    final lerped = StreamScheduledMessagesBannerThemeData.lerp(_lerpStart, _lerpEnd, 0.5)!;

    expect(lerped.backgroundColor, Color.lerp(Colors.black, Colors.white, 0.5));
    expect(lerped.side, BorderSide.lerp(_lerpStart.side!, _lerpEnd.side!, 0.5));
  });

  test('StreamScheduledMessagesBannerThemeData.lerp halfway takes the second shadow', () {
    final lerped = StreamScheduledMessagesBannerThemeData.lerp(_lerpStart, _lerpEnd, 0.5)!;

    expect(lerped.boxShadow, _lerpEnd.boxShadow);
  });
}

// A new instance on each call, so equality compares values rather than one
// canonical const instance.
StreamScheduledMessagesBannerThemeData _fullTheme() {
  // ignore: prefer_const_constructors
  return StreamScheduledMessagesBannerThemeData(
    backgroundColor: Colors.red,
    side: const BorderSide(color: Colors.grey),
    // Shared, as the theme compares its shadow list by identity.
    boxShadow: const [BoxShadow(blurRadius: 4)],
    padding: const EdgeInsets.all(8),
    countStyle: const TextStyle(fontSize: 14),
    viewAllStyle: const TextStyle(fontSize: 12),
    iconColor: Colors.blue,
    failedIconColor: Colors.orange,
  );
}

const _lerpStart = StreamScheduledMessagesBannerThemeData(
  backgroundColor: Colors.black,
  side: BorderSide(color: Colors.black),
  boxShadow: [BoxShadow(blurRadius: 4)],
);

const _lerpEnd = StreamScheduledMessagesBannerThemeData(
  backgroundColor: Colors.white,
  side: BorderSide(color: Colors.white, width: 3),
  boxShadow: [BoxShadow(blurRadius: 12)],
);
