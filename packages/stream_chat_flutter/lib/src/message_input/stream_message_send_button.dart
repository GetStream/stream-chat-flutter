import 'package:flutter/material.dart';
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
    this.isCommandEnabled = false,
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
  final bool isCommandEnabled;

  /// True if in editing mode.
  final bool isEditEnabled;

  /// The widget to display when the button is disabled.
  final Widget? idleSendButton;

  /// The widget to display when the button is enabled.
  final Widget? activeSendButton;

  /// The callback to call when the button is pressed.
  final VoidCallback onSendMessage;

  @override
  Widget build(BuildContext context) {
    final _streamChatTheme = StreamChatTheme.of(context);

    late Widget sendButton;
    if (timeOut > 0) {
      sendButton = StreamCountdownButton(count: timeOut);
    } else if (isIdle) {
      sendButton = idleSendButton ?? _buildIdleSendButton(context);
    } else {
      sendButton = activeSendButton != null
          ? InkWell(
              onTap: onSendMessage,
              child: activeSendButton,
            )
          : _buildSendButton(context);
    }

    return AnimatedSwitcher(
      duration: _streamChatTheme.messageInputTheme.sendAnimationDuration!,
      child: sendButton,
    );
  }

  Widget _buildIdleSendButton(BuildContext context) {
    final _messageInputTheme = StreamMessageInputTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: StreamSvgIcon(
        icon: _getIdleSendIcon(),
        color: _messageInputTheme.sendButtonIdleColor,
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    final _messageInputTheme = StreamMessageInputTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: IconButton(
        onPressed: onSendMessage,
        padding: EdgeInsets.zero,
        splashRadius: 24,
        constraints: const BoxConstraints.tightFor(
          height: 24,
          width: 24,
        ),
        icon: StreamSvgIcon(
          icon: _getSendIcon(),
          color: _messageInputTheme.sendButtonColor,
        ),
      ),
    );
  }

  StreamSvgIconData _getIdleSendIcon() {
    if (isCommandEnabled) return StreamSvgIcons.search;
    return StreamSvgIcons.emptyCircleRight;
  }

  StreamSvgIconData _getSendIcon() {
    if (isEditEnabled) return StreamSvgIcons.circleUp;
    if (isCommandEnabled) return StreamSvgIcons.search;
    return StreamSvgIcons.circleUp;
  }
}
