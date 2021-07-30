import 'package:flutter/material.dart' hide TextTheme;
import 'package:flutter_test/flutter_test.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

void main() {
  test('MessageInputThemeData copyWith, ==, hashCode basics', () {
    expect(const MessageInputThemeData(),
        const MessageInputThemeData().copyWith());
    expect(const MessageInputThemeData().hashCode,
        const MessageInputThemeData().copyWith().hashCode);
  });

  group('MessageInputThemeData lerps correctly', () {
    test('Lerp completely from light to dark', () {
      expect(
          const MessageInputThemeData().lerp(
              _messageInputThemeControl, _messageInputThemeControlDark, 1),
          _messageInputThemeControlDark);
    });

    test('Lerp completely from dark to light', () {
      expect(
          const MessageInputThemeData().lerp(
              _messageInputThemeControlDark, _messageInputThemeControl, 1),
          _messageInputThemeControl);
    });
  });
}

final _messageInputThemeControl = MessageInputThemeData(
  borderRadius: BorderRadius.circular(20),
  sendAnimationDuration: const Duration(milliseconds: 300),
  actionButtonColor: ColorTheme.light().accentPrimary,
  actionButtonIdleColor: ColorTheme.light().textLowEmphasis,
  expandButtonColor: ColorTheme.light().accentPrimary,
  sendButtonColor: ColorTheme.light().accentPrimary,
  sendButtonIdleColor: ColorTheme.light().disabled,
  inputBackgroundColor: ColorTheme.light().barsBg,
  inputTextStyle: TextTheme.light().body,
  idleBorderGradient: LinearGradient(
    colors: [
      ColorTheme.light().disabled,
      ColorTheme.light().disabled,
    ],
  ),
  activeBorderGradient: LinearGradient(
    colors: [
      ColorTheme.light().disabled,
      ColorTheme.light().disabled,
    ],
  ),
);

final _messageInputThemeControlMidLerp = MessageInputThemeData(
  borderRadius: BorderRadius.circular(20),
  sendAnimationDuration: const Duration(milliseconds: 300),
  actionButtonColor: ColorTheme.light().accentPrimary,
  actionButtonIdleColor: ColorTheme.light().textLowEmphasis,
  expandButtonColor: ColorTheme.light().accentPrimary,
  sendButtonColor: ColorTheme.light().accentPrimary,
  sendButtonIdleColor: ColorTheme.light().disabled,
  inputBackgroundColor: ColorTheme.light().barsBg,
  inputTextStyle: TextTheme.light().body,
  idleBorderGradient: LinearGradient(
    colors: [
      ColorTheme.light().disabled,
      ColorTheme.light().disabled,
    ],
  ),
  activeBorderGradient: LinearGradient(
    colors: [
      ColorTheme.light().disabled,
      ColorTheme.light().disabled,
    ],
  ),
);

final _messageInputThemeControlDark = MessageInputThemeData(
  borderRadius: BorderRadius.circular(20),
  sendAnimationDuration: const Duration(milliseconds: 300),
  actionButtonColor: ColorTheme.dark().accentPrimary,
  actionButtonIdleColor: ColorTheme.dark().textLowEmphasis,
  expandButtonColor: ColorTheme.dark().accentPrimary,
  sendButtonColor: ColorTheme.dark().accentPrimary,
  sendButtonIdleColor: ColorTheme.dark().disabled,
  inputBackgroundColor: ColorTheme.dark().barsBg,
  inputTextStyle: TextTheme.dark().body,
  idleBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      ColorTheme.dark().disabled,
      ColorTheme.dark().disabled,
    ],
  ),
  activeBorderGradient: LinearGradient(
    stops: const [0.0, 1.0],
    colors: [
      ColorTheme.dark().disabled,
      ColorTheme.dark().disabled,
    ],
  ),
);
