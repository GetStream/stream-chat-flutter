import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('MessageInputThemeData copyWith, ==, hashCode basics', () {
    expect(const StreamMessageInputThemeData(), const StreamMessageInputThemeData().copyWith());
    expect(const StreamMessageInputThemeData().hashCode, const StreamMessageInputThemeData().copyWith().hashCode);
  });

  group('MessageInputThemeData lerps correctly', () {
    test('Lerp completely from light to dark', () {
      expect(
        const StreamMessageInputThemeData().lerp(_messageInputThemeControl, _messageInputThemeControlDark, 1),
        _messageInputThemeControlDark,
      );
    });

    test('Lerp halfway from light to dark', () {
      expect(
        const StreamMessageInputThemeData().lerp(
          _messageInputThemeControl,
          _messageInputThemeControlDark,
          0.5,
        ),
        _messageInputThemeControlMidLerp,
        // TODO: Remove skip, once we drop support for flutter v3.24.0
        skip: true,
        reason: 'Currently failing in flutter v3.27.0 due to new color alpha',
      );
    });

    test('Lerp completely from dark to light', () {
      expect(
        const StreamMessageInputThemeData().lerp(_messageInputThemeControlDark, _messageInputThemeControl, 1),
        _messageInputThemeControl,
      );
    });
  });

  test('Merging two MessageInputThemeData results in the latter', () {
    expect(_messageInputThemeControl.merge(_messageInputThemeControlDark), _messageInputThemeControlDark);
  });
}

final _messageInputThemeControl = StreamMessageInputThemeData(
  borderRadius: BorderRadius.circular(20),
  sendAnimationDuration: const Duration(milliseconds: 300),
  actionButtonColor: const StreamColorTheme.light().accentPrimary,
  actionButtonIdleColor: const StreamColorTheme.light().textLowEmphasis,
  expandButtonColor: const StreamColorTheme.light().accentPrimary,
  sendButtonColor: const StreamColorTheme.light().accentPrimary,
  sendButtonIdleColor: const StreamColorTheme.light().disabled,
  inputBackgroundColor: const StreamColorTheme.light().barsBg,
  inputTextStyle: const StreamTextTheme.light().body,
  idleBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      const StreamColorTheme.light().disabled,
      const StreamColorTheme.light().disabled,
    ],
  ),
  activeBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      const StreamColorTheme.light().disabled,
      const StreamColorTheme.light().disabled,
    ],
  ),
);

final _messageInputThemeControlMidLerp = StreamMessageInputThemeData(
  borderRadius: BorderRadius.circular(20),
  sendAnimationDuration: const Duration(milliseconds: 300),
  inputBackgroundColor: const Color(0xff88898a),
  actionButtonColor: const Color(0xff196eff),
  actionButtonIdleColor: const Color(0xff7a7a7a),
  sendButtonColor: const Color(0xff196eff),
  sendButtonIdleColor: const Color(0xff848585),
  expandButtonColor: const Color(0xff196eff),
  inputTextStyle: const TextStyle(
    color: Color(0xff7f7f7f),
    fontSize: 14,
    fontWeight: FontWeight.w400,
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
  actionButtonColor: const StreamColorTheme.dark().accentPrimary,
  actionButtonIdleColor: const StreamColorTheme.dark().textLowEmphasis,
  expandButtonColor: const StreamColorTheme.dark().accentPrimary,
  sendButtonColor: const StreamColorTheme.dark().accentPrimary,
  sendButtonIdleColor: const StreamColorTheme.dark().disabled,
  inputBackgroundColor: const StreamColorTheme.dark().barsBg,
  inputTextStyle: const StreamTextTheme.dark().body,
  idleBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      const StreamColorTheme.dark().disabled,
      const StreamColorTheme.dark().disabled,
    ],
  ),
  activeBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      const StreamColorTheme.dark().disabled,
      const StreamColorTheme.dark().disabled,
    ],
  ),
);
