import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

String _dummyFormatter(BuildContext context, DateTime date) => 'formatted';

void main() {
  test('ChannelPreviewThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamChannelPreviewThemeData(), const StreamChannelPreviewThemeData().copyWith());
    expect(const StreamChannelPreviewThemeData().hashCode, const StreamChannelPreviewThemeData().copyWith().hashCode);
  });

  group('ChannelPreviewThemeData lerps', () {
    test('''Light ChannelPreviewThemeData lerps completely to dark ChannelPreviewThemeData''', () {
      expect(
        const StreamChannelPreviewThemeData().lerp(_channelPreviewThemeControl, _channelPreviewThemeControlDark, 1),
        _channelPreviewThemeControlDark,
      );
    });

    test('''Light ChannelPreviewThemeData lerps halfway to dark ChannelPreviewThemeData''', () {
      expect(
        const StreamChannelPreviewThemeData().lerp(
          _channelPreviewThemeControl,
          _channelPreviewThemeControlDark,
          0.5,
        ),
        _channelPreviewThemeControlMidLerp,
        // TODO: Remove skip, once we drop support for flutter v3.24.0
        skip: true,
        reason: 'Currently failing in flutter v3.27.0 due to new color alpha',
      );
    });

    test('''Dark ChannelPreviewThemeData lerps completely to light ChannelPreviewThemeData''', () {
      expect(
        const StreamChannelPreviewThemeData().lerp(_channelPreviewThemeControlDark, _channelPreviewThemeControl, 1),
        _channelPreviewThemeControl,
      );
    });
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(_channelPreviewThemeControl.merge(_channelPreviewThemeControlDark), _channelPreviewThemeControlDark);
  });
}

final _channelPreviewThemeControl = StreamChannelPreviewThemeData(
  unreadCounterColor: const StreamColorTheme.light().accentError,
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  titleStyle: const StreamTextTheme.light().bodyBold,
  subtitleStyle: const StreamTextTheme.light().footnote.copyWith(
    color: const Color(0xff7A7A7A),
  ),
  lastMessageAtStyle: const StreamTextTheme.light().footnote.copyWith(
    // ignore: deprecated_member_use
    color: const StreamColorTheme.light().textHighEmphasis.withOpacity(0.5),
  ),
  lastMessageAtFormatter: _dummyFormatter,
  indicatorIconSize: 16,
);

final _channelPreviewThemeControlMidLerp = StreamChannelPreviewThemeData(
  unreadCounterColor: const Color(0xffff3742),
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  titleStyle: const TextStyle(
    color: Color(0xff7f7f7f),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  subtitleStyle: const TextStyle(
    color: Color(0xff7a7a7a),
    fontSize: 12,
    fontWeight: FontWeight.w400,
  ),
  lastMessageAtStyle: const StreamTextTheme.light().footnote.copyWith(
    // ignore: deprecated_member_use
    color: const Color(0x807f7f7f).withOpacity(0.5),
  ),
  lastMessageAtFormatter: _dummyFormatter,
  indicatorIconSize: 16,
);

final _channelPreviewThemeControlDark = StreamChannelPreviewThemeData(
  unreadCounterColor: const StreamColorTheme.dark().accentError,
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 40,
      width: 40,
    ),
  ),
  titleStyle: const StreamTextTheme.dark().bodyBold,
  subtitleStyle: const StreamTextTheme.dark().footnote.copyWith(
    color: const Color(0xff7A7A7A),
  ),
  lastMessageAtStyle: const StreamTextTheme.dark().footnote.copyWith(
    // ignore: deprecated_member_use
    color: const StreamColorTheme.dark().textHighEmphasis.withOpacity(0.5),
  ),
  lastMessageAtFormatter: _dummyFormatter,
  indicatorIconSize: 16,
);
