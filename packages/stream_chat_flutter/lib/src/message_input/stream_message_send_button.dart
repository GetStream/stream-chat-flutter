import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/stream_message_input_icon_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that displays a sending button.
class StreamMessageSendButton extends StatelessWidget {
  /// Returns a [StreamMessageSendButton] with the given [timeOut], [isIdle],
  /// [isCommandEnabled], [isEditEnabled], [idleSendButton], [activeSendButton],
  /// [onSendMessage].
  const StreamMessageSendButton({
    super.key,
    this.timeOut = 0,
    this.isIdle = true,
    @Deprecated('Will be removed in the next major version')
    this.isCommandEnabled = false,
    @Deprecated('Will be removed in the next major version')
    this.isEditEnabled = false,
    this.idleSendButton,
    this.activeSendButton,
    required this.onSendMessage,
  });

  /// Time out related to slow mode.
  final int timeOut;

  /// If true the button will be disabled.
  final bool isIdle;

  /// True if a command is being sent.
  @Deprecated('It will be removed in the next major version')
  final bool isCommandEnabled;

  /// True if in editing mode.
  @Deprecated('It will be removed in the next major version')
  final bool isEditEnabled;

  /// The widget to display when the button is disabled.
  final Widget? idleSendButton;

  /// The widget to display when the button is enabled.
  final Widget? activeSendButton;

  /// The callback to call when the button is pressed.
  final VoidCallback onSendMessage;

  @override
  Widget build(BuildContext context) {
    final theme = StreamMessageInputTheme.of(context);

    final button = _buildButton(context);
    return AnimatedSwitcher(
      duration: theme.sendAnimationDuration!,
      child: button,
    );
  }

  Widget _buildButton(BuildContext context) {
    if (timeOut > 0) {
      return StreamCountdownButton(
        key: const Key('countdown_button'),
        count: timeOut,
      );
    }

    final idleSendIcon = switch (idleSendButton) {
      final idleButton? => idleButton,
      _ => const StreamSvgIcon(icon: StreamSvgIcons.sendMessage),
    };

    final activeSendIcon = switch (activeSendButton) {
      final activeButton? => activeButton,
      _ => const StreamSvgIcon(icon: StreamSvgIcons.circleUp),
    };

    final theme = StreamMessageInputTheme.of(context);
    final icon = isIdle ? idleSendIcon : activeSendIcon;
    final onPressed = isIdle ? null : onSendMessage;
    return StreamMessageInputIconButton(
      key: const Key('send_button'),
      icon: icon,
      color: theme.sendButtonColor,
      disabledColor: theme.sendButtonIdleColor,
      onPressed: onPressed,
    );
  }
}
