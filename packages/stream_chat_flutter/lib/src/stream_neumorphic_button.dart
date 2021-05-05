import 'package:flutter/material.dart';

/// Neumorphic button
class StreamNeumorphicButton extends StatelessWidget {
  /// Constructor for creating [StreamNeumorphicButton]
  const StreamNeumorphicButton({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  /// Child contained in the button
  final Widget child;

  /// Background color of button
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.all(8),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade700,
              offset: const Offset(0, 1),
              blurRadius: 0.5,
            ),
            const BoxShadow(
              color: Colors.white,
              blurRadius: 0.5,
            ),
          ],
        ),
        child: child,
      );
}
