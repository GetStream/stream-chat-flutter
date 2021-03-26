import 'package:flutter/material.dart';

class SimpleFrame extends StatelessWidget {
  final Widget child;

  const SimpleFrame({Key key, @required this.child}) : super(key: key);

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
