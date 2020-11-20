import 'package:flutter/material.dart';

class NeumorphicButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;

  const NeumorphicButton({
    Key key,
    @required this.child,
    this.backgroundColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: EdgeInsets.all(8.0),
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[700],
            offset: Offset(0, 1.0),
            blurRadius: 0.5,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.white,
            offset: Offset.zero,
            blurRadius: 0.5,
            spreadRadius: 0,
          ),
        ],
      ),
    );
  }
}
