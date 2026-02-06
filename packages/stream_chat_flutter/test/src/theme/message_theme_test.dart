import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

String _dummyFormatter(BuildContext context, DateTime date) => 'formatted';

void main() {
  test('MessageThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamMessageThemeData(), const StreamMessageThemeData().copyWith());
    expect(const StreamMessageThemeData().hashCode, const StreamMessageThemeData().copyWith().hashCode);
  });

  group('MessageThemeData lerps', () {
    test('''Light MessageThemeData lerps completely to dark MessageThemeData''', () {
      expect(
        const StreamMessageThemeData().lerp(_messageThemeControl, _messageThemeControlDark, 1),
        _messageThemeControlDark,
      );
    });

    test('''Dark MessageThemeData lerps completely to light MessageThemeData''', () {
      expect(
        const StreamMessageThemeData().lerp(_messageThemeControlDark, _messageThemeControl, 1),
        _messageThemeControl,
      );
    });
  });

  test('Merging dark and light themes results in a dark theme', () {
    expect(_messageThemeControl.merge(_messageThemeControlDark), _messageThemeControlDark);
  });
}

final _messageThemeControl = StreamMessageThemeData(
  messageAuthorStyle: const StreamTextTheme.light().footnote.copyWith(
    color: const StreamColorTheme.light().textLowEmphasis,
  ),
  messageTextStyle: const StreamTextTheme.light().body,
  createdAtStyle: const StreamTextTheme.light().footnote.copyWith(
    color: const StreamColorTheme.light().textLowEmphasis,
  ),
  createdAtFormatter: _dummyFormatter,
  repliesStyle: const StreamTextTheme.light().footnoteBold.copyWith(
    color: const StreamColorTheme.light().accentPrimary,
  ),
  messageBackgroundColor: const StreamColorTheme.light().disabled,
  reactionsBackgroundColor: const StreamColorTheme.light().barsBg,
  reactionsBorderColor: const StreamColorTheme.light().borders,
  reactionsMaskColor: const StreamColorTheme.light().appBg,
  messageBorderColor: const StreamColorTheme.light().disabled,
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 32,
      width: 32,
    ),
  ),
  messageLinksStyle: TextStyle(
    color: const StreamColorTheme.light().accentPrimary,
  ),
  urlAttachmentBackgroundColor: const StreamColorTheme.light().linkBg,
);

final _messageThemeControlDark = StreamMessageThemeData(
  messageAuthorStyle: const StreamTextTheme.dark().footnote.copyWith(
    color: const StreamColorTheme.dark().textLowEmphasis,
  ),
  messageTextStyle: const StreamTextTheme.dark().body,
  createdAtStyle: const StreamTextTheme.dark().footnote.copyWith(
    color: const StreamColorTheme.dark().textLowEmphasis,
  ),
  createdAtFormatter: _dummyFormatter,
  repliesStyle: const StreamTextTheme.dark().footnoteBold.copyWith(
    color: const StreamColorTheme.dark().accentPrimary,
  ),
  messageBackgroundColor: const StreamColorTheme.dark().disabled,
  reactionsBackgroundColor: const StreamColorTheme.dark().barsBg,
  reactionsBorderColor: const StreamColorTheme.dark().borders,
  reactionsMaskColor: const StreamColorTheme.dark().appBg,
  messageBorderColor: const StreamColorTheme.dark().disabled,
  avatarTheme: StreamAvatarThemeData(
    borderRadius: BorderRadius.circular(20),
    constraints: const BoxConstraints.tightFor(
      height: 32,
      width: 32,
    ),
  ),
  messageLinksStyle: TextStyle(
    color: const StreamColorTheme.dark().accentPrimary,
  ),
  urlAttachmentBackgroundColor: const StreamColorTheme.dark().linkBg,
);
