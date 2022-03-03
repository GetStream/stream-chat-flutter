import 'package:flutter/material.dart';

class CommandButton extends StatelessWidget {
  const CommandButton({
    Key? key,
    required this.icon,
    required this.onPressed,
  }) : super(key: key);

  final Widget icon;
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
