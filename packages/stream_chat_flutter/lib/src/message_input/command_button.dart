import 'package:flutter/material.dart';

/// {@template commandButton}
/// The button that allows a user to use commands in a chat.
/// {@endtemplate}
class CommandButton extends StatelessWidget {
  /// {@macro commandButton}
  const CommandButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  /// The icon to use.
  final Widget icon;

  /// The action to perform when the button is pressed or clicked.
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: icon,
      padding: const EdgeInsets.all(0),
      constraints: const BoxConstraints.tightFor(
        height: 24,
        width: 24,
      ),
      splashRadius: 24,
      onPressed: onPressed,
    );
  }
}
