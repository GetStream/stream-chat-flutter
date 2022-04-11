import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('MessageThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamMessageThemeData(),
        const StreamMessageThemeData().copyWith());
    expect(const StreamMessageThemeData().hashCode,
        const StreamMessageThemeData().copyWith().hashCode);
  });

  group('MessageThemeData lerps', () {
    test('''Light MessageThemeData lerps completely to dark MessageThemeData''',
        () {
      expect(
          const StreamMessageThemeData()
              .lerp(_messageThemeControl, _messageThemeControlDark, 1),
          _messageThemeControlDark);
    });

    test('''Dark MessageThemeData lerps completely to light MessageThemeData''',
        () {
      expect(
          const StreamMessageThemeData()
              .lerp(_messageThemeControlDark, _messageThemeControl, 1),
          _messageThemeControl);
    });
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(_messageThemeControl.merge(_messageThemeControlDark),
        _messageThemeControlDark);
  });
}

final _messageThemeControl = StreamMessageThemeData(
  messageAuthorStyle: StreamTextTheme.light().footnote.copyWith(
        color: StreamColorTheme.light().textLowEmphasis,
      ),
  messageTextStyle: StreamTextTheme.light().body,
  createdAtStyle: StreamTextTheme.light().footnote.copyWith(
        color: StreamColorTheme.light().textLowEmphasis,
      ),
  repliesStyle: StreamTextTheme.light().footnoteBold.copyWith(
        color: StreamColorTheme.light().accentPrimary,
      ),
  messageBackgroundColor: StreamColorTheme.light().disabled,
  reactionsBackgroundColor: StreamColorTheme.light().barsBg,
  reactionsBorderColor: StreamColorTheme.light().borders,
  reactionsMaskColor: StreamColorTheme.light().appBg,
  messageBorderColor: StreamColorTheme.light().disabled,
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 32,
      width: 32,
    ),
  ),
  messageLinksStyle: TextStyle(
    color: StreamColorTheme.light().accentPrimary,
  ),
  linkBackgroundColor: StreamColorTheme.light().linkBg,
);

final _messageThemeControlDark = StreamMessageThemeData(
  messageAuthorStyle: StreamTextTheme.dark().footnote.copyWith(
        color: StreamColorTheme.dark().textLowEmphasis,
      ),
  messageTextStyle: StreamTextTheme.dark().body,
  createdAtStyle: StreamTextTheme.dark().footnote.copyWith(
        color: StreamColorTheme.dark().textLowEmphasis,
      ),
  repliesStyle: StreamTextTheme.dark().footnoteBold.copyWith(
        color: StreamColorTheme.dark().accentPrimary,
      ),
  messageBackgroundColor: StreamColorTheme.dark().disabled,
  reactionsBackgroundColor: StreamColorTheme.dark().barsBg,
  reactionsBorderColor: StreamColorTheme.dark().borders,
  reactionsMaskColor: StreamColorTheme.dark().appBg,
  messageBorderColor: StreamColorTheme.dark().disabled,
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 32,
      width: 32,
    ),
  ),
  messageLinksStyle: TextStyle(
    color: StreamColorTheme.dark().accentPrimary,
  ),
  linkBackgroundColor: StreamColorTheme.dark().linkBg,
);
