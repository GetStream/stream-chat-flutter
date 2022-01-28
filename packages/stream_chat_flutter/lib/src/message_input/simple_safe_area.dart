import 'package:flutter/material.dart';

class SimpleSafeArea extends StatefulWidget {
  final bool enabled;
  final Widget child;

  const SimpleSafeArea({
    Key? key,
    this.enabled = true,
    required this.child,
  }) : super(key: key);

  @override
  _SimpleSafeAreaState createState() => _SimpleSafeAreaState();
}

class _SimpleSafeAreaState extends State<SimpleSafeArea> {
  @override
  Widget build(BuildContext context) => SafeArea(
        left: widget.enabled,
        top: widget.enabled,
        right: widget.enabled,
        bottom: widget.enabled,
        child: widget.child,
      );
}
