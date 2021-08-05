import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('ChannelListHeaderThemeData copyWith, ==, hashCode basics', () {
    expect(const ChannelListHeaderThemeData(),
        const ChannelListHeaderThemeData().copyWith());
    expect(const ChannelListHeaderThemeData().hashCode,
        const ChannelListHeaderThemeData().copyWith().hashCode);
  });

  group('ChannelListHeaderThemeData lerps', () {
    test(
        '''Light ChannelListHeaderThemeData lerps completely to dark ChannelListHeaderThemeData''',
        () {
      expect(
          const ChannelListHeaderThemeData().lerp(
              _channelListHeaderThemeControl,
              _channelListHeaderThemeControlDark,
              1),
          _channelListHeaderThemeControlDark);
    });

    test(
        '''Light ChannelListHeaderThemeData lerps halfway to dark ChannelListHeaderThemeData''',
        () {
      expect(
          const ChannelListHeaderThemeData().lerp(
              _channelListHeaderThemeControl,
              _channelListHeaderThemeControlDark,
              0.5),
          _channelListHeaderThemeControlMidLerp);
    });

    test(
        '''Dark ChannelListHeaderThemeData lerps completely to light ChannelListHeaderThemeData''',
        () {
      expect(
          const ChannelListHeaderThemeData().lerp(
              _channelListHeaderThemeControlDark,
              _channelListHeaderThemeControl,
              1),
          _channelListHeaderThemeControl);
    });
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(
        _channelListHeaderThemeControl
            .merge(_channelListHeaderThemeControlDark),
        _channelListHeaderThemeControlDark);
  });
}

final _channelListHeaderThemeControl = ChannelListHeaderThemeData(
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  color: ColorTheme.light().barsBg,
  titleStyle: TextTheme.light().headlineBold,
);

final _channelListHeaderThemeControlMidLerp = ChannelListHeaderThemeData(
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  color: const Color(0xff87898b),
  titleStyle: const TextStyle(
    color: Color(0xff7f7f7f),
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
);

final _channelListHeaderThemeControlDark = ChannelListHeaderThemeData(
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  color: ColorTheme.dark().barsBg,
  titleStyle: TextTheme.dark().headlineBold,
);
