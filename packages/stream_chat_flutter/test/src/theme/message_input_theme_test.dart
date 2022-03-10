import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('MessageInputThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamMessageInputThemeData(),
        const StreamMessageInputThemeData().copyWith());
    expect(const StreamMessageInputThemeData().hashCode,
        const StreamMessageInputThemeData().copyWith().hashCode);
  });

  group('MessageInputThemeData lerps correctly', () {
    test('Lerp completely from light to dark', () {
      expect(
          const StreamMessageInputThemeData().lerp(
              _messageInputThemeControl, _messageInputThemeControlDark, 1),
          _messageInputThemeControlDark);
    });

    test('Lerp halfway from light to dark', () {
      expect(
          const StreamMessageInputThemeData().lerp(
              _messageInputThemeControl, _messageInputThemeControlDark, 0.5),
          _messageInputThemeControlMidLerp);
    });

    test('Lerp completely from dark to light', () {
      expect(
          const StreamMessageInputThemeData().lerp(
              _messageInputThemeControlDark, _messageInputThemeControl, 1),
          _messageInputThemeControl);
    });
  });

  test('Merging two MessageInputThemeData results in the latter', () {
    expect(_messageInputThemeControl.merge(_messageInputThemeControlDark),
        _messageInputThemeControlDark);
  });
}

final _messageInputThemeControl = StreamMessageInputThemeData(
  borderRadius: BorderRadius.circular(20),
  sendAnimationDuration: const Duration(milliseconds: 300),
  actionButtonColor: StreamColorTheme.light().accentPrimary,
  actionButtonIdleColor: StreamColorTheme.light().textLowEmphasis,
  expandButtonColor: StreamColorTheme.light().accentPrimary,
  sendButtonColor: StreamColorTheme.light().accentPrimary,
  sendButtonIdleColor: StreamColorTheme.light().disabled,
  inputBackgroundColor: StreamColorTheme.light().barsBg,
  inputTextStyle: StreamTextTheme.light().body,
  idleBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      StreamColorTheme.light().disabled,
      StreamColorTheme.light().disabled,
    ],
  ),
  activeBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      StreamColorTheme.light().disabled,
      StreamColorTheme.light().disabled,
    ],
  ),
);

final _messageInputThemeControlMidLerp = StreamMessageInputThemeData(
  borderRadius: BorderRadius.circular(20),
  sendAnimationDuration: const Duration(milliseconds: 300),
  inputBackgroundColor: const Color(0xff87898b),
  actionButtonColor: const Color(0xff005fff),
  actionButtonIdleColor: const Color(0xff7a7a7a),
  sendButtonColor: const Color(0xff005fff),
  sendButtonIdleColor: const Color(0xff848585),
  expandButtonColor: const Color(0xff005fff),
  inputTextStyle: const TextStyle(
    color: Color(0xff7f7f7f),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  ),
  idleBorderGradient: const LinearGradient(
    stops: [0.0, 1.0],
    colors: [
      Color(0xff848585),
      Color(0xff848585),
    ],
  ),
  activeBorderGradient: const LinearGradient(
    stops: [0.0, 1.0],
    colors: [
      Color(0xff848585),
      Color(0xff848585),
    ],
  ),
);

final _messageInputThemeControlDark = StreamMessageInputThemeData(
  borderRadius: BorderRadius.circular(20),
  sendAnimationDuration: const Duration(milliseconds: 300),
  actionButtonColor: StreamColorTheme.dark().accentPrimary,
  actionButtonIdleColor: StreamColorTheme.dark().textLowEmphasis,
  expandButtonColor: StreamColorTheme.dark().accentPrimary,
  sendButtonColor: StreamColorTheme.dark().accentPrimary,
  sendButtonIdleColor: StreamColorTheme.dark().disabled,
  inputBackgroundColor: StreamColorTheme.dark().barsBg,
  inputTextStyle: StreamTextTheme.dark().body,
  idleBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      StreamColorTheme.dark().disabled,
      StreamColorTheme.dark().disabled,
    ],
  ),
  activeBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      StreamColorTheme.dark().disabled,
      StreamColorTheme.dark().disabled,
    ],
  ),
);
