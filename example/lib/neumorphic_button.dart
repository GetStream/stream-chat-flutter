import 'package:flutter/material.dart';

extension ColorUtils on Color {
  Color mix(Color another, double amount) {
    return Color.lerp(this, another, amount);
  }
}

class NeumorphicButton extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const NeumorphicButton({
    Key key,
    @required this.child,
    this.backgroundColor = Colors.white,
    this.margin = const EdgeInsets.all(8),
    this.padding = const EdgeInsets.all(14),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: child,
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              backgroundColor.mix(Colors.white, 0.2),
              backgroundColor.mix(Colors.black, 0.1),
            ]),
        boxShadow: [
          BoxShadow(
            blurRadius: 1,
            color: backgroundColor.mix(Colors.white, 0.6),
          ),
          BoxShadow(
            blurRadius: 1,
            color: backgroundColor.mix(Colors.black, 0.3),
          )
        ],
      ),
    );
  }
}
