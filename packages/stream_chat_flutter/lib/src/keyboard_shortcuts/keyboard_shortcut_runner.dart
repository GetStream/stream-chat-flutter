import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/keyboard_shortcuts/intents.dart';
import 'package:stream_chat_flutter/src/keyboard_shortcuts/keysets.dart';

/// A widget that executes functions when specific physical keyboard shortcuts
/// are performed.
class KeyboardShortcutRunner extends StatelessWidget {
  /// Builds a [KeyboardShortcutRunner].
  const KeyboardShortcutRunner({
    super.key,
    required this.child,
    required this.onEnterKeypress,
    required this.onEscapeKeypress,
  });

  /// This child of this widget.
  final Widget child;

  /// The function to execute when the "enter" key is pressed.
  final VoidCallback onEnterKeypress;

  /// The function to execute when the "escape" key is pressed.
  final VoidCallback onEscapeKeypress;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        sendMessageKeySet: SendMessageIntent(),
        removeReplyKeySet: RemoveReplyIntent(),
      },
      actions: {
        SendMessageIntent: CallbackAction(
          onInvoke: (e) => onEnterKeypress.call(),
        ),
        RemoveReplyIntent: CallbackAction(
          onInvoke: (e) => onEscapeKeypress.call(),
        ),
      },
      child: child,
    );
  }
}
