import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('ChannelHeaderThemeData copyWith, ==, hashCode basics', () {
    expect(const ChannelHeaderThemeData(),
        const ChannelHeaderThemeData().copyWith());
    expect(const ChannelHeaderThemeData().hashCode,
        const ChannelHeaderThemeData().copyWith().hashCode);
  });

  group('ChannelHeaderThemeData lerps', () {
    test(
        '''Light ChannelHeaderThemeData lerps completely to dark ChannelHeaderThemeData''',
        () {
      expect(
          const ChannelHeaderThemeData()
              .lerp(_channelThemeControl, _channelThemeControlDark, 1),
          _channelThemeControlDark);
    });

    test(
        '''Light ChannelHeaderThemeData lerps halfway to dark ChannelHeaderThemeData''',
        () {
      expect(
          const ChannelHeaderThemeData()
              .lerp(_channelThemeControl, _channelThemeControlDark, 0.5),
          _channelThemeControlMidLerp);
    });

    test(
        '''Dark ChannelHeaderThemeData lerps completely to light ChannelHeaderThemeData''',
        () {
      expect(
          const ChannelHeaderThemeData()
              .lerp(_channelThemeControlDark, _channelThemeControl, 1),
          _channelThemeControl);
    });
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(_channelThemeControl.merge(_channelThemeControlDark),
        _channelThemeControlDark);
  });
}

final _channelThemeControl = ChannelHeaderThemeData(
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  color: const Color(0xff101418),
  titleStyle: TextTheme.light().headlineBold.copyWith(
        color: const Color(0xffffffff),
      ),
  subtitleStyle: TextTheme.light().footnote.copyWith(
        color: const Color(0xff7a7a7a),
      ),
);

final _channelThemeControlMidLerp = ChannelHeaderThemeData(
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  color: const Color(0xff101418),
  titleStyle: const TextStyle(
    color: Color(0xffffffff),
    fontWeight: FontWeight.bold,
    fontSize: 16,
  ),
  subtitleStyle: TextTheme.light().footnote.copyWith(
        color: const Color(0xff7a7a7a),
      ),
);

final _channelThemeControlDark = ChannelHeaderThemeData(
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  color: ColorTheme.dark().barsBg,
  titleStyle: TextTheme.dark().headlineBold,
  subtitleStyle: TextTheme.dark().footnote.copyWith(
        color: const Color(0xff7A7A7A),
      ),
);
