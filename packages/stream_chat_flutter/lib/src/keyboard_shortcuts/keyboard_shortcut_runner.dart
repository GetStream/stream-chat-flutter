import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/src/keyboard_shortcuts/intents.dart';
import 'package:stream_chat_flutter/src/keyboard_shortcuts/keysets.dart';

/// A widget that executes functions when specific physical keyboard shortcuts
/// are performed.
class KeyboardShortcutRunner extends StatelessWidget {
  /// Builds a [KeyboardShortcutRunner].
  const KeyboardShortcutRunner({
    Key? key,
    required this.child,
    required this.onEnterKeypress,
  }) : super(key: key);

  /// This child of this widget.
  final Widget child;

  /// The function to execute when the "enter" key is pressed.
  final VoidCallback onEnterKeypress;

  @override
  Widget build(BuildContext context) => FocusableActionDetector(
        autofocus: true,
        shortcuts: {
          sendMessageKeySet: SendMessageIntent(),
        },
        actions: {
          SendMessageIntent: CallbackAction(
            onInvoke: (e) => onEnterKeypress.call(),
          ),
        },
        child: child,
      );
}
