import 'package:flutter/material.dart';

/// {@template neumorphicButton}
/// Neumorphic button
/// {@endtemplate}
class StreamNeumorphicButton extends StatelessWidget {
  /// {@macro neumorphicButton}
  const StreamNeumorphicButton({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
  });

  /// Child contained in the button
  final Widget child;

  /// Background color of the button
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
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
}
