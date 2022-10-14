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
    this.onEnterKeypress,
    this.onEscapeKeypress,
    this.onRightArrowKeypress,
    this.onLeftArrowKeypress,
  });

  /// This child of this widget.
  final Widget child;

  /// The function to execute when the "enter" key is pressed.
  final VoidCallback? onEnterKeypress;

  /// The function to execute when the "escape" key is pressed.
  final VoidCallback? onEscapeKeypress;

  /// The function to execute when the "right arrow" key is pressed.
  final VoidCallback? onRightArrowKeypress;

  /// The function to execute when the "left arrow" key is pressed.
  final VoidCallback? onLeftArrowKeypress;

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
      autofocus: true,
      shortcuts: {
        if (onEnterKeypress != null) enterKeySet: EnterKeyIntent(),
        if (onEscapeKeypress != null) escapeKeySet: EscapeKeyIntent(),
        if (onRightArrowKeypress != null)
          rightArrowKeySet: RightArrowKeyIntent(),
        if (onLeftArrowKeypress != null) leftArrowKeySet: LeftArrowKeyIntent(),
      },
      actions: {
        EnterKeyIntent: CallbackAction(
          onInvoke: (e) => onEnterKeypress?.call(),
        ),
        EscapeKeyIntent: CallbackAction(
          onInvoke: (e) => onEscapeKeypress?.call(),
        ),
        RightArrowKeyIntent: CallbackAction(
          onInvoke: (e) => onRightArrowKeypress?.call(),
        ),
        LeftArrowKeyIntent: CallbackAction(
          onInvoke: (e) => onLeftArrowKeypress?.call(),
        ),
      },
      child: child,
    );
  }
}
