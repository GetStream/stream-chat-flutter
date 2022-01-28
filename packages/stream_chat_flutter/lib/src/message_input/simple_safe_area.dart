import 'package:flutter/material.dart';

/// A [SafeArea] with an enabled toggle
class SimpleSafeArea extends StatefulWidget {
  /// Constructor for [SimpleSafeArea]
  const SimpleSafeArea({
    Key? key,
    this.enabled = true,
    required this.child,
  }) : super(key: key);

  final bool enabled;
  final Widget child;

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
