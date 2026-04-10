import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('ChannelHeaderThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamChannelHeaderThemeData(), const StreamChannelHeaderThemeData().copyWith());
    expect(const StreamChannelHeaderThemeData().hashCode, const StreamChannelHeaderThemeData().copyWith().hashCode);
  });

  group('ChannelHeaderThemeData lerps', () {
    test('''Light ChannelHeaderThemeData lerps completely to dark ChannelHeaderThemeData''', () {
      expect(
        const StreamChannelHeaderThemeData().lerp(_channelThemeControl, _channelThemeControlDark, 1),
        _channelThemeControlDark,
      );
    });

    test('''Light ChannelHeaderThemeData lerps halfway to dark ChannelHeaderThemeData''', () {
      expect(
        const StreamChannelHeaderThemeData().lerp(
          _channelThemeControl,
          _channelThemeControlDark,
          0.5,
        ),
        _channelThemeControlMidLerp,
        // TODO: Remove skip, once we drop support for flutter v3.24.0
        skip: true,
        reason: 'Currently failing in flutter v3.27.0 due to new color alpha',
      );
    });

    test('''Dark ChannelHeaderThemeData lerps completely to light ChannelHeaderThemeData''', () {
      expect(
        const StreamChannelHeaderThemeData().lerp(_channelThemeControlDark, _channelThemeControl, 1),
        _channelThemeControl,
      );
    });
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(_channelThemeControl.merge(_channelThemeControlDark), _channelThemeControlDark);
  });
}

final _channelThemeControl = StreamChannelHeaderThemeData(
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  color: const Color(0xff101418),
  titleStyle: const StreamTextTheme.light().headlineBold.copyWith(
    color: const Color(0xffffffff),
  ),
  subtitleStyle: const StreamTextTheme.light().footnote.copyWith(
    color: const Color(0xff7a7a7a),
  ),
);

final _channelThemeControlMidLerp = StreamChannelHeaderThemeData(
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  color: const Color(0xff111417),
  titleStyle: const TextStyle(
    color: Color(0xffffffff),
    fontWeight: FontWeight.w500,
    fontSize: 16,
  ),
  subtitleStyle: const StreamTextTheme.light().footnote.copyWith(
    color: const Color(0xff7a7a7a),
  ),
);

final _channelThemeControlDark = StreamChannelHeaderThemeData(
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  color: const StreamColorTheme.dark().barsBg,
  titleStyle: const StreamTextTheme.dark().headlineBold,
  subtitleStyle: const StreamTextTheme.dark().footnote.copyWith(
    color: const Color(0xff7A7A7A),
  ),
);
