import 'package:ezanimation/ezanimation.dart';
import 'package:flutter/material.dart';

/// {@template staggeredScaleTransition}
/// A widget that scales in its [children] with a staggered animation.
///
/// Each child pops in sequentially with a configurable [staggerDelay].
///
/// By default, children animate from last to first. Set [animateReversed]
/// to `false` to animate from first to last.
///
/// {@tool snippet}
///
/// ```dart
/// StaggeredScaleTransition(
///   children: [
///     Icon(Icons.star),
///     Icon(Icons.favorite),
///     Icon(Icons.thumb_up),
///   ],
/// )
/// ```
/// {@end-tool}
/// {@endtemplate}
class StaggeredScaleTransition extends StatefulWidget {
  /// {@macro staggeredScaleTransition}
  const StaggeredScaleTransition({
    super.key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 30),
    this.animateReversed = true,
  });

  /// The widgets to display with staggered scale-in animation.
  final List<Widget> children;

  /// The delay between the start of each child's animation.
  ///
  /// Defaults to 30 milliseconds.
  final Duration staggerDelay;

  /// Whether to animate children in reversed list order.
  ///
  /// When `true`, children animate from last to first in list order.
  /// When `false`, children animate from first to last in list order.
  ///
  /// Defaults to `true`.
  final bool animateReversed;

  @override
  State<StaggeredScaleTransition> createState() => _StaggeredScaleTransitionState();
}

class _StaggeredScaleTransitionState extends State<StaggeredScaleTransition> {
  List<EzAnimation> _animations = [];

  void _initAnimations() {
    _animations = List.generate(
      widget.children.length,
      (index) => EzAnimation.tween(
        Tween(begin: 0.0, end: 1.0),
        const Duration(milliseconds: 120),
        curve: Curves.bounceOut,
      ),
    );
  }

  void _triggerAnimations() async {
    final iterable = switch (widget.animateReversed) {
      true => _animations.reversed,
      false => _animations,
    };

    for (final animation in iterable) {
      if (!mounted) return;
      animation.start();
      await Future.delayed(widget.staggerDelay);
    }
  }

  void _dismissAnimations() {
    for (final animation in _animations) {
      animation.stop();
    }
  }

  void _disposeAnimations() {
    for (final animation in _animations) {
      animation.dispose();
    }
  }

  @override
  void initState() {
    super.initState();
    _initAnimations();

    // Trigger animations at the end of the frame to avoid jank.
    WidgetsBinding.instance.endOfFrame.then((_) => _triggerAnimations());
  }

  @override
  void didUpdateWidget(covariant StaggeredScaleTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.children.length != widget.children.length) {
      // Dismiss and dispose old animations.
      _dismissAnimations();
      _disposeAnimations();

      // Initialize new animations.
      _initAnimations();

      // Trigger animations at the end of the frame to avoid jank.
      WidgetsBinding.instance.endOfFrame.then((_) => _triggerAnimations());
    }
  }

  @override
  void dispose() {
    _dismissAnimations();
    _disposeAnimations();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.children.length; i++)
          AnimatedBuilder(
            animation: _animations[i],
            builder: (context, child) {
              final value = _animations[i].value;
              // Width grows at 2x the scale rate so the row reaches full
              // width before the bounce oscillation starts.
              return Align(
                widthFactor: (value * 2.0).clamp(0.0, 1.0),
                heightFactor: 1,
                child: Transform.scale(scale: value, child: child),
              );
            },
            child: widget.children[i],
          ),
      ],
    );
  }
}
