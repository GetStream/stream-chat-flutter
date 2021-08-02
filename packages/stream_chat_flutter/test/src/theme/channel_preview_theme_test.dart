import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('ChannelPreviewThemeData copyWith, ==, hashCode basics', () {
    expect(const ChannelPreviewThemeData(),
        const ChannelPreviewThemeData().copyWith());
    expect(const ChannelPreviewThemeData().hashCode,
        const ChannelPreviewThemeData().copyWith().hashCode);
  });

  group('ChannelPreviewThemeData lerps', () {
    test(
        '''Light ChannelPreviewThemeData lerps completely to dark ChannelPreviewThemeData''',
        () {
      expect(
          const ChannelPreviewThemeData().lerp(
              _channelPreviewThemeControl, _channelPreviewThemeControlDark, 1),
          _channelPreviewThemeControlDark);
    });

    test(
        '''Light ChannelPreviewThemeData lerps halfway to dark ChannelPreviewThemeData''',
        () {
      expect(
          const ChannelPreviewThemeData().lerp(_channelPreviewThemeControl,
              _channelPreviewThemeControlDark, 0.5),
          _channelPreviewThemeControlMidLerp);
    });

    test(
        '''Dark ChannelPreviewThemeData lerps completely to light ChannelPreviewThemeData''',
        () {
      expect(
          const ChannelPreviewThemeData().lerp(
              _channelPreviewThemeControlDark, _channelPreviewThemeControl, 1),
          _channelPreviewThemeControl);
    });
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(_channelPreviewThemeControl.merge(_channelPreviewThemeControlDark),
        _channelPreviewThemeControlDark);
  });
}

final _channelPreviewThemeControl = ChannelPreviewThemeData(
  unreadCounterColor: ColorTheme.light().accentError,
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  titleStyle: TextTheme.light().bodyBold,
  subtitleStyle: TextTheme.light().footnote.copyWith(
        color: const Color(0xff7A7A7A),
      ),
  lastMessageAtStyle: TextTheme.light().footnote.copyWith(
        color: ColorTheme.light().textHighEmphasis.withOpacity(.5),
      ),
  indicatorIconSize: 16,
);

final _channelPreviewThemeControlMidLerp = ChannelPreviewThemeData(
  unreadCounterColor: const Color(0xffff3842),
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  titleStyle: const TextStyle(
    color: Color(0xff000000),
    fontSize: 14,
    fontWeight: FontWeight.bold,
  ),
  subtitleStyle: const TextStyle(
    color: Color(0xff7a7a7a),
    fontSize: 12,
  ),
  lastMessageAtStyle: TextTheme.light().footnote.copyWith(
        color: Color(0x80000000).withOpacity(.5),
      ),
  indicatorIconSize: 16,
);

final _channelPreviewThemeControlDark = ChannelPreviewThemeData(
  unreadCounterColor: ColorTheme.dark().accentError,
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  titleStyle: TextTheme.dark().bodyBold,
  subtitleStyle: TextTheme.dark().footnote.copyWith(
        color: const Color(0xff7A7A7A),
      ),
  lastMessageAtStyle: TextTheme.dark().footnote.copyWith(
        color: ColorTheme.dark().textHighEmphasis.withOpacity(.5),
      ),
  indicatorIconSize: 16,
);
