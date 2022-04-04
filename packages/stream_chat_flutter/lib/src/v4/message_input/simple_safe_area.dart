import 'package:flutter/material.dart';

/// A [SafeArea] with an enabled toggle
class SimpleSafeArea extends StatelessWidget {
  /// Constructor for [SimpleSafeArea]
  const SimpleSafeArea({
    Key? key,
    this.enabled = true,
    required this.child,
  }) : super(key: key);

  /// Wrap [child] with [SafeArea]
  final bool enabled;

  /// Child widget to wrap
  final Widget child;

  @override
  Widget build(BuildContext context) => SafeArea(
        left: enabled,
        top: enabled,
        right: enabled,
        bottom: enabled,
        child: child,
      );
}
