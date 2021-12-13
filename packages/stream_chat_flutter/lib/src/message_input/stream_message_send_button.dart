import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// A widget that displays a sending button.
class StreamMessageSendButton extends StatelessWidget {
  /// Returns a [StreamMessageSendButton] with the given [timeOut], [isIdle],
  /// [isCommandEnabled], [isEditEnabled], [idleSendButton], [activeSendButton],
  /// [onSendMessage].
  const StreamMessageSendButton({
    Key? key,
    this.timeOut = 0,
    this.isIdle = true,
    this.isCommandEnabled = false,
    this.isEditEnabled = false,
    this.idleSendButton,
    this.activeSendButton,
    required this.onSendMessage,
  }) : super(key: key);

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
      sendButton = CountdownButton(count: timeOut);
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
    final _messageInputTheme = MessageInputTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: StreamSvgIcon(
        assetName: _getIdleSendIcon(),
        color: _messageInputTheme.sendButtonIdleColor,
      ),
    );
  }

  Widget _buildSendButton(BuildContext context) {
    final _messageInputTheme = MessageInputTheme.of(context);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: IconButton(
        onPressed: onSendMessage,
        padding: const EdgeInsets.all(0),
        splashRadius: 24,
        constraints: const BoxConstraints.tightFor(
          height: 24,
          width: 24,
        ),
        icon: StreamSvgIcon(
          assetName: _getSendIcon(),
          color: _messageInputTheme.sendButtonColor,
        ),
      ),
    );
  }

  String _getIdleSendIcon() {
    if (isCommandEnabled) {
      return 'Icon_search.svg';
    } else {
      return 'Icon_circle_right.svg';
    }
  }

  String _getSendIcon() {
    if (isEditEnabled) {
      return 'Icon_circle_up.svg';
    } else if (isCommandEnabled) {
      return 'Icon_search.svg';
    } else {
      return 'Icon_circle_up.svg';
    }
  }
}
