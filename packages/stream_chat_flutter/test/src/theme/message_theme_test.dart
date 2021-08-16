import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('MessageThemeData copyWith, ==, hashCode basics', () {
    expect(const MessageThemeData(), const MessageThemeData().copyWith());
    expect(const MessageThemeData().hashCode,
        const MessageThemeData().copyWith().hashCode);
  });

  group('MessageThemeData lerps', () {
    test('''Light MessageThemeData lerps completely to dark MessageThemeData''',
        () {
      expect(
          const MessageThemeData()
              .lerp(_messageThemeControl, _messageThemeControlDark, 1),
          _messageThemeControlDark);
    });

    test('''Dark MessageThemeData lerps completely to light MessageThemeData''',
        () {
      expect(
          const MessageThemeData()
              .lerp(_messageThemeControlDark, _messageThemeControl, 1),
          _messageThemeControl);
    });
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(_messageThemeControl.merge(_messageThemeControlDark),
        _messageThemeControlDark);
  });
}

final _messageThemeControl = MessageThemeData(
  messageAuthorStyle: TextTheme.light().footnote.copyWith(
        color: ColorTheme.light().textLowEmphasis,
      ),
  messageTextStyle: TextTheme.light().body,
  createdAtStyle: TextTheme.light().footnote.copyWith(
        color: ColorTheme.light().textLowEmphasis,
      ),
  repliesStyle: TextTheme.light().footnoteBold.copyWith(
        color: ColorTheme.light().accentPrimary,
      ),
  messageBackgroundColor: ColorTheme.light().disabled,
  reactionsBackgroundColor: ColorTheme.light().barsBg,
  reactionsBorderColor: ColorTheme.light().borders,
  reactionsMaskColor: ColorTheme.light().appBg,
  messageBorderColor: ColorTheme.light().disabled,
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 32,
      width: 32,
    ),
  ),
  messageLinksStyle: TextStyle(
    color: ColorTheme.light().accentPrimary,
  ),
);

final _messageThemeControlDark = MessageThemeData(
  messageAuthorStyle: TextTheme.dark().footnote.copyWith(
        color: ColorTheme.dark().textLowEmphasis,
      ),
  messageTextStyle: TextTheme.dark().body,
  createdAtStyle: TextTheme.dark().footnote.copyWith(
        color: ColorTheme.dark().textLowEmphasis,
      ),
  repliesStyle: TextTheme.dark().footnoteBold.copyWith(
        color: ColorTheme.dark().accentPrimary,
      ),
  messageBackgroundColor: ColorTheme.dark().disabled,
  reactionsBackgroundColor: ColorTheme.dark().barsBg,
  reactionsBorderColor: ColorTheme.dark().borders,
  reactionsMaskColor: ColorTheme.dark().appBg,
  messageBorderColor: ColorTheme.dark().disabled,
  avatarTheme: AvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 32,
      width: 32,
    ),
  ),
  messageLinksStyle: TextStyle(
    color: ColorTheme.dark().accentPrimary,
  ),
);
