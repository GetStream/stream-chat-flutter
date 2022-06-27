// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/message_input/send_button.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

/// {@template animatedSendButton}
/// The button for sending a message. It animates between several states
/// depending on:
/// * If there is a cooldown enabled or not
/// * If there is a message present in the [MessageInput] and whether there
/// are any attachments ready to upload
///
/// Used in [MessageInput].
/// {@endtemplate}
class AnimatedSendButton extends StatelessWidget {
  /// {@macro animatedSendButton}
  const AnimatedSendButton({
    super.key,
    required this.cooldown,
    required this.messageIsPresent,
    required this.attachmentsIsEmpty,
    required this.messageInputTheme,
    required this.onTap,
    required this.commandEnabled,
    this.editMessage,
    this.idleSendButton,
    this.activeSendButton,
  });

  /// The amount of time for the cooldown, measured in seconds.
  final int cooldown;

  /// If there is a message present in the [MessageInput] field.
  final bool messageIsPresent;

  /// If there are any attachments ready to be uploaded via [MessageInput].
  final bool attachmentsIsEmpty;

  /// The theme currently used for [MessageInput].
  final StreamMessageInputThemeData messageInputTheme;

  /// The callback to perform when the button is tapped or clicked.
  final VoidCallback onTap;

  /// If commands are enabled.
  final bool commandEnabled;

  /// The message being edited, if there is one.
  final Message? editMessage;

  /// Send button widget in an idle state.
  final Widget? idleSendButton;

  /// Send button widget in an active state.
  final Widget? activeSendButton;

  @override
  Widget build(BuildContext context) {
    late Widget sendButton;
    if (cooldown > 0) {
      sendButton = StreamCountdownButton(count: cooldown);
    } else if (!messageIsPresent && attachmentsIsEmpty) {
      sendButton = idleSendButton ??
          Padding(
            padding: const EdgeInsets.all(8),
            child: StreamSvgIcon(
              assetName: _getIdleSendIcon(),
              color: messageInputTheme.sendButtonIdleColor,
            ),
          );
    } else {
      sendButton = activeSendButton != null
          ? InkWell(
              onTap: onTap,
              child: activeSendButton,
            )
          : SendButton(
              assetName: _getSendIcon(),
              color: messageInputTheme.sendButtonColor!,
              onPressed: onTap,
            );
    }

    return AnimatedSwitcher(
      duration: messageInputTheme.sendAnimationDuration!,
      child: sendButton,
    );
  }

  /// Returns the proper idle send icon.
  String _getIdleSendIcon() {
    if (commandEnabled) {
      return 'Icon_search.svg';
    } else {
      return 'Icon_circle_right.svg';
    }
  }

  /// Returns the proper send icon.
  String _getSendIcon() {
    if (editMessage != null) {
      return 'Icon_circle_up.svg';
    } else if (commandEnabled) {
      return 'Icon_search.svg';
    } else {
      return 'Icon_circle_up.svg';
    }
  }
}
