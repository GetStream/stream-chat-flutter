import 'package:flutter/material.dart';

class StreamNeumorphicButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const StreamNeumorphicButton({
    Key? key,
    required this.child,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade700,
            offset: Offset(0, 1),
            blurRadius: 0.5,
          ),
          BoxShadow(
            color: Colors.white,
            blurRadius: 0.5,
          ),
        ],
      ),
      child: child,
    );
  }
}
