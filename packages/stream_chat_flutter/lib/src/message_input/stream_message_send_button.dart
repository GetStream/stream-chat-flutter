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
    Widget? idleSendIcon,
    @Deprecated("Use 'idleSendIcon' instead") Widget? idleSendButton,
    Widget? activeSendIcon,
    @Deprecated("Use 'activeSendIcon' instead") Widget? activeSendButton,
    required this.onSendMessage,
  })  : assert(
          idleSendIcon == null || idleSendButton == null,
          'idleSendIcon and idleSendButton cannot be used together',
        ),
        idleSendIcon = idleSendIcon ?? idleSendButton,
        assert(
          activeSendIcon == null || activeSendButton == null,
          'activeSendIcon and activeSendButton cannot be used together',
        ),
        activeSendIcon = activeSendIcon ?? activeSendButton;

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

  /// The icon to display when the button is idle.
  final Widget? idleSendIcon;

  /// The widget to display when the button is disabled.
  @Deprecated("Use 'idleSendIcon' instead")
  Widget? get idleSendButton => idleSendIcon;

  /// The icon to display when the button is active.
  final Widget? activeSendIcon;

  /// The widget to display when the button is enabled.
  @Deprecated("Use 'activeSendIcon' instead")
  Widget? get activeSendButton => activeSendIcon;

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

    final idleIcon = switch (idleSendIcon) {
      final idleIcon? => idleIcon,
      _ => const StreamSvgIcon(icon: StreamSvgIcons.sendMessage),
    };

    final activeIcon = switch (activeSendIcon) {
      final activeIcon? => activeIcon,
      _ => const StreamSvgIcon(icon: StreamSvgIcons.circleUp),
    };

    final theme = StreamMessageInputTheme.of(context);
    final icon = isIdle ? idleIcon : activeIcon;
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
