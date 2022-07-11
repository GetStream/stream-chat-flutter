import 'package:flutter/material.dart';

class SimpleFrame extends StatelessWidget {
  const SimpleFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(color: const Color(0xFF9E9E9E)),
      ),
      child: child,
    );
  }
}
